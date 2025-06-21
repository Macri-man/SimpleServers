package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	// Send a "Hello, World!" message as the response
	fmt.Fprintf(w, "<html><body><h1>Hello, World!</h1></body></html>")
}

func main() {
	// Register the handler function for the root URL path
	http.HandleFunc("/", handler)

	// Start the server on port 8080
	fmt.Println("Server listening on port 8080...")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("Error starting server:", err)
	}
}
