import jinja2
import os
import webapp2
import re

TEMPLATES_DIR = os.path.join(os.path.dirname(__file__), 'templates')
JINJA_ENV = jinja2.Environment(loader=jinja2.FileSystemLoader(TEMPLATES_DIR),
                               autoescape=True)
USERNAME_REGEX = re.compile(r'^[a-zA-Z0-9_-]{3,20}$')
PASSWORD_REGEX = re.compile(r'^.{3,20}$')
EMAIL_REGEX = re.compile(r'^[\S]+@[\S]+.[\S]+$')

def valid_username(username):
    return USERNAME_REGEX.match(username)

def valid_password(password):
    return PASSWORD_REGEX.match(password)

def valid_email(email):
    return EMAIL_REGEX.match(email)

class Handler(webapp2.RequestHandler):
    def write(self, *a, **kw):
        self.response.out.write(*a, **kw)
    
    def render_str(self, template, **params):
        text = JINJA_ENV.get_template(template)
        return text.render(params)
    
    def render(self, template, **kw):
        self.write(self.render_str(template, **kw))

class Signup(Handler):
    def get(self):
        self.render('signup.html')
    
    def post(self):
        no_error = True
        username = self.request.get('username')
        password = self.request.get('password')
        verify = self.request.get('verify')
        email = self.request.get('email')
        params = dict(username=username, email=email)

        if not valid_username(username):
            params['username_error'] = " That's not a valid username."
            no_error = False
        if not valid_password(password):
            params['password_error'] = " That's not a valid password."
            no_error = False
        if password != verify:
            params['verify_error'] = " Passwords didn't match."
            no_error = False
        if not valid_email(email):
            params['email_error'] = " That's not a valid email."
            no_error = False
        
        if no_error:
            self.redirect('/welcome?username=' + username)
        else:
            self.render('signup.html', **params)

class Welcome(Handler):
    def get(self):
        username = self.request.get('username')
        if valid_username(username):
            self.render('welcome.html', username=username)
        else:
            self.render('signup.html', username=username)

app = webapp2.WSGIApplication([('/', Signup),
                               ('/welcome', Welcome)],
                              debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()