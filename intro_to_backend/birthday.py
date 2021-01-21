from html import escape
from paste import httpserver
import webapp2

form = '''
<form method='post'>
    What is your birthday?
    <br>
    <label>
        Day
        <input type='text' name='day' value='%(day)s'>
    </label>
    <br>
    <label>
        Month
        <input type='text' name='month' value='%(month)s'>
    </label>
    <br>
    <label>
        Year
        <input type='text' name='year' value='%(year)s'>
    </label>
    <br>
    <br>
    <b style='color: red'>
        %(error)s
    </b>
    <input type='submit'>    
</form>
'''

months = ['January', 'February', 'March',
          'April', 'May', 'June',
          'July', 'Agost', 'September',
          'October', 'November', 'December']

def validate_day(day):
    if day.isdigit():
        if int(day) in range(1, 32):
            return day

def validate_month(month):
    month = month.capitalize()
    if month in months:
        return month

def validate_year(year):
    if year.isdigit():
        if int(year) in range(1900, 2021):
            return year

class MainPage(webapp2.RequestHandler):
    def write_form(self, error='', day='', month='', year=''):
        fields = {'error': error, 'day': escape(day),
        'month': escape(month), 'year': escape(year)}
        self.response.out.write(form % fields)
    def get(self):
        self.write_form()
    def post(self):
        user_day = self.request.get('day')
        valid_day = validate_day(user_day)
        user_month = self.request.get('month')
        valid_month = validate_month(user_month)
        user_year = self.request.get('year')
        valid_year = validate_year(user_year)
        if not (valid_day and valid_month and valid_year):
            self.write_form("It's not a valid date!<br><br>",
                            day=user_day, month=user_month, year=user_year)
        else:
            self.redirect('/thanks')
            
class ThanksHandler(webapp2.RequestHandler):
    def get(self):
        self.response.out.write("<b>Thanks, That's a totally valid date!</b>")

if __name__ == '__main__':
    app = webapp2.WSGIApplication([('/', MainPage),
                                   ('/thanks', ThanksHandler)],
                                  debug=True)
    httpserver.serve(app, host='localhost', port=8000)
