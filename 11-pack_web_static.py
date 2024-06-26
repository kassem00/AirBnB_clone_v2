#!/usr/bin/python3
from fabric import Connection

"""
Fabric script that generates a .tgz archive
from the contents of the web_static folder of your AirBnB Clone repo,
using the function do_pack
"""


def do_pack():
    """  generates a tgz archive pack AirBnb for packing """
    try:
        date = time.strftime("%Y%m%d%H%M%S")
        if not isdir("versions"):
            local("mkdir versions")
        file_name = f"versions/web_static_{date}.tgz"
        local(f"tar -cvzf {file_name} web_static")
        return file_name
    except Exception as e:
        return None

