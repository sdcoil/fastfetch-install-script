#!/bin/bash
#
# get_fastfetch.sh
# Author: Stacy Coil (coil.1@osu.edu)
# Creation Date: 2025-06-05
# Version: 1.0
#
# A bash script that downloads and installs the latest Debian package for the running architecture.
# It then adds the script "motd.sh" to /etc/profile.d/.
#
# Some of the code is inspired by the following:
#     https://pythonguides.com/json-data-in-python/
#     https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
# among others.
set -e

# Get the CPU architecture
ARCH=$(arch)
# Location of the latest releases in JSON
RELEASES="https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest"

echo "Starting fastfetch install script..."
# Checking if script is running as root
if [[ $EUID -ne 0 ]]
then
        echo "ERROR: ${0} must run with elevated privilages. Attempting restart..." 1>&2
        if [[ "$(which sudo)X" != "X" ]]
        then
                echo "Using sudo to elevate privlages..." 1>&2
                sudo -p 'Please enter your password: ' bash $0 "$@"
                exit $?
        elif [[ "$(which su)X" != "X" ]]
        then
                echo "Using su to elevate privlages. Enter the password for root..." 1>&2
                su - root bash $0 "$@"
                exit $?
        else
                echo "ERROR: Sudo and su not found. Exiting..." 1>&2
                exit 1
        fi
        exit 1
fi

echo "Updating package repositories..."
apt -q update
echo "Installing required packages..."
# Minimal Debian packages needed to run
packages="ca-certificates curl python3 wget"
DEBIAN_FRONTEND=noninteractive apt -q -y install --no-install-recommends --no-install-suggests $packages

echo "Creating temporary file..."
TEMP_PACKAGE="$(mktemp)"

echo "Getting URL for Fastfetch Debian package for ${ARCH}..."
URL=$(curl -s $RELEASES | /usr/bin/python3 -c "import sys, json
assets=json.load(sys.stdin)['assets']
print([ asset for asset in assets if '${ARCH}.deb' in asset['name'] ][0]['browser_download_url'])
")

echo "Downloading fastfetch Debian package..."
wget -O "${TEMP_PACKAGE}" "${URL}"
echo "Installing fastfetch..."
dpkg -i "${TEMP_PACKAGE}"

echo "Adding fastfetch to MOTD..."
cat > /etc/profile.d/motd.sh << EOF
#!/bin/bash
printf "\n"
fastfetch
EOF

echo "Cleaning up..."
rm -f $TEMP_PACKAGE

echo "Complete. Exiting..."
