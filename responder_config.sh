#!/bin/bash

# Copyright 2024 Secureworks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Technique discovered by Nevada Romsdahl in 2023

# Run as root to modify root-owned files
if [ `id -u` -ne 0 ]; then
   echo "Error: $0 must be run as root" 1>&2
   exit 1
fi

# Path for responder config, below is default for Kali and Parrot, change if needed
CONFIG_PATH=/usr/share/responder/Responder.conf
# Path for responder files, below is default for Kali and Parrot, change if needed
FILES_PATH=/usr/share/responder/files/

# Make a backup of the original config
cp $CONFIG_PATH $CONFIG_PATH.bak
echo "Backup created at " $CONFIG_PATH.bak

#Copy our 302.html into the Responder Files directory
cp ./302.html $FILES_PATH

# Change the config to point to our 302.html file locally
sed -i 's/HtmlFilename\ \=\ files\/AccessDenied.html/HtmlFilename\ \=\ files\/302.html/g' $CONFIG_PATH

# Change the config to serve HTML
sed -i 's/Serve\-Html\ \=\ Off/Serve\-Html\ \=\ On/g' $CONFIG_PATH
