import java.io.*;
import java.net.*;

public class SimpleServer {

    public static void main(String[] args) {
        try {
            // Create a ServerSocket to listen on port 8080
            ServerSocket serverSocket = new ServerSocket(8080);
            System.out.println("Server is listening on port 8080...");

            while (true) {
                // Accept incoming client connections
                Socket clientSocket = serverSocket.accept();

                // Create input and output streams for the client connection
                InputStream input = clientSocket.getInputStream();
                OutputStream output = clientSocket.getOutputStream();

                // Read the request (not used in this simple server)
                BufferedReader reader = new BufferedReader(new InputStreamReader(input));
                String requestLine = reader.readLine();
                System.out.println("Received request: " + requestLine);

                // Send a simple HTTP response
                String httpResponse = "HTTP/1.1 200 OK\r\n"
                                    + "Content-Type: text/html\r\n"
                                    + "Connection: close\r\n\r\n"
                                    + "<html><body><h1>Hello, World!</h1></body></html>";
                output.write(httpResponse.getBytes());

                // Close the client socket
                clientSocket.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
