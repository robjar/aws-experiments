FROM node:16-alpine

WORKDIR /app
ADD src/node_modules node_modules/
ADD src/index.js index.js

EXPOSE 3000
ENTRYPOINT node index.js