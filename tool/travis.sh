#!/bin/bash

# Copyright 2013 Google Inc. All Rights Reserved.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

STATUS=0

# Analyze package.
dartanalyzer .
ANALYSIS_STATUS=$?
if [[ $ANALYSIS_STATUS -ne 0 ]]; then
  STATUS=$ANALYSIS_STATUS
fi

# Start chromedriver.
chromedriver --port=4444 --url-base=wd/hub &
PID=$!

# Run tests.
pub run test -r expanded -p vm,content-shell -j 1
TEST_STATUS=$?
if [[ $TEST_STATUS -ne 0 ]]; then
  STATUS=$TEST_STATUS
fi

# Exit chromedriver.
kill $PID

exit $STATUS
