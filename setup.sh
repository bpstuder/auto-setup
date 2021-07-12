#!/bin/zsh
###
# File: setup.sh
# File Created: 2021-07-01 14:09:02
# Usage : This script is designed to install all the tools I need using Homebrew
# Author: Benoit-Pierre Studer
# -----
# HISTORY:
###

#####################
# Variables to edit
#####################

TAP_LIST=(
    "homebrew/autoupdate"
    "homebrew/cask-fonts"
)

APPLICATION_LIST=(
    "svn" #Prerequisite for fonts
    "appcleaner"
    "autopkgr"
    "cyberduck"
    "disk-inventory-x"
    "dropbox"
    "firefox"
    "font-inconsolata"
    "font-roboto"
    "font-clear-sans"
    "github"
    "handbrake"
    "font-source-code-pro"
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

INSTALL_OH_MY_ZSH='true'
OH_MY_ZSH_THEME='amuse'
LOG="./auto-setup.log"

#####################
# Main code
#####################

function LogVerbose () {
    case ${1} in
    ok)
        echo -e "\U2705 - ${2}" | tee -a "${LOG}"
        ;;
    warning)
        echo -e "\U26A0 - ${2}" | tee -a "${LOG}"
        ;;
    error)
        echo -e "\U274C - ${2}" | tee -a "${LOG}"
        ;;
    info)
        echo -e "\U2139 - ${2}" | tee -a "${LOG}"
        ;;
    *)
        echo -e "\U2753 - ${2}" | tee -a "${LOG}"
        ;;
    esac
}

# Ensure Apple's command line tools are installed
if ! which cc >/dev/null; then
    LogVerbose "info" "Installing Xcode Command Line Tools"
    xcode-select --install
    LogVerbose "ok" "Done"
else
    LogVerbose "ok" "Xcode already installed. Skipping."
fi

if ! which brew >/dev/null; then
    LogVerbose "info" "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    LogVerbose "info" "Registering Homebrew"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    LogVerbose "ok" "Done"
else
    LogVerbose "ok" "Homebrew already installed. Skipping."
fi

for TAP in "${TAP_LIST[@]}"; do
    LogVerbose "info" "Processing tap : ${TAP}"
    brew tap ${TAP}
    LogVerbose "ok" "Done"
done

for APPLICATION in "${APPLICATION_LIST[@]}"; do
    # LogVerbose "info" "Processing: ${APPLICATION}"
    LogVerbose "info" "Checking if ${APPLICATION} is installed"
    IS_INSTALLED=$(brew list -1 | grep ${APPLICATION})
    if [[ -z ${IS_INSTALLED} ]]; then
        brew install ${APPLICATION} --force >> /dev/null
        LogVerbose "ok" "Done"
    else
        LogVerbose "ok" "${APPLICATION} already installed"
    fi
done

LogVerbose "info" "Checking if Brew Autoupdate is set up"
AUTOUPDATE_STATUS=$(brew autoupdate status | awk -F '.' '{print $1}')
if [[ "${AUTOUPDATE_STATUS}" == "Autoupdate is not configured" ]]; then
    LogVerbose "info" "Setting Autoupdate"
    brew autoupdate start --upgrade --cleanup --enable-notification
    LogVerbose "ok" "Done"
else
    LogVerbose "ok" "Autoupdate running"
fi

if [[ ${INSTALL_OH_MY_ZSH} == true ]]; then
    LogVerbose "info" "Installing Oh My Zsh"
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    if [[ $? == 0 ]]; then
        LogVerbose "ok" "Done"
        LogVerbose "info" "Changing theme to ${OH_MY_ZSH_THEME}"
        sed -i '' "s/robbyrussell/${OH_MY_ZSH_THEME}/g" .zshrc
        LogVerbose "ok" "Done"
    else
        LogVerbose "error" "Unable to install Oh My Zsh"
    fi
else
    LogVerbose "info" "Skipping Oh My Zsh setup"
fi

LogVerbose "ok" "Script execution complete"