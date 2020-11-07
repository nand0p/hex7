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
    html.extend(_google())
    html.extend(_rezo())
    #html.extend(_head())
    #html.extend(_sales())
    html.extend(_art())
    html.extend(_foot())
    return ''.join([ str(x) for x in html ])


@app.route("/ip")
def ip():
    html = []
    html.extend(_rezo())
    html.extend(_foot())
    return ''.join([ str(x) for x in html ])


def _head():
    _html = []
    _html.extend([ '<table width=100%><tr><td width=100>.</td>',
                   '<td><h1>Hex7 Internet Solutions</h1> <br>' ])
    return _html
 

def _sales():
    _html = []
    _html.extend([ '<font size=+1>We Provide the Following Services:<br><ul>',
                   '<li>Linux Cloud Migrations with or without Containers</li>',
                   '<li>Cloud Pipelines with CodePipeline, Gitlab, Jenkins, or BuildBot</li>',
                   '<li>Infrastructure as Code with Terraform or Cloudformation</li>',
                   '<li>Image Automation with Packer and Ansible</li>',
                   '<li>HashiCorp Clusters with Consul, Nomad, and Vault</li>',
                   '<li>DevSecOps: Integrate Security in Application and Infrastructure Pipelines</li>',
                   '<li>Emergency Linux Response</li></ul><p>',
                   'Containerized Applications, Deployed via CICD, Interacting with Internet API Endpoints:<br>',
                   '<ul><li><a href=http://covid.hex7.com>http://covid.hex7.com</a> ',
                   'Covid-19 US Statistical Visualization</li>',
                   '<li><a href=http://reart.hex7.com>http://reart.hex7.com</a> ',
                   'Public Domain Art Slideshow</li>',
                   '<li><a href=http://hubbleshow.com>http://hubbleshow.com</a> ',
                   'NASA Hubble Telescope Image Gallery and Slideshow</li></ul>',
                   '</td><td width=100>.</td></tr></table>'])
    return _html



def _google():
    return [ "<html><head><title>Hex 7 Internet Solutions</title>",
             "<meta http-equiv=refresh content=20>",
             "<link rel=\"shortcut icon\" href=https://s3-us-west-1.amazonaws.com/hex7/favicon.ico>",
             "<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){",
             "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),",
             "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)",
             "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');",
             "ga('create', 'UA-32710227-1', 'auto'); ga('send', 'pageview');</script>",
             "<script data-ad-client='ca-pub-9792012528290289' async",
             "src='https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js'></script>",
             "</head><body><font name=garamond><p>" ]


def _rezo():
    _html = []
    _ip = _get_ip()
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

def _get_ip():
    if request.headers.getlist("X-Forwarded-For"):
        return request.headers.getlist("X-Forwarded-For")[0]
    else:
        return request.remote_addr

def _art():
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
    _html.extend([ "<table border=0 width=100%><tr>",
                   "<td width=40% align=center>",
                   "<b><font size=5>&copy;2000-2020</font></b><br>",
                   "<a target=_blank href=http://hex7.com>",
                   "<b><font color=", _textcolor, " size=+2>Hex 7 Internet Solutions</font></b></a>",
                   "</td> </tr></table>", request.headers.get('User-Agent'), '<br>', _get_ip(),
                   "</body></html>" ])
    return _html

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
