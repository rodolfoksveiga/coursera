import jinja2
import os
import webapp2

templates_dir = os.path.join(os.path.dirname(__file__), 'templates')
jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_dir),
                               autoescape=True)

class Handler(webapp2.RequestHandler):
    def write(self, *a, **kw):
        self.response.out.write(*a, **kw)
    
    def render_str(self, template, **params):
        text = jinja_env.get_template(template)
        return text.render(params)
    
    def render(self, template, **kw):
        self.write(self.render_str(template, **kw))

class MainPage(Handler):
    def get(self):
        items = self.request.get_all('food')
        self.render('shopping_list.html', items=items)

app = webapp2.WSGIApplication([('/', MainPage)], debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()
