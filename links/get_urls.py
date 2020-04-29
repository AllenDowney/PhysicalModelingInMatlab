from re import findall
from glob import glob

urls = set()

for filename in glob('../*.tex'):
    for line in open(filename):
        matches = findall(r'\\url\{([^\}]*)', line)
        for match in matches:
            #print match
            urls.add(match)

for url in sorted(urls):
    print(",%s" % url)
