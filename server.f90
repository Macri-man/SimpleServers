program simple_server
    implicit none

    integer :: sockfd, newsockfd, portnum, clilen
    integer :: status
    character(len=1024) :: request
    character(len=255) :: response
    type(sockaddr_in) :: server_addr, client_addr
    integer :: i

    ! Create a socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0)
    if (sockfd < 0) then
        print *, "ERROR opening socket"
        stop
    end if

    ! Set up the server address structure
    server_addr = sockaddr_in_create(port=8080, addr='INADDR_ANY')

    ! Bind the socket to the port
    status = bind(sockfd, server_addr)
    if (status < 0) then
        print *, "ERROR binding"
        stop
    end if

    ! Listen for incoming connections
    status = listen(sockfd, 5)
    if (status < 0) then
        print *, "ERROR listening"
        stop
    end if

    ! Accept incoming connections and handle them
    print *, "Server listening on port 8080..."

    do
        clilen = sizeof(client_addr)
        newsockfd = accept(sockfd, client_addr, clilen)
        if (newsockfd < 0) then
            print *, "ERROR on accept"
            stop
        end if

        ! Read the request (basic, for demonstration purposes)
        read(newsockfd, '(A)', i=1) request

        ! Print the received request to console (just for debugging)
        print *, "Received request:"
        print *, trim(adjustl(request))

        ! Send the HTTP response
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body><h1>Hello, World!</h1></body></html>\r\n"
        write(newsockfd, '(A)', advance="no") response

        ! Close the connection
        close(newsockfd)
    end do

    close(sockfd)
end program simple_server
