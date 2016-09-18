from flask import Flask, request
from ipwhois import IPWhois
from netaddr import IPAddress
from random import randint

app = Flask(__name__)
color = "#FF0000"
rows = 55
columns = 200
width = 65
height = 175
density = 80

@app.route("/")
def home():
    html = []
    html.extend(_head())
    html.extend(_ip())
    html.extend(_body())
    html.extend(_foot())
    return ''.join([ str(x) for x in html ])

def _head():
    _html = []
    _textcolor = "black"
    _html.extend([ "<html><head><title>Hex 7 Internet Solutions</title>",
                   "<meta http-equiv=refresh content=20>",
                   "<link rel=icon href=http://www.hex7.com/favicon.ico>",
                   "<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){",
                   "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),",
                   "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)",
                   "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');",
                   "ga('create', 'UA-32710227-1', 'auto'); ga('send', 'pageview');</script>",
                   "<style>a { text-decoration: none; color: ", _textcolor, "; }</style>",
                   "</head><body link=", color, " vlink=", color, " alink=", color, ">",
                   "<font name=garamond><p>" ])
    return _html

def _ip():
    _html = []
    if request.headers.getlist("X-Forwarded-For"):
        ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        ip = request.remote_addr
    _html.extend([ "<center><h1 name=ip>", ip, "</h1><p><br>" ])
    if ip != "127.0.0.1":
        if not IPAddress(ip).is_private():
            _html.extend([ "<pre>", str(IPWhois(ip).lookup_rdap(depth=1)), "</pre>" ])
    return _html

def _body():
    _html = []
    _html.append("<table>")
    _column_counter = 0
    while _column_counter < columns:
        _column_counter = _column_counter + 1
        _html.append("<tr>")
        _row_counter = 0
        while _row_counter < rows:
            _row_counter = _row_counter + 1
            if randint(0,density) == 0:
                _html.extend([ "<td height=", height, " width=", width,
                               " bgcolor=", color, "><center>&nbsp;" ])
            else:
                _html.extend([ "<td width=", width, ">" ])
            _html.append("</td><td>")
        _html.append("</td></tr>")
    _html.append("</table>")
    return _html

def _foot():
    _html = []
    _textcolor = "red"
    _html.extend([ "<center><br><p><br><p><br><p>",
                   "<table border=0 width=100%><tr>",
                   "<td width=40% align=center>",
                   "<b><font size=5>&copy;2000-2016</font></b><br>",
                   "<a target=_blank href=http://hex7.com>",
                   "<b><font color=", _textcolor, " size=+2>Hex 7 Internet Solutions</font></b></a>",
                   "</td> </tr></table></center>", request.headers.get('User-Agent'), " :: ",
                   "<a href=http://en.wikipedia.org/wiki/SOS>s0s</a> at hex7 d0t c0m",
                   "</body></html>" ])
    return _html
