require 'socket'

server = TCPServer.new('127.0.0.1', 8080)
puts "Server is listening on port 8080..."

loop do
  # Wait for a client to connect
  client = server.accept

  # Read the client's request (optional)
  request = client.gets
  puts "Received request: #{request}"

  # Send HTTP response
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts "Connection: close"
  client.puts
  client.puts "<html><body><h1>Hello, World!</h1></body></html>"

  # Close the connection
  client.close
end
