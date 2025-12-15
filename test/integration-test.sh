#! /bin/bash

start_server() {
    python3 test/integration-test-server.py
}

stop_server() {
    curl http://127.0.0.1:8000/STOP
}

start_server &

# Deprecated. Remove with next major update.
if ! (fastlane integration_test_upload_dif) ; then
    stop_server
    exit 1
fi

if ! (fastlane integration_test_debug_files_upload) ; then
    stop_server
    exit 1
fi

if ! (fastlane integration_test_create_release) ; then
    stop_server
    exit 1
fi

if ! (fastlane integration_test_set_commits) ; then
    stop_server
    exit 1
fi

if ! (fastlane integration_test_create_deploy) ; then
    stop_server
    exit 1
fi

# Skipped: integration_test_upload_file - deprecated in sentry-cli 3.0.0
# The 'releases files' command has been removed.

if ! (fastlane integration_test_upload_sourcemap) ; then
    stop_server
    exit 1
fi

if ! (fastlane integration_test_upload_proguard) ; then
    stop_server
    exit 1
fi

stop_server
exit 0