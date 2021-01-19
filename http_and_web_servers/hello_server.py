#!/usr/bin/env python3

# import modules
from http.server import HTTPServer, BaseHTTPRequestHandler

# create the handler class HelloHandler, which relies on BaseHTTPRequestHandler parent class
class HelloHandler(BaseHTTPRequestHandler):
    # define the method do_GET, which will work as a GET request
    def do_GET(self):
        # define the response for the request
        self.send_response(200)
        # define the headers
        self.send_header('Content-type', 'text/plain; charset=utf-8')
        self.end_headers()
        # write a response file to the body
            # wfile.write() is a write only file
            # HTTP accept only encrypted (binary) data, thus, enconde() has to be used
        self.wfile.write("Hello, HTTP!\n".encode())

if __name__ == '__main__':
    # define server port number
    server_address = ('', 8000)
    # HTTPServer arguments
        # server address
        # handler class object
    httpd = HTTPServer(server_address, HelloHandler)
    # server runs forever until the process is killed
    httpd.serve_forever()
