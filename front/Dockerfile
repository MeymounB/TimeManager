# base image
FROM node:14-alpine



# set working directory
ADD . /app
WORKDIR /app

RUN addgroup -S webgroup && adduser -S webuser -G webgroup
RUN chown -R webuser:webgroup /app
USER webuser

RUN npm install

EXPOSE 5173

# start app
CMD ["npm", "run", "dev"]
