#imbuenetwork/polkadot:latest 
FROM paritytech/ci-linux:production as builder

LABEL maintainer="imbue-dev"
ARG RUST_VERSION=1.53.0
ARG PROFILE=release
ARG DOT_GIT_REPO="https://github.com/ImbueNetwork/polkadot.git"
ARG DOT_BRANCH="master"

RUN rm -rf /usr/local/rustup/toolchains/
RUN rustup default stable
RUN rustup update nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly

#Build Polkadot
WORKDIR /builds/
RUN git clone --recursive ${DOT_GIT_REPO}
WORKDIR /builds/polkadot
RUN git checkout ${DOT_BRANCH}
RUN cargo build --${PROFILE}
RUN cp target/${PROFILE}/polkadot /polkadot

ARG SUBKEY_VERSION=2.0.1

# build subkey
RUN cargo install --force subkey --git https://github.com/paritytech/substrate --version ${SUBKEY_VERSION} --locked
RUN cp /usr/local/cargo/bin/subkey /subkey


WORKDIR /builds/
RUN git clone --recursive ${DATA_FETECHER_REPO}
WORKDIR /builds/sample-data-fetcher
RUN cargo build --${PROFILE}
RUN cp target/${PROFILE}/data_fetcher /data_fetcher