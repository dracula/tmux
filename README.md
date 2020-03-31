# Dracula for [tmux](https://github.com/tmux/tmux/wiki)

> A dark theme for [tmux](https://github.com/tmux/tmux/wiki)  
  
<<<<<<< HEAD
![Screenshot](./screenshot.jpg)  
=======
## Features
Day, date, time, timezone  
Current location based on network with temperature and forecast icon (if available)  
Network connection status and SSID  
Battery percentage and AC power connection status  
Color code based on if prefix is active or not  
List of windows with current window highlighted  
  
## Screenshots
![Alt text](screenshots/tmux-dracula-screenshot.jpg?raw=true "Tmux Dracula")  
tmux-dracula in action  
  
  
  
![Alt text](screenshots/alt-tmux-dracula-screenshot.jpg?raw=true "Tmux Dracula")  
When prefix is enabled smiley face turns from green to yellow  
When charging, 'AC' is displayed  
If forecast information is available, a ☀, ☁, ☂, or ❄ unicode character corresponding with the forecast is displayed alongside the temperature
  
## Compatibility
Designed for compatibility with Mac systems and tested on macOS 10.15 Catalina  
Compatibility with Linux systems and/or WSL on Windows is not yet available  
>>>>>>> 8e57456bdcd40f9b29d68b9f7848e84736782ff5
  
## Install

Use TPM (tmux plugin manager) and add to your .tmux.conf:  
`set -g @plugin 'danerwilliams/tmux-dracula'`  
Be sure that `run -b '~/.tmux/plugins/tpm/tpm'` is at the bottom of .tmux.config for tpm to work  
Restart tmux and then use `prefix + I` (capital I as in Install) to install  
  
<<<<<<< HEAD
## Features

* Day, date, time, timezone  
* Current location based on network with temperature and forecast icon (if available)  
* Network connection status and SSID  
* Battery percentage and AC power connection status  
* Color code based on if prefix is active or not  
* List of windows with current window highlighted  
* When prefix is enabled smiley face turns from green to yellow  
* When charging, 'AC' is displayed  
* If forecast information is available, a ☀, ☁, ☂, or ❄ unicode character corresponding with the forecast is displayed alongside the temperature  

## Compatibility

Designed for compatibility with Mac systems and tested on macOS 10.15 Catalina  
Compatibility with Linux systems and/or WSL on Windows is not yet available  

## Team

This theme is maintained by the following person(s) and a bunch of awesome contributors

## License

[MIT License](./LICENSE)
=======
## Troubleshooting
Some users have experienced issues where the weather does not load. 
This may be solved by manually running dracula.tmux:  
`~/.tmux/plugins/tmux-dracula/dracula.tmux`  
  
## License
This project is licensed under the MIT License - see [LICENSE.md](./LICENSE.md) for details
>>>>>>> 8e57456bdcd40f9b29d68b9f7848e84736782ff5
