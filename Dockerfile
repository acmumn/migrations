FROM rust:latest
RUN cargo install diesel_cli --no-default-features --features mysql

FROM mariadb:latest
WORKDIR /root
COPY --from=0 /root/.cargo/bin/diesel-cli /usr/local/bin/diesel-cli
COPY . .
RUN diesel database reset
