
# Kanagawa for [tmux](https://github.com/tmux/tmux/wiki)

[Kanagawa](https://github.com/rebelot/kanagawa.nvim/tree/master) theme for TMUX with silent colors.

Forked from [dracula/tmux](https://github.com/dracula/tmux).

![Screenshot](./screenshot.png)

## Install
To activate the theme add the following line to your `.tmux.conf`.

    set -g @plugin 'Nybkox/tmux-kanagawa'
For advanced instructions look at [INSTALL.md](https://github.com/Nybkox/tmux-kanagawa/blob/master/INSTALL.md) or check official instructions of [dracula/tmux](https://draculatheme.com/tmux).  Just replace all `dracula` occurrences with `kanagawa`.

## Configuration

Configuration and options can be found at [draculatheme.com/tmux](https://draculatheme.com/tmux).
Just replace all `dracula` occurrences with `kanagawa`.

## Features

- Support for powerline
- Day, date, time, timezone
- Current location based on network with temperature and forecast icon (if available)
- Network connection status, bandwidth and SSID
- SSH session user, hostname and port of active tmux pane
- Git branch and status
- Battery percentage and AC power connection status
- Refresh rate control
- CPU usage (percentage or load average)
- RAM usage (system and/or tmux server)
- GPU usage
- Custom status texts from external scripts
- GPU VRAM usage
- GPU power draw
- Color code based on whether a prefix is active or not
- List of windows with the current window highlighted
- When prefix is enabled, a smiley face turns from green to yellow
- When charging, 'AC' is displayed
- If forecast information is available, a ☀, ☁, ☂, or ❄ unicode character corresponding with the forecast is displayed alongside the temperature
- Info if the Panes are synchronized
- Spotify playback (needs the tool spotify-tui installed)
- Music Player Daemon status (needs the tool mpc installed)
- Current kubernetes context
- Countdown to tmux-continuum save
- Current working directory of tmux pane

## Known issues
You may need to manually give permission to plugin's scripts.
```bash
cd ~/.tmux/plugins/tmux-kanagawa
chmod u+x kanagawa.tmux
chmod u+x ./**/*.sh
```

## Compatibility

Compatible with macOS and Linux. Tested on tmux 3.1b
FreeBSD compatibility is in development

## License

[MIT License](./LICENSE)
