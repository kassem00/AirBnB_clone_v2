#!/usr/bin/python3
"""
application must be listening on 0.0.0.0, port 5000
"""
from flask import Flask, render_template


app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/')
def home_page(name=None):
    """fun fact it's home page """
    return "Hello HBNB!"


@app.route('/hbnb')
def hbnb_page(name=None):
    """fun fact it's hbnb page """
    return "HBNB"


@app.route('/c/<text>')
def C(text):
    """the mother of all"""
    return 'C {}'.format(text.replace('_', ' '))


@app.route('/python/')
@app.route('/python/<text>')
def python(text: str = "is cool"):
    """what can't python do ? run fast silly"""
    return 'Python {}'.format(text.replace('_', ' '))


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
