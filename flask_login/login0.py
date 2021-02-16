from flask import Flask, flash, redirect, render_template, request, session, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, current_user, fresh_login_required, login_required, login_user, logout_user
from urllib.parse import urlparse, urljoin
from datetime import timedelta

app = Flask(__name__)

app.config.update(
    SQLALCHEMY_DATABASE_URI='sqlite:////home/rodox/git/courses/flask_login/login0.db',
    SECRET_KEY='SEGREDO',
    USE_SESSION_FOR_NEXT=True,
    REMEMBER_COOKIE_DURATION=timedelta(hours=4)
)

db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message = 'We don\'t recognize you, please login to access the page.'
login_manager.refresh_view = 'login'
login_manager.needs_refresh_message = 'You need to re-login to access this page.'

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(30), unique=True)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

def is_safe_url(target):
    ref_url = urlparse(request.host_url)
    test_url = urlparse(urljoin(request.host_url, target))
    return test_url.scheme in ('http', 'https') and ref_url.netloc == test_url.netloc

@app.route('/login/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        user = User.query.filter_by(username=username).first()
        if not user:
            flash('User not found!')
            return render_template('login.html')
        login_user(user, remember=True)
        if 'next' in session:
            next_url = session['next']
            session['next'] = None
            if is_safe_url(next_url) and next_url is not None:
                return redirect(next_url)
        return 'You\'re logged in!'
    else:
        return render_template('login.html')

@app.route('/logout/')
@login_required
def logout():
    logout_user()
    return redirect('/login/')

@app.route('/home/')
@login_required
def home():
    return 'The current user is %s!' % current_user.username

@app.route('/fresh/')
@fresh_login_required
def fresh():
    return 'You have a fresh login!'

if __name__ == '__main__':
    app.run(host='localhost', port=8000, debug=True)