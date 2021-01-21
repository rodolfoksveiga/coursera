import webapp2

form = '''
<form action="http://www.google.com/search">
    <input name="q">
    <input type="submit">
</form>
'''

class MainPage(webapp2.RequestHandler):
    def get(self):
        self.response.headers['Content-Type'] = 'text/html'
        self.response.out.write(form)

app = webapp2.WSGIApplication([('/', MainPage)], debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()
