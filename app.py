from random import randint
from pprint import pprint
import json
import sys
import os


color = '#FF0000'
rows = '55'
columns = '200'
width = '65'
height = '175'
density = '80'
debug = False
save_html = True

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
    while column_counter < int(columns):
        column_counter = column_counter + 1
        html.append('<tr>')
        row_counter = 0
        while row_counter < int(rows):
            row_counter = row_counter + 1
            if randint(0, int(density)) == 0:
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


def foot():
    html = []
    textcolor = 'red'
    html.extend([ '<table border=0 width=100%><tr>',
                  '<td width=40% align=center>',
                  '<b><font size=5>&copy;2024 </font></b>',
                  '<a target=_blank href=https://www.hex7.com>',
                  '<b><font color=', textcolor, ' size=+2>Hex 7 Internet Solutions</font></b></a>',
                  '</td></tr></table>' ])
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


html = []
html.extend(head())
html.extend(art())
html.extend(foot())
pprint(html)

if save_html:
  with open("index.html", 'w', encoding='utf-8') as f:
    f.write(''.join(html))
