FROM rust:1.59.0 as builder

WORKDIR /app

RUN apt update && apt install lld clang -y

COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release

FROM debian:bullseye-slim as runtime

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends && \
    openssl && \
    ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/zero2prod zero2prod
COPY configuration configuration
ENV APP_ENVIRONMENT production

ENTRYPOINT [ "./zero2prod" ]