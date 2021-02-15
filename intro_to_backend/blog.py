import binascii
import hashlib
import hmac
import jinja2
import random
import re
import os
import psycopg2
import webapp2
from string import ascii_letters

TEMPLATES_DIR = os.path.join(os.path.dirname(__file__), 'templates')
JINJA_ENV = jinja2.Environment(loader=jinja2.FileSystemLoader(TEMPLATES_DIR),
                               autoescape=True)
USERNAME_REGEX = re.compile(r'^[a-zA-Z0-9_-]{3,20}$')
PASSWORD_REGEX = re.compile(r'^.{3,20}$')
EMAIL_REGEX = re.compile(r'^[\S]+@[\S]+.[\S]+$')
SECRET_KEY = 'E49756B4C8FAB4E48222A3E7F3B97CC3'

# database manipulation function
def manip_psql_table(action, title='', art=''):
    try:
        conn = psycopg2.connect(database='ascii',
                                user='postgres',
                                password='postgres',
                                host='localhost')
        cursor = conn.cursor()

        print('PostgreSQL connection is open.')

        cursor.execute('SELECT version()')
        print('You are connected to:', cursor.fetchone())

        create_table_query = '''
        create table if not exists blog (id serial primary key,
                                         user varchar not null,
                                         password varchar not null);
        '''
        cursor.execute(create_table_query)   
        conn.commit()

        if action == 'insert':
            insert_query = 'insert into arts (user, password) values (%s, %s)'
            cursor.execute(insert_query, (title, art))
            conn.commit()
            print('A new row was inserted!')

        elif action == 'retrieve':
            fetch_query = 'select * from blog'
            cursor.execute(fetch_query)
            return cursor.fetchall()

    except (Exception, psycopg2.Error) as error:
        print('The following error was thrown while connecting to PostgreSQL:\n', error)

    finally:
        if conn:
            cursor.close()
            conn.close()
            print('PostgreSQL connection is closed.')

# auxiliar functions
def validate_username(username):
    return USERNAME_REGEX.match(username)

def validate_password(password):
    return PASSWORD_REGEX.match(password)

def validate_email(email):
    return EMAIL_REGEX.match(email)

def make_salt():
    salt = ''
    for _ in range(5):
        salt += random.choice(ascii_letters)
    return salt

def make_secure_value(value):
    byte_key = binascii.unhexlify(SECRET_KEY)
    encoded_value = value.encode()
    secure_value = hmac.new(byte_key, encoded_value, hashlib.sha256).hexdigest()
    return '%s|%s' % (value, secure_value)

def check_secure_value(secure_value):
    value = secure_value.split('|')[0]
    if secure_value == make_secure_value(value):
        return value

# define a request handler class
class Handler(webapp2.RequestHandler):
    def write(self, *a, **kw):
        self.response.out.write(*a, **kw)
    
    def render_str(self, template, **params):
        text = JINJA_ENV.get_template(template)
        return text.render(params)
    
    def render(self, template, **kw):
        self.write(self.render_str(template, **kw))
    
    def set_cookie(self, key, value):
        cookie_value = make_secure_value(value)
        self.response.headers.add_header(
            'Set-Cookie',
            '%s=%s; Path=/' % (key, cookie_value)
        )
    
    def read_cookie(self, key):
        cookie_value = self.request.cookies.get(key)
        return cookie_value and check_secure_value(cookie_value)

    def login(self, user):
        self.set_cookie('user_id', str(user.key().id()))

    def logout(self):
        self.response.headers.add_header(
            'Set-Cookie',
            'user_id=; Path=/'
        )

    def initialize(self, *a, **kw):
        webapp2.RequestHandler.initialize(self, *a, **kw)
        user_id = self.read_cookie('user_id')
        self.user = user_id

# signup handler (root = /signup)
class Signup(Handler):
    def get(self):
        self.render('signup.html')
    
    def post(self):
        error = False
        self.username = self.request.get('username')
        self.password = self.request.get('password')
        self.verify = self.request.get('verify')
        self.email = self.request.get('email')
        params = dict(username=self.username, email=self.email)
        password_hash = self.request.cookies.get(self.username)
        print(password_hash)

        if not validate_username(self.username):
            params['username_error'] = " That's not a valid username."
            error = True
        if not validate_password(self.password):
            params['password_error'] = " That's not a valid password."
            error = True
        if self.password != self.verify:
            params['verify_error'] = " Passwords didn't match."
            error = True
        if not validate_email(self.email):
            params['email_error'] = " That's not a valid email."
            error = True
        
        if error:
            self.render('signup.html', **params)
        elif password_hash:
            print(check_secure_value(password_hash))
            if check_secure_value(password_hash):
                print(self.username)
                self.redirect('/welcome')
            else:
                self.render('signup.html')
        else:
            self.set_cookie(self.username, self.password)
            self.redirect('/welcome?username=' + self.username)
            

# welcome handler (root = /welcome)
class Welcome(Handler):
    def get(self):
        if self.user:
            self.render('welcome.html', username=self.user.username)
        else:
            self.render('signup.html', username=self.user.username)

app = webapp2.WSGIApplication([('/', Signup),
                               ('/welcome', Welcome)],
                              debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()