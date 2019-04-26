FROM node:latest

ENV APP_PORT=3000 APP_DIR=/fortuneapp

WORKDIR ${APP_DIR}

ADD main.js .
ADD package.json .
ADD package-lock.json .
ADD public public
ADD views views

RUN npm install

EXPOSE ${APP_PORT}

HEALTHCHECK --interval=1m --timeout=5s --start-period=5s \
	CMD curl -f http://localhost/health || exit 1

ENTRYPOINT [ "node", "main.js" ]
