FROM node:16

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./
COPY yarn.lock ./

USER node

RUN yarn install

COPY --chown=node:node . .

ENV NODE_ENV production

RUN npm run build

EXPOSE 3000

CMD [ "npm", "run", "start:server" ]