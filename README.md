# Dracula for [tmux](https://github.com/tmux/tmux/wiki)

> A dark theme for [tmux](https://github.com/tmux/tmux/wiki)

![Screenshot](./screenshot.png)

## Install

All instructions can be found [in the docs](./INSTALL.md).

## Configuration

Configuration and options can be found [in the docs](/docs/CONFIG.md).

## Color Theming

In depth configuration of Colors and alternative themes can be found [in the docs](/docs/color_theming/README.md)

## Features

- Support for powerline
- Support for NerdFonts
- Day, date, time, timezone
- [Fully custom color theming](/docs/color_theming/README.md)
- Current location based on network with temperature and forecast icon (if available)
- SSH session user, hostname and port of active tmux pane
- Network connection status, bandwidth, SSID and public IP (requires `curl`)
- Git branch and status
- Battery percentage and AC power connection status with icons
- Refresh rate control
- CPU usage (percentage or load average)
- CPU architecture
- RAM usage (system and/or tmux server)
- Custom status texts from external scripts
- GPU stats
    - usage, power draw, and VRAM usage for NVIDIA on Linux, with partial support for amd/ intel
    - usage, and power draw for MacOS. **requires sudo privileges**
- Color code based on whether a prefix is active or not
- List of windows with the current window highlighted
- When prefix is enabled, the left status bar widget turns from green to yellow
- If forecast information is available, a ☀, ☁, ☂, or ❄ unicode character corresponding with the forecast is displayed alongside the temperature
- Read system temperature
- Read system uptime
- Info if the Panes are synchronized
- Spotify playback (needs the tool spotify-tui installed). max-len can be configured.
- Music Player Daemon status (needs the tool mpc installed)
- Playerctl, get current track metadata
- Current kubernetes context
- Countdown to tmux-continuum save
- Current working directory of tmux pane
- Kerberos TGT expiration date
- Show your Libre Freestyle 3 readings [Setup instructions](./scripts/libre.sh)

## Compatibility

Compatible with macOS and Linux. Tested on tmux 3.1b
FreeBSD compatibility is in development

## Team

This theme is maintained by the following person(s) and a bunch of [awesome contributors](https://github.com/dracula/tmux/graphs/contributors).

| [![Ethan Edwards](https://avatars1.githubusercontent.com/u/60861925?s=70&v=4)](https://github.com/ethancedwards8) | [![Hugo Meinhof](https://avatars.githubusercontent.com/u/19731833?s=70&v=4)](https://github.com/theoreticallyhugo) | [![Dane Williams](https://avatars2.githubusercontent.com/u/22798229?s=70&v=4)](https://github.com/danerwilliams) |
|-------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| [Ethan Edwards](https://github.com/ethancedwards8)                                                                | [Hugo Meinhof](https://github.com/theoreticallyhugo)                                                               | [Dane Williams](https://github.com/danerwilliams)                                                                |

## Community

- [Twitter](https://twitter.com/draculatheme) - Best for getting updates about themes and new stuff.
- [GitHub](https://github.com/dracula/dracula-theme/discussions) - Best for asking questions and discussing issues.
- [Discord](https://draculatheme.com/discord-invite) - Best for hanging out with the community.

## License

[MIT License](./LICENSE)
