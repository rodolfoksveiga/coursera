import jinja2
import os
import webapp2
import psycopg2

templates_dir = os.path.join(os.path.dirname(__file__), 'templates')
jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_dir),
                               autoescape=True)

def manip_psql_table(action, title='', art=''):
    try:
        conn = psycopg2.connect(database='ascii',
                                user='postgres',
                                password='postgres',
                                host='localhost')
        cursor = conn.cursor()

        print('PostgreSQL connection is open.')

        cursor.execute('SELECT version();')
        print('You are connected to:', cursor.fetchone())

        create_table_query = '''
        create table if not exists arts (id serial primary key,
                                         title varchar not null,
                                         art text not null,
                                         created_at timestamp not null);
        '''
        cursor.execute(create_table_query)   
        conn.commit()

        if action == 'insert':
            insert_query = '''
            insert into arts (title, art, created_at)
                values (%s, %s, current_timestamp)
            '''
            cursor.execute(insert_query, (title, art))
            conn.commit()
            print('A new row was inserted!')

        elif action == 'retrieve':
            fetch_query = 'select * from arts order by created_at desc'
            cursor.execute(fetch_query)
            return cursor.fetchall()

    except (Exception, psycopg2.Error) as error:
        print('The following error was thrown while connecting to PostgreSQL:\n', error)

    finally:
        if conn:
            cursor.close()
            conn.close()
            print('PostgreSQL connection is closed.')

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
        data = manip_psql_table('retrieve')
        titles = []
        arts = []
        dts = []
        for row in data:
            titles.append(row[1])
            arts.append(row[2])
            dts.append(row[3])
        length = len(titles)
        self.render('ascii.html', length=length, titles=titles, arts=arts, dts=dts)

    def post(self):
        title = self.request.get('title')
        art = self.request.get('art')

        if title and art:
            manip_psql_table('insert', title=title, art=art)
            self.render('ascii.html', title=title, art=art)
            self.redirect('/')
        else:
            error = "You don't have a title or some artwork!"
            self.render('ascii.html', error=error)        

app = webapp2.WSGIApplication([('/', MainPage)], debug=True)

def main():
    from paste import httpserver
    httpserver.serve(app, host='localhost', port=8000)

if __name__ == '__main__':
    main()