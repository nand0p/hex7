from random import randint
import subprocess
import json
import sys
import os

subprocess.call('pip3 install ipwhois -t /tmp/ --no-cache-dir'.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
subprocess.call('pip3 install netaddr -t /tmp/ --no-cache-dir'.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
sys.path.insert(1, '/tmp/')
from ipwhois import IPWhois
from netaddr import IPAddress


color = '#FF0000'
rows = 55
columns = 200
width = 65
height = 175
density = 80
debug = False


def head():
    html = []
    html.append('<html><head><title>Hex7 Internet Solutions</title></head><body>')
    html.append('<center><h1 name=title>Hex7 Internet Solutions</h1><p><br><p>')
    return html

def rezo(ip):
    html = []
    if ip:
        html.extend([ '<h2 name=ip>Welcome, ', ip, '</h2><br>' ])
        if not IPAddress(ip).is_private():
            ip_info = IPWhois(ip).lookup_rdap(depth=1)
            entity = ip_info.get('entities')[0]
            html.extend([ ip_info.get('network').get('name'), '<br>',
                          ip_info.get('network').get('cidr'), '<br>',
                          ip_info.get('network').get('handle'), '<br>',
                          ip_info.get('network').get('links')[0], '<br>' ])
            html.append(ip_info.get('objects').get(entity).get('contact').get('address')[0].get('value'))

    return html


def art():
    html = []
    html.append('<p><br><table>')
    column_counter = 0
    while column_counter < columns:
        column_counter = column_counter + 1
        html.append('<tr>')
        row_counter = 0
        while row_counter < rows:
            row_counter = row_counter + 1
            if randint(0,density) == 0:
                html.extend([ '<td height=', height,
                              ' width=', width,
                              ' bgcolor=', color,
                              '><center>&nbsp;' ])
            else:
                html.extend([ '<td width=', width, '>' ])
            html.append('</td><td>')
        html.append('</td></tr>')
    html.append('</table>')
    return html


def foot(ip, user_agent, x_trace):
    html = []
    textcolor = 'red'
    html.extend([ '<table border=0 width=100%><tr>',
                  '<td width=40% align=center>',
                  '<b><font size=5>&copy;2024 </font></b>',
                  '<a target=_blank href=https://www.hex7.com>',
                  '<b><font color=', textcolor, ' size=+2>Hex 7 Internet Solutions</font></b></a>',
                  '</td></tr></table>', user_agent, '<br>', 
                  'X-Amzn-Trace-Id: ', x_trace, '<p>', ip,
                  '</body></html>' ])
    return html


def sales():
    html = []
    html.extend([ '<p><br><p><table><tr><td><ul>',
                  '<li>Linux Cloud Migrations with or without Containers</li>',
                  '<li>Infrastructure as Code with Terraform or Cloudformation.</li>',
                  '<li>Image Automation with Packer and Ansible.</li>',
                  '<li>HashiCorp Clusters with Consul, Nomad, and Vault.</li>',
                  '<li>CI/CD Git Pipelines and Branch Theory.</li>',
                  '<li>Multi-Cloud Configurations and Disaster Recovery Planning.</li>',
                  '<li>DevSecOps: Integrate Security in Application and Infrastructure Pipelines</li>',
                  '<li>Jira KanBan Scrum Project Management Best Practices.</li>',
                  '<li>Emergency Linux Response</li></ul><p>',
                  '</td></tr></table><br><h1>SUPPORT at HEX7 dot COM</h1><p>'])

    return html


def handler(event, context):
    html = []
    headers = event.get('headers')
    if headers:
        ip = headers.get('X-Forwarded-For')
        user = headers.get('User-Agent')
        x_trace = headers.get('X-Amzn-Trace-Id').split('=')[1]

    if debug:
        if headers:
            html.append('<p>IP: ' + ip)
            html.append('<p>User: ' + user)
            html.append('<p>X-Trace: ' + x_trace)
            html.append('<p><br><p>Headers: ' + str(headers) + '<p><br><p>')
        else:
            html.append(str(json.dumps(event, indent=4)))

    else:
        html.extend(head())
        html.extend(rezo(ip))
        html.extend(art())
        html.extend(sales())
        html.extend(foot(ip, user, x_trace))

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': ''.join([ str(x) for x in html ])
    }

