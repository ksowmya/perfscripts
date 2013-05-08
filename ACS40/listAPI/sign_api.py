#!/usr/bin/env python
import urllib2
import urllib
import hmac
import hashlib
import base64
import sys

def make_request(requests, secretKey):
        request = zip(requests.keys(), requests.values())
        request.sort(key=lambda x: str.lower(x[0]))

        #requestUrl = "&".join(["=".join([r[0], urllib.quote_plus(str(r[1]))]) for r in request])
        hashStr = "&".join(["=".join([str.lower(r[0]), str.lower(urllib.quote_plus(str(r[1]))).replace("+", "%20")]) for r in request])
        sig = urllib.quote_plus(base64.encodestring(hmac.new(secretKey, hashStr, hashlib.sha1).digest()).strip())
        print "%s"%sig
        #requestUrl += "&signature=%s"%sig
        #print requestUrl

if __name__ == '__main__':
    requests = {
                "apiKey": sys.argv[3],
                "command" : sys.argv[1]
               }
    paras = sys.argv[2].split("&")
    for i in paras:
        name = i.split("=")[0]
        value = i.split("=")[1]
        requests[name] = value
    secretKey = sys.argv[4]
    make_request(requests, secretKey)

