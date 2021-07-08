# auto-setup
This script is designed to install all the tools I need using Homebrew

## How to configure it

In the setup.sh script, add the Homebrew Tap you need in TAP_LIST.
Do the same for the Casks in APPLICATION_LIST.

If you are looking for the name of an app, just do `brew search <appname>` in terminal.

You can choose to install Oh My Zsh, and change the theme. Set the variable INSTALL_OH_MY_ZSH to `true` and set the theme in OH_MY_ZSH_THEME.

## Logs

Logs are stored in the folder where the script is run, in auto-setup.log.

You can configure the filename in LOG variable. Be careful, the path must be writable by the user who runs the script.

## How to run it

- Open the terminal
- Set execution rights on the script
  - `chmod +x setup.sh`
- Run the script
  - `./setup.sh`

Enjoy !
