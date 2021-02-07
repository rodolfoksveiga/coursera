import jinja2
import os
import webapp2
import psycopg2

templates_dir = os.path.join(os.path.dirname(__file__), 'templates')
jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_dir),
                               autoescape=True)

def create_psql_table():
    try:
        conn = psycopg2.connect(database='ascii',
                                user='postgres',
                                password='postgres',
                                host='localhost')
        cursor = conn.cursor()

        print('PostgreSQL server information:', conn.get_dsn_parameters())
        
        cursor.execute('SELECT version();')
        print('You are connected to:', cursor.fetchone())

        create_table_query = '''
        create table if not exists arts (id int primary key not null,
                                         title varchar not null,
                                         art text not null,
                                         created_at timestamp not null);
        '''
        cursor.execute(create_table_query)   
        conn.commit()
        print('Table was successfully created.')

    except (Exception, psycopg2.Error) as error:
        print('The following error was thrown while connecting to PostgreSQL:\n', error)

    finally:
        if conn:
            cursor.close()
            conn.close()
            print("PostgreSQL connection is closed.")

def insert_data(id, title, art, created_at):
    try:
        conn = psycopg2.connect(database='ascii',
                                user='postgres',
                                password='postgres',
                                host='localhost')
        cursor = conn.cursor()

        insert_query = '''
        insert into Arts (id, title, art, created_at)
            values ({i}, {t}, {a}, {c})
        '''.format(i=id, t=title, a=art, c=created_at)
        cursor.execute(insert_query)
        conn.commit()

        fetch_query = 'select * from Arts'
        cursor.execute(fetch_query)
        print('Data in the table:', cursor.fetchone())

    except (Exception, psycopg2.Error) as error:
        print('The following error was thrown while connecting to PostgreSQL:\n', error)

    finally:
        if conn:
            cursor.close()
            conn.close()
            print("PostgreSQL connection is closed.")

def retrieve_data(id):
    try:
        conn = psycopg2.connect(database='ascii',
                                user='postgres',
                                password='postgres',
                                host='localhost')
        cursor = conn.cursor()

        fetch_query = 'select * from Arts where id = {i}'.format(i=id)
        cursor.execute(fetch_query)
        print('The data retrieved for ID {i} is:'.format(i=id),
              cursor.fetchone())

    except (Exception, psycopg2.Error) as error:
        print('The following error was thrown while connecting to PostgreSQL:\n', error)

    finally:
        if conn:
            cursor.close()
            conn.close()
            print("PostgreSQL connection is closed.")

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
        self.render('ascii.html')
    
    def post(self):
        params = {
            'title': self.request.get('title'),
            'art': self.request.get('art')
        }

        if params['title'] and params['art']:
            self.render('ascii.html')
        else:
            params['error'] = "You don't have a title or some artwork!"
            self.render('ascii.html', **params)
        

app = webapp2.WSGIApplication([('/', MainPage)], debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()