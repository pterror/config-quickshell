# quickshell config

## getting started

1. copy `Config.qml.example` to `Config.qml`
2. copy `shell.qml.example` to `shell.qml`

### keybinds (optional)

if `socat` is installed:

```ini
bind = $mainMod, Tab, exec, echo "workspaces_overview:toggle" | socat - UNIX-CONNECT:/run/user/1000/quickshell.sock
```

else if bsd `netcat` is installed:

```ini
bind = $mainMod, Tab, exec, echo "workspaces_overview:toggle" | nc -w 0 -U /run/user/1000/quickshell.sock
```

else:

```ini
bind = $mainMod, Tab, exec, hyprctl dispatch submap "quickshell:workspaces_overview:toggle" && hyprctl dispatch submap reset

# required for the above hack to work
submap = quickshell:workspaces_overview:toggle
bind = $mainMod, Tab, submap, reset
submap = reset
```
