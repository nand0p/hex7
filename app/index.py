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
    html.extend(_rezo())
    html.extend(_body())
    html.extend(_foot())
    return ''.join([ str(x) for x in html ])

def _head():
    _html = []
    _textcolor = "black"
    _html.extend([ "<html><head><title>Hex 7 Internet Solutions</title>",
                   "<meta http-equiv=refresh content=20>",
                   "<link rel=\"shortcut icon\" href=https://s3-us-west-1.amazonaws.com/hex7/favicon.ico>",
                   "<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){",
                   "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),",
                   "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)",
                   "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');",
                   "ga('create', 'UA-32710227-1', 'auto'); ga('send', 'pageview');</script>",
                   "<script data-ad-client='ca-pub-9792012528290289' async",
                   "src='https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js'></script>",
                   "<style>a { text-decoration: none; color: ", _textcolor, "; }</style>",
                   "</head><body link=", color, " vlink=", color, " alink=", color, ">",
                   "<font name=garamond><p>" ])
    return _html

def _rezo():
    _html = []

    if request.headers.getlist("X-Forwarded-For"):
        _ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        _ip = request.remote_addr
    _html.extend([ '<center><h1 name=ip>', _ip, '</h1><br>' ])
    if _ip != '127.0.0.1' and _ip != '172.17.0.1':
        if not IPAddress(_ip).is_private():
            _ip_info = IPWhois(_ip).lookup_rdap(depth=1)
            _entity = _ip_info.get('entities')[0]
            _html.extend([ _ip_info.get('network').get('name'), "<br>",
                           _ip_info.get('network').get('cidr'), "<br>",
                           _ip_info.get('network').get('handle'), "<br>",
                           _ip_info.get('network').get('links')[0], "<br>" ])
            _html.append(_ip_info.get('objects').get(_entity).get('contact').get('address')[0].get('value'))
    _html.extend(['<p>SEDME<p>'])
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
                   "<b><font size=5>&copy;2000-2020</font></b><br>",
                   "<a target=_blank href=http://hex7.com>",
                   "<b><font color=", _textcolor, " size=+2>Hex 7 Internet Solutions</font></b></a>",
                   "</td> </tr></table></center>", request.headers.get('User-Agent'), " :: ",
                   "<a href=http://en.wikipedia.org/wiki/SOS>s0s</a> at hex7 d0t c0m",
                   "</body></html>" ])
    return _html

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
