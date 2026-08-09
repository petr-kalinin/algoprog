FROM node:16

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Russian Trusted Root CA so Node.js (via --use-openssl-ca) accepts
# certificates signed by it (e.g. securepay.tinkoff.ru).
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -fsSL -o /usr/local/share/ca-certificates/russian_trusted_root_ca.crt \
       https://gu-st.ru/content/lending/russian_trusted_root_ca_pem.crt \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Tell Node.js to use the OS OpenSSL CA store (which now includes the Russian CA)
# instead of its bundled CA bundle.
ENV NODE_OPTIONS=--use-openssl-ca


RUN mkdir -p /home/node/app/node_modules && \
    mkdir -p /home/node/app/.yarn/releases && \
    chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./
COPY yarn.lock ./
COPY .yarnrc.yml ./
COPY .yarn/releases/* ./.yarn/releases

USER node

RUN yarn install

COPY --chown=node:node . .

ENV NODE_ENV production

RUN yarn run build

EXPOSE 3000

CMD [ "yarn", "run", "start:server" ]