import csv
import re

link_map = {}
with open('urls.csv') as csvfile:
    reader = csv.reader(csvfile)
    for i, row in enumerate(reader):
        slashtag, destination = row
        link_map[destination] = 'http://modsimpy.com/' + slashtag


for line in open('../book.tex'):
    matches = re.findall(r'\\url\{([^\}]*)', line)
    if matches:
        for url in matches:
            key = url.replace('\\#', '#')
            try:
                short = link_map[key]
                line = line.replace(url, short)
            except KeyError:
                pass
                #print url
    print(line, end='')
