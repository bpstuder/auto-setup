#!/bin/zsh
###
# File: setup.sh
# File Created: 2021-07-01 14:09:02
# Usage :
# Author: Benoit-Pierre Studer
# -----
# HISTORY:
###

#####################
# Variables to edit
#####################

TAP_LIST=(
    "homebrew/autoupdate"
)

APPLICATION_LIST=(
    "appcleaner"
    "autopkgr"
    "cyberduck"
    "disk-inventory-x"
    "dropbox"
    "firefox"
    "github"
    "handbrake"
    "homebrew/cask-fonts/font-sauce-code-pro-nerd-font"  
    "iina"
    "iterm2"
    "keepassxc"
    "macfuse"
    "mactracker"
    "plex"
    "postman"
    "powershell"
    "profilecreator"
    "rectangle"
    "slack"
    "suspicious-package"
    "veracrypt"
    "visual-studio-code"
    "whatsapp"
    "zoom"
)

#####################
# Main code
#####################

# Ensure Apple's command line tools are installed
if ! which cc >/dev/null; then
    echo "Installing Xcode Command Line Tools"
    xcode-select --install
    echo "\U2705 - Done"
else
    echo "\U2705 - Xcode already installed. Skipping."
fi

if ! which brew >/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Registering Homebrew"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "\U2705 - Done"
else
    echo "\U2705 - Homebrew already installed. Skipping."
fi

for TAP in "${TAP_LIST[@]}"; do
    echo "Processing tap : ${TAP}"
    brew tap ${TAP}
    echo "\U2705 - Done"
done

for APPLICATION in "${APPLICATION_LIST[@]}"; do
    echo "Processing: ${APPLICATION}"
    echo "Checking if ${APPLICATION} is installed"
    IS_INSTALLED=$(brew list -1 | grep ${APPLICATION})
    if [[ -z ${IS_INSTALLED} ]]; then
        brew install ${APPLICATION} --force >> /dev/null
        echo -e "\U2705 - Done"
    else
        echo -e "\U2705 - ${APPLICATION} already installed"
    fi
done

echo "Checking if Brew Autoupdate is set up"
AUTOUPDATE_STATUS=$(brew autoupdate status | awk -F '.' '{print $1}')
if [[ "${AUTOUPDATE_STATUS}" == "Autoupdate is not configured" ]]; then
    echo "Setting Autoupdate"
    brew autoupdate start --upgrade --cleanup --enable-notification
    echo -e "\U2705 - Done"
else
    echo -e "\U2705 - Autoupdate running"
fi