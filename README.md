# tmux-dracula
Color scheme for tmux inspired by the popular dracula theme  
For dracula theme on other platforms check out the <a href="https://draculatheme.com/" target="_blank">official dracula theme</a>  
  
## Features
Day, date, time, timezone  
Current location based on network with temperature and forecast icon (if available)  
Network connection status and SSID  
Battery percentage and AC power connection status  
Color code based on if prefix is active or not  
List of windows with current window highlighted  
  
## Screenshots
![Alt text](screenshots/tmux-dracula-screenshot.jpg?raw=true "Tmux Dracula")
  
## Compatibility
Designed for compatibility with Mac systems and tested on macOS 10.15 Catalina  
Compatibility with Linux systems and/or WSL on Windows is not yet available  
  
## Installation
Use TPM (tmux plugin manager) and add to your .tmux.conf:  
`set -g @plugin 'danerwilliams/tmux-dracula'`  
Be sure that `run -b '~/.tmux/plugins/tpm/tpm'` is at the bottom of .tmux.config for tpm to work  
Restart tmux and then use `prefix + I` (capital I as in Install) to install  
  
## Troubleshooting
Some users have experienced issues where the weather does not load immediately. 
This may be solved by manually running dracula.tmux:  
`~/.tmux/plugins/tmux-dracula/dracula.tmux`  
