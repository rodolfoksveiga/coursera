#!/usr/bin/env python3

# load modules
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import parse_qs

# create variable to concatenate messages
memory = []
# define html content
form = '''
<!DOCTYPE html>
    <title>Message Board</title>
    <form method="POST" action="http://localhost:8000/">
        <textarea name="message"></textarea>
        <br>
        <button type="submit">Post it!</button>
    </form>
    <pre>
{}
    </pre>
'''

class MessageHandler(BaseHTTPRequestHandler):
    # define a method for a GET request
    def do_GET(self):
        # define the response
        self.send_response(200)
        # define the header
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        # write the form with the messages
        formMessages = form.format('\n'.join(memory))
        self.wfile.write(formMessages.encode())
    # define a method for a POST request
    def do_POST(self):
        # define length of the body (message)
        length = int(self.headers.get('Content-Length', 0))
        # extract the right amount of text
        data = self.rfile.read(length).decode()
        # parse the text and extract the first item of the key message
        message = parse_qs(data).pop('message')[0]
        # concatenate messages in the memory list
        memory.append(message)
        # define the response
        self.send_response(303)
        # define the header
        self.send_header('Location', '/')
        self.end_headers()

if __name__ == '__main__':
    # define port number
    server_address = ('', 8000)
    # run the server
    httpd = HTTPServer(server_address, MessageHandler)
    # host the server until the process is killed
    httpd.serve_forever()
