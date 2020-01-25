FROM bitwalker/alpine-elixir-phoenix:latest

COPY . .

RUN export MIX_ENV=prod && \
    rm -rf _build && \
    mix deps.get && \
    mix release microcosm

RUN APP_NAME="microcosm" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*` && \
    mkdir /export && \
    cp -r _build/prod/rel/microcosm/releases/0.1/ /export

ENTRYPOINT ["_build/prod/rel/microcosm/bin/microcosm"]
CMD ["start"]
