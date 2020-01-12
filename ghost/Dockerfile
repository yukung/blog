FROM ghost:3.2

WORKDIR $GHOST_INSTALL/current
RUN yarn add ghost-v3-google-cloud-storage && \
    cp -rv ./node_modules/ghost-v3-google-cloud-storage ./core/server/adapters/storage/gcs
WORKDIR $GHOST_INSTALL
