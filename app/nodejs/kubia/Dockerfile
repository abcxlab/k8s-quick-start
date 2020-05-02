#FROM node:7
FROM node:lts-alpine3.11
RUN apk update 
RUN apk upgrade 
RUN apk add bash
ADD app.js /app.js
ENTRYPOINT ["node", "app.js"]

