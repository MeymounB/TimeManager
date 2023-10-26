# base image
FROM node:14-alpine

ADD . /app

# set working directory
WORKDIR /app

RUN npm install

EXPOSE 5173

# start app
CMD ["npm", "run", "dev"]
