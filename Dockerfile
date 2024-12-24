FROM docker.io/rustlang/rust:slim as builder
WORKDIR /build
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
# Cache dependencies by making a fake project
COPY Cargo.toml Cargo.toml
RUN mkdir src && touch src/lib.rs && cargo build --release && rm -rf src
# Actually copy the project and build it
COPY . .
RUN cargo build --release
# Deploy the project
FROM docker.io/rustlang/rust:slim
WORKDIR /app
RUN apt-get update && apt-get install -y ca-certificates libssl3 openssl && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/target/release/s2fa /app/s2fa
CMD ["./s2fa"]
