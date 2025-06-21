use strict;
use warnings;
use IO::Socket::INET;

# Create a new TCP socket to listen on port 8080
my $server = IO::Socket::INET->new(
    LocalHost => '127.0.0.1', 
    LocalPort => '8080', 
    Proto     => 'tcp',
    Listen    => 5,
    Reuse     => 1
) or die "Cannot create socket: $!\n";

print "Server listening on port 8080...\n";

while (my $client = $server->accept()) {
    # Read the incoming request
    my $request = '';
    $client->recv($request, 1024);

    # Print the request (for debugging)
    print "Received request:\n$request\n";

    # Send a simple HTTP response
    my $response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
    $response .= "<html><body><h1>Hello, World!</h1></body></html>\r\n";
    
    $client->send($response);
    
    # Close the client connection
    $client->close();
}

# Close the server socket (not reached unless the program is interrupted)
$server->close();
