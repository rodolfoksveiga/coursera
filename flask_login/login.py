# import packages
from datetime import timedelta
from flask import Flask, flash, redirect, request, render_template, session, url_for
from flask_bootstrap import Bootstrap
from flask_login import LoginManager, UserMixin, current_user, login_user, login_required, logout_user
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import FlaskForm
from urllib.parse import urlparse, urljoin
from werkzeug.security import generate_password_hash, check_password_hash
from wtforms import StringField, PasswordField, BooleanField
from wtforms.validators import InputRequired, Email, Length

# app initialization
app = Flask(__name__)
Bootstrap(app)
db = SQLAlchemy(app)

# app configuration
app.config.update(
    SQLALCHEMY_DATABASE_URI='sqlite:////home/rodox/git/courses/flask_login/login.db',
    SECRET_KEY='SEGREDO',
    USE_SESSION_FOR_NEXT=True,
    REMEMBER_COOKIE_DURATION=timedelta(hours=4)
)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message = 'We don\'t recognize you, please login to access the page.'

# database
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(30), unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    email = db.Column(db.String(50), unique=True, nullable=False)

# forms
class LoginForm(FlaskForm):
    username = StringField('Username', validators=[InputRequired(),
                                                   Length(min=5, max=15)])
    password = PasswordField('Password', validators=[InputRequired(),
                                                     Length(min=8, max=80)])
    remember = BooleanField('Remember me')

class SignupForm(FlaskForm):
    username = StringField('Username', validators=[InputRequired(),
                                                   Length(min=5, max=15)])
    password = PasswordField('Password', validators=[InputRequired(),
                                                     Length(min=8, max=80)])
    email = StringField('Email', validators=[InputRequired(),
                                             Email(message='Invalid email.'),
                                             Length(min=3, max=50)])

# base function
def is_safe_url(target):
    ref_url = urlparse(request.host_url)
    test_url = urlparse(urljoin(request.host_url, target))
    return test_url.scheme in ('http', 'https') and ref_url.netloc == test_url.netloc

# login loader
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login/', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    else:
        form = LoginForm()
        if form.validate_on_submit():
            user = User.query.filter_by(username=form.username.data).first()
            if user:
                if check_password_hash(user.password, form.password.data):
                    login_user(user, remember=form.remember.data)
                    if 'next' in session:
                        next_url = session['next']
                        session['next'] = None
                        if is_safe_url(next_url) and next_url is not None:
                            return redirect(next_url)
                    return redirect(url_for('home'))
            flash('Invalid user or password.')
        return render_template('login.html', form=form)

@app.route('/logout/')
@login_required
def logout():
    logout_user()
    return redirect('/login/')

@app.route('/signup/', methods=['GET', 'POST'])
def signup():
    form = SignupForm()
    if form.validate_on_submit():
        # generate a password hash 80 characters long
        password_hash = generate_password_hash(form.password.data, method='sha256')
        user = User(username=form.username.data,
                    email=form.email.data,
                    password=password_hash)
        db.session.add(user)
        db.session.commit()
        flash('User "%s" has been created.' % form.username.data)
        return redirect(url_for('login'))
    return render_template('signup.html', form=form)

@app.route('/profile/')
@login_required
def profile():
    return 'You\'re logged in and this is PROFILE.'
    #return render_template('profile.html')

@app.route('/home/')
@login_required
def home():
    return 'You\'re logged in and this is HOME.'
    #return render_template('profile.html')

if __name__ == '__main__':
    app.run(host='localhost', port=8000, debug=True)