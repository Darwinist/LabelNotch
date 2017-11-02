<div align="center">
    <h1>Label Notch</h1>
    <img src="/Assets/Logo.png" alt="Label Notch" width=460px><br><br>
    <p><em>A static desktop label in a snazzy notch.</em></p>
    <span>
        <img src="https://img.shields.io/badge/Swift-4-yellow.svg" alt="Swift 4">
        <img src="https://img.shields.io/badge/platform-macOS-lightgray.svg" alt="MacOS Platform">
        <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License">
    </span>
</div>

> Label Notch uses the style of the iPhone X sensor cutout to display simple information on the mac desktop.

Great for displaying machine id's right on the desktop. By default the machines `hostname` is displayed.
  - Can be customized to any string to display deployed mac's custom identifiers.
  - The content is centered and can be changed based on editable plist values.

<p align="center">
  <img src="/Assets/nightswitch.gif" alt="" width=600>
  <em>Switching to dark mode.</em>
  <br>
  <br>
</p>

|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Features |
|-|----------|
|:new_moon:|Automatically adjusts between dark/light system settings. |
|:computer:|Customizable via terminal command. |
|:tophat:|Runs as a background launch agent. |
|:free:|Open Source. Easy to extend for your own implementations. |


## Installation
1. Copy the compiled `labelnotch` application to `/usr/local/bin`
  ```Bash
  sudo cp {the/build/path}/labelnotch /usr/local/bin/labelnotch
  ```
1. Create a *Launch Agent* for the user. This will start the application upon login.
  ```Bash
  mkdir -p ~/Library/LaunchAgents
  cp com.darwinist.labelnotch.plist ~/Library/LaunchAgents/com.darwinist.labelnotch.plist # Copy plist to user's Launch Agents
  ```
1. Launch for the first time
  ```Bash
  launchctl load -w ~/Library/LaunchAgents/com.darwinist.labelnotch.plist
  ```
1. Update the text:
  ```Bash
  defaults write com.darwinist.labelnotch title "MC00010349"

  launchctl unload ~/Library/LaunchAgents/com.darwinist.labelnotch.plist
  launchctl load -w ~/Library/LaunchAgents/com.darwinist.labelnotch.plist
  ```


## Changing the Label Text
The label text can be interfaced with via the `defaults` command-line utility.

```Bash
defaults write com.darwinist.labelnotch title "Machine MC00010349"
```

After changing the setting via defaults, re-spring the application:

```Bash
launchctl unload ~/Library/LaunchAgents/com.darwinist.labelnotch.plist

launchctl load -w ~/Library/LaunchAgents/com.darwinist.labelnotch.plist
```

## License
Desktop Machine Identifier is available under the MIT license. See the LICENSE file for more info.
