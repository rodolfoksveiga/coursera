#!/usr/bin/env python3

# import libraries
import os
import http.server
import requests
from urllib.parse import unquote, parse_qs

# create an empty dictionary to allocate the data
memory = {}
# create a form
form = '''
<!DOCTYPE html>
<title>Bookmark Server</title>
<form method="POST">
    <label>Long URI:
        <input name="longuri">
    </label>
    <br>
    <label>Short name:
        <input name="shortname">
    </label>
    <br>
    <button type="submit">Save it!</button>
</form>
<p>URIs I know about:
<pre>
{}
</pre>
'''

# check uri response and add exception error to avoid crashing the server
def CheckURI(uri, timeout=5):
    try:
        check = requests.get(uri, timeout=timeout)
        return check.status_code == 200
    except requests.RequestException:
        return False

class Shortener(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # transform the path into a string and remove the "/"
            # "/" is in the first (0) position of the list
        name = unquote(self.path[1:])
        # if there is a name in the path
        if name:
            # if we know the name, it redirects to the correspondent web page
            if name in memory:
                # returns a response
                self.send_response(303)
                # define the header with the location
                self.send_header('Location', memory[name])
                self.end_headers()
            # if the name is wrong, ie it wasn't allocated in memory before
            else:
                # returns a response
                self.send_response(404)
                # define the header
                self.send_header('Content-type', 'text/plain; charset=utf-8')
                self.end_headers()
                # print the text with the not recognized name
                self.wfile.write('''We don't recognize "{}".'''.format(name).encode())
        # if there isn't a name in the path, we show the form with the stored data
        else:
            # returns a response
            self.send_response(200)
            # define the header
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            # print a list with all the known names
            known = "\n".join("{}: {}".format(key, memory[key])
                              for key in sorted(memory.keys()))
            # fill the "{}" in the form with the known names list
            self.wfile.write(form.format(known).encode())

    def do_POST(self):
        # define length of the html body
        length = int(self.headers.get('Content-length', 0))
        # extract the right amount of text
        body = self.rfile.read(length).decode()
        # parse the body text
        params = parse_qs(body)
        # if any field wasn't filled
        if 'longuri' not in params or 'shortname' not in params:
            # returns a response
            self.send_response(404)
            # define the header
            self.send_header('Content-type', 'text/plain; charset=utf-8')
            self.end_headers()
            # print the text with the not recognized name
            self.wfile.write("Please, fill the fields properly.".encode())
        # if the fields were filled
        else:
            # define long uri
            longuri = params['longuri'][0]
            # define short name
            shortname = params['shortname'][0]
            # if the long uri does exist
            if CheckURI(longuri):
                memory[shortname] = longuri
                # define the response
                self.send_response(303)
                # define the header
                self.send_header('Location', longuri)
                self.end_headers()
            # if the long uri doesn't exist
            else:
                # returns a response
                self.send_response(404)
                # define the header
                self.send_header('Content-type', 'text/plain; charset=utf-8')
                self.end_headers()
                # print the text with the not recognized name
                self.wfile.write('''We couldn't recongized the URI "{}".'''.format(longuri).encode())

if __name__ == '__main__':
    # define port number
    port = int(os.environ.get('PORT', 8000))
    server_address = ('', port)
    # run the server
    httpd = http.server.HTTPServer(server_address, Shortener)
    # host the server until the process is killed
    httpd.serve_forever()
