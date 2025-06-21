#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define BACKLOG 10
#define BUFFER_SIZE 1024

void handle_client(int client_socket) {
    char buffer[BUFFER_SIZE];
    
    // Read the request
    read(client_socket, buffer, sizeof(buffer) - 1);
    
    // Print the request to the console
    std::cout << "Request:\n" << buffer << std::endl;
    
    // Send the HTTP response
    const std::string http_response = 
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/html; charset=UTF-8\r\n"
        "\r\n"
        "<html><body><h1>Hello, World!</h1></body></html>\r\n";
    
    write(client_socket, http_response.c_str(), http_response.length());
    
    // Close the client socket
    close(client_socket);
}

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    
    // Create server socket
    if ((server_socket = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set up the server address struct
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);
    
    // Bind the socket to the address
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind failed");
        close(server_socket);
        exit(EXIT_FAILURE);
    }
    
    // Start listening for incoming connections
    if (listen(server_socket, BACKLOG) == -1) {
        perror("listen failed");
        close(server_socket);
        exit(EXIT_FAILURE);
    }
    
    std::cout << "Server listening on port " << PORT << "..." << std::endl;
    
    // Accept incoming connections
    while (true) {
        client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_addr_len);
        if (client_socket == -1) {
            perror("accept failed");
            continue;
        }
        
        // Handle the client request
        handle_client(client_socket);
    }
    
    // Close the server socket
    close(server_socket);
    
    return 0;
}
