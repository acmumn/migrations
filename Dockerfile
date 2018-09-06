# Using this instead of the rust one so libmysqlclient is the same version.
FROM mariadb:latest
ENV RUSTUP_HOME=/usr/local/rustup CARGO_HOME=/usr/local/cargo PATH=/usr/local/cargo/bin:$PATH
WORKDIR /tmp
RUN apt-get update && \
	apt-get install -y build-essential libmysqlclient-dev wget && \
	wget "https://static.rust-lang.org/rustup/archive/1.13.0/x86_64-unknown-linux-gnu/rustup-init" && \
	echo "f69dafcca62fe70d7882113e21bb96a2cbdf4fc4636d25337d6de9191bdec8da *rustup-init" | sha256sum -c - && \
	chmod +x rustup-init && \
	./rustup-init -y --no-modify-path --default-toolchain stable && \
	rm rustup-init && \
	rm -rf /var/list/apt/lists/*
RUN cargo install diesel_cli --no-default-features --features mysql

FROM mariadb:latest
COPY --chown=mysql:mysql --from=0 /usr/local/cargo/bin/diesel /usr/local/bin/diesel
COPY --chown=mysql:mysql initdb.sh /docker-entrypoint-initdb.d/diesel.sh
COPY --chown=mysql:mysql Cargo.toml /diesel/
COPY --chown=mysql:mysql migrations /diesel/migrations/
