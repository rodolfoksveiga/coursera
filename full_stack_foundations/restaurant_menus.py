from flask import Flask, request, render_template, redirect, url_for, flash, jsonify, session
app = Flask(__name__)

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database_setup import Base, Restaurant, MenuItem

SECRET = 'SECRET_KEY'

engine = create_engine('sqlite:///restaurant_menu.db')
Base.metadata.bind = engine
DBSession = sessionmaker(bind=engine)
session = DBSession()

@app.route('/restaurants/<int:restaurant_id>/',
           methods=['GET'])
def restaurantMenu(restaurant_id):
    restaurant = session.query(Restaurant).filter_by(id=restaurant_id).one()
    items = session.query(MenuItem).filter_by(restaurant_id=restaurant_id)
    return render_template('menu.html', restaurant=restaurant, items=items)

@app.route('/restaurants/<int:restaurant_id>/JSON/',
           methods=['GET'])
def restaurantMenuJSON(restaurant_id):
    restaurant = session.query(Restaurant).filter_by(id=restaurant_id).one()
    items = session.query(MenuItem).filter_by(restaurant_id=restaurant_id).all()
    return jsonify(MenuItems=[item.serialize for item in items])

@app.route('/restaurants/<int:restaurant_id>/new/',
           methods=['GET', 'POST'])
def newMenuItem(restaurant_id):
    if request.method == 'POST':
        item = MenuItem(name=request.form['name'], restaurant_id=restaurant_id)
        session.add(item)
        session.commit()
        flash('Item %s was created.' % item.name)
        return redirect(url_for('restaurantMenu', restaurant_id=restaurant_id))
    else:
        return render_template('new_item.html', restaurant_id=restaurant_id)
    return render_template('')

@app.route('/restaurants/<int:restaurant_id>/<int:menu_id>/edit/',
           methods=['GET', 'POST'])
def editMenuItem(restaurant_id, menu_id):
    item = session.query(MenuItem).filter_by(id=menu_id).one()
    if request.method == 'POST':
        if request.form['name']:
            old_name = item.name
            item.name = request.form['name']
            session.add(item)
            session.commit()
            flash('Item %s was changed to %s.' % (old_name, item.name))
        else:
            flash('No name was inserted, so the item name remains %s.' % item.name)
        return redirect(url_for('restaurantMenu', restaurant_id=restaurant_id))
    else:
        return render_template('edit_item.html', restaurant_id=restaurant_id,
                               menu_id=menu_id, name=item.name)

@app.route('/restaurants/<int:restaurant_id>/<int:menu_id>/delete/',
           methods=['GET', 'POST'])
def deleteMenuItem(restaurant_id, menu_id):
    item = session.query(MenuItem).filter_by(id=menu_id).one()
    if request.method == 'POST':
        session.delete(item)
        session.commit()
        flash('Restaurant %s was deleted.' % item.name)
        return redirect(url_for('restaurantMenu', restaurant_id=restaurant_id))
    else:
        return render_template('delete_item.html', restaurant_id=restaurant_id,
                               menu_id=menu_id, name=item.name)

if __name__ == '__main__':
    app.secret_key = SECRET
    app.debug = True
    app.run(host='localhost', port=8000)