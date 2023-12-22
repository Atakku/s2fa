// Copyright 2023 Atakku <https://atakku.dev>
//
// This project is dual licensed under MIT and Apache.

use actix_web::{get, App, HttpServer};

use steam_totp::{generate_auth_code, Secret, Time};

pub type Res<T> = Result<T, Box<dyn std::error::Error>>;

#[get("/")]
async fn gen_code() -> Res<String> {
    let time = Time::with_offset().await?;
    let secret = Secret::from_b64(&std::env::var("SECRET")?)?;
    Ok(generate_auth_code(secret, time))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(gen_code))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}
