use crate::helpers::spawn_app;


#[tokio::test]
async fn health_check_works() {
    let app = spawn_app().await;

    let client = reqwest::Client::new();

    let respose = client
        .get(&format!("{}/health_check", &app.address))
        .send()
        .await
        .expect("Failed to execute request.");

    assert!(respose.status().is_success());
    assert_eq!(Some(0), respose.content_length());
}