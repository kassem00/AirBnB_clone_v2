#!/usr/bin/python3
from fabric.api import local
import time
from os.path import isdir

"""
Fabric script that generates a .
tgz archive from the contents of the web_static folder
of your AirBnB Clone repo, using the function do_pack.
This script is intended for deployment purposes,
packaging web assets for distribution.
"""


def do_pack():
    """
    Generate a .tgz archive from the contents
    of the web_static directory.

    This function will create a directory named 'versions'
    if it does not exist,
    then pack the contents of the 'web_static' folder
    into a timestamped archive
    within the 'versions' directory.
    The name of the archive will be of the form
    'web_static_<timestamp>.tgz'.

    Returns:
        str: The path to the created archive if successful
    """
    try:
        date = time.strftime("%Y%m%d%H%M%S")
        if not isdir("versions"):
            local("mkdir versions")
        file_name = f"versions/web_static_{date}.tgz"
        local(f"tar -cvzf {file_name} web_static")
        return file_name
    except Exception as e:
        return None
