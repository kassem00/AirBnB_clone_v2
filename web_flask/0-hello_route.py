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


if __name__ == "__main__":
    app.run(strict_slashes=False, host='0.0.0.0', port='5000')
