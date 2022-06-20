#! /bin/bash

start_server() {
	python3 script/integration-test-server.py
}

stop_server() {
	curl http://127.0.0.1:8000/STOP
}

integration_test_upload_diff() {
	fastlane integration_test_upload_dif
}

if ! (start_server & integration_test_upload_diff) ; then
	stop_server
  	exit 1
else 
	stop_server
	exit 0
fi
