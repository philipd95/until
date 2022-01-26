use axum::{
    body::Body,
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::{get, post},
    Json, Router,
};

use serde::{Deserialize, Serialize};
use std::net::SocketAddr;

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(root))
        .route("/add-event", post(add_event));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

// basic handler that responds with a static string
async fn root() -> &'static str {
    "Hello, World! This is Until Backend ⏱"
}

async fn add_event(Json(payload): Json<Event>) -> impl IntoResponse {
    Response::builder()
        .status(StatusCode::CREATED)
        .body(Body::from(format!("added: {}", payload.title)))
        .unwrap()
}

#[derive(Serialize, Deserialize, Debug)]
struct Event {
    title: String,
    date: String,
    img: Option<String>,
}
