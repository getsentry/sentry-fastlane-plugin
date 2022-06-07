#! /bin/bash

python3 script/integration-test-server.py & fastlane integration_test
curl http://127.0.0.1:8000/STOP
