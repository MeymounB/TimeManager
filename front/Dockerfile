FROM oven/bun
LABEL authors="jbrizard"

WORKDIR /app

COPY ./bun.lockb .
COPY ./package.json .

RUN bun install
COPY . .
RUN bun run build

CMD ["bun", "run", "start"]
