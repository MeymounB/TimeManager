FROM elixir:latest

# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client && \
    apt-get clean

ADD . /app
WORKDIR /app

RUN groupadd -r apigroup && useradd -r -g apigroup apiuser
RUN chown -R apiuser:apigroup /app
RUN usermod -d /app apiuser
USER apiuser

# Install Phoenix packages: https://hexdocs.pm/phoenix/installation.html
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.5.1

ENV MIX_ENV=prod


RUN mix deps.get --only prod
RUN mix compile
RUN echo $SECRET_KEY_BASE

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
