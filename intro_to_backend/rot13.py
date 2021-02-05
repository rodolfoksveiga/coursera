import jinja2
import os
import webapp2

templates_dir = os.path.join(os.path.dirname(__file__), 'templates')
jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_dir),
                               autoescape=True)

def rot13(text):
    alpha = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
             'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
             's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    text = list(text)
    for i, char in enumerate(text):
        if char.isalpha():
            index = alpha.index(char.lower())
            new_index = (index + 13) % len(alpha)
            if char.islower():
                text[i] = alpha[new_index]
            else:
                text[i] = alpha[new_index].upper()
    text = ''.join(text)
    return text

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
        self.render('rot13.html')

    def post(self):
        text = self.request.get('text')
        if text:
            text = rot13(text)
        self.render('rot13.html', text=text)

app = webapp2.WSGIApplication([('/', MainPage)], debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()