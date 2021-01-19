#!/usr/bin/env python3

# import modules
from http.server import HTTPServer, BaseHTTPRequestHandler

# define subclass HelloHandler
class HelloHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # send 200 response
        self.send_response(200)
        # define header
        self.send_header('Content-type', 'text/plain; charset=utf-8')
        self.end_headers()
        # read and echo the server path
        self.wfile.write(self.path[1:].encode())

if __name__ == '__main__':
    # define server port number
    server_address = ('', 8000)
    # call HTTPServer function
    httpd = HTTPServer(server_address, HelloHandler)
    # leave server on until it is killed
    httpd.serve_forever()
