#!/usr/bin/env python3

from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse
import sys
import threading
import binascii
import json

uri = urlparse(sys.argv[1] if len(sys.argv) > 1 else 'http://127.0.0.1:8000')

class Handler(BaseHTTPRequestHandler):

	def do_GET(self):
		self.send_response(200)
		self.send_header('Content-type', 'application/json')
		self.end_headers()

		if self.path == "/STOP":
			print("HTTP server stopping!")
			threading.Thread(target=self.server.shutdown).start()
			return

		if self.path == "/api/0/organizations/sentry-sdks/chunk-upload/":
			self.wfile.write(json.dumps({ 
				'url': uri.geturl() + self.path,
				'chunkSize': 8388608,
				'chunksPerRequest': 64,
				'maxFileSize': 2147483648,
				'maxRequestSize': 33554432,
				'concurrency': 1,
				'hashAlgorithm': 'sha1',
				'compression': ['gzip'],
				'accept': ['debug_files','release_files','pdbs','sources','bcsymbolmaps']
			}).encode('utf-8'))

print("HTTP server listening on {}".format(uri.geturl()))
print("To stop the server, execute a GET request to {}/STOP".format(uri.geturl()))

httpd = HTTPServer((uri.hostname, uri.port), Handler)
target = httpd.serve_forever()
