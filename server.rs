use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};

fn handle_client(mut stream: TcpStream) {
    let mut buffer = [0; 512];
    
    // Read the request from the client
    match stream.read(&mut buffer) {
        Ok(_) => {
            // Print the request for debugging (optional)
            println!("Received request: {}", String::from_utf8_lossy(&buffer));

            // Send a simple HTTP response
            let response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body><h1>Hello, World!</h1></body></html>\r\n";
            if let Err(e) = stream.write(response.as_bytes()) {
                eprintln!("Failed to send response: {}", e);
            }
        },
        Err(e) => {
            eprintln!("Failed to read from stream: {}", e);
        }
    }
}

fn main() -> std::io::Result<()> {
    // Bind the server to port 8080
    let listener = TcpListener::bind("127.0.0.1:8080")?;
    println!("Server listening on port 8080...");

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                handle_client(stream);
            },
            Err(e) => {
                eprintln!("Failed to accept connection: {}", e);
            }
        }
    }

    Ok(())
}
