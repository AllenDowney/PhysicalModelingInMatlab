import csv
import re
from glob import glob


link_map = {}
with open('urls.csv') as csvfile:
    reader = csv.reader(csvfile)
    for i, row in enumerate(reader):
        slashtag, destination = row
        link_map[destination] = 'https://greenteapress.com/matlab/' + slashtag

for filename in glob('../*.tex'):
    outname = filename.split('/')[-1]
    fout = open(outname, 'w')

    for line in open(filename):


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
        fout.write(line)
    fout.close()
