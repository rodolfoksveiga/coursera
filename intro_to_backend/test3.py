import webapp2

form = '''
<form method="post" action="/testform">
    <input name="q">
    <input type="submit">
</form>
'''

class MainPage(webapp2.RequestHandler):
    def get(self):
        self.response.out.write(form)
class TestHandler(webapp2.RequestHandler):
    def post(self):
        q = self.request.get('q')
        self.response.out.write(q)

app = webapp2.WSGIApplication([('/', MainPage),
                               ('/testform', TestHandler)],
                              debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()
