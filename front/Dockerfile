FROM node:18-alpine
LABEL authors="jbrizard"

WORKDIR /app

COPY ./package-lock.json .
COPY ./package.json .

RUN npm install
COPY . .
RUN npm run build

CMD ["npm", "run", "start"]
