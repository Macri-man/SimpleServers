import Network.Socket
import System.IO

main :: IO ()
main = withSocketsDo $ do
    -- Create a socket
    sock <- socket AF_INET Stream 0

    -- Bind the socket to a port
    let port = 8080
    bind sock (SockAddrInet (fromIntegral port) iNADDR_ANY)

    -- Listen for incoming connections
    listen sock 1
    putStrLn $ "Server running on port " ++ show port

    -- Accept client connections
    (conn, _) <- accept sock
    handle <- socketToHandle conn ReadWriteMode
    hSetBuffering handle NoBuffering

    -- Read the request (basic request handling)
    request <- hGetLine handle
    putStrLn $ "Received request: " ++ request

    -- Send the HTTP response
    let response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body><h1>Hello, World!</h1></body></html>\r\n"
    hPutStrLn handle response

    -- Close the connection
    hClose handle
    close sock
