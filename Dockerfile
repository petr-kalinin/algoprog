FROM node:16

RUN mkdir -p /home/node/app/node_modules
RUN mkdir -p /home/node/app/.yarn/releases
RUN chown -R node:node /home/node/app

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