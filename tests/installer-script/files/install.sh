#!/usr/bin/env bash

# A URL pinned by a tag
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.5/aqua-installer
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.5/aqua-installer | bash -s -- -v v2.60.1

# A URL pinned by a commit SHA with the version as a comment
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/96a9bc20066c5bf5e275b41019cfc165b25f4e2e/aqua-installer # v4.0.5
url="https://raw.githubusercontent.com/aquaproj/aqua-installer/96a9bc20066c5bf5e275b41019cfc165b25f4e2e/aqua-installer" # v4.0.5
url='https://raw.githubusercontent.com/aquaproj/aqua-installer/96a9bc20066c5bf5e275b41019cfc165b25f4e2e/aqua-installer' # v4.0.5

# A URL pinned by a commit SHA without the version isn't updated by the digest manager
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/96a9bc20066c5bf5e275b41019cfc165b25f4e2e/aqua-installer

# aqua version
./aqua-installer -v v2.60.1
./aqua-installer -v 'v2.60.1'
./aqua-installer -v "v2.60.1"
./aqua-installer -i /tmp/aqua -v v2.60.1
