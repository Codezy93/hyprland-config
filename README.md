# Dusk Garden — Sway Config

A macOS-inspired Sway rice with a subtle cyberpunk accent. Clean, dark, minimal.

**Theme:** Dusk Garden — soft neutrals with mint/rose highlights
**Platform:** Ubuntu Server 24.04 + Sway (Wayland)

---

## Preview

Colors: `#1C1C1E` bg · `#99E1D9` mint · `#B48291` rose · `#FFFAE3` cream

---

## Requirements

| Component | Package |
|---|---|
| Window manager | `sway` |
| Status bar | `waybar` |
| Launcher | `wofi` |
| Terminal | `kitty` |
| Notifications | `dunst` |
| Wallpaper | `swaybg` |
| Screen lock | `swaylock` |
| Idle daemon | `swayidle` |
| File manager | `thunar` |
| Screenshots | `grim` `slurp` |
| Screen recording | `wf-recorder` `slurp` |
| Clipboard | `wl-clipboard` `cliphist` |
| Desktop widgets | `eww` (build from source) |
| Audio | `pipewire` `pipewire-pulse` `wireplumber` |
| Brightness | `brightnessctl` |
| Media control | `playerctl` |
| Network | `network-manager` |
| Bluetooth | `blueman` |
| Audio GUI | `pavucontrol` |
| Auth agent | `policykit-1-gnome` |
| Fonts | `JetBrainsMono Nerd Font` `CaskaydiaCove Nerd Font` `noto-fonts` |
| XDG Portal | `xdg-desktop-portal-wlr` |
| Weather | `curl` `jq` |

---

## Installation

```bash
git clone https://github.com/yourusername/hyprland-config
cd hyprland-config
chmod +x ubuntu_setup.sh
./ubuntu_setup.sh
```

The installer will:
1. Update system packages
2. Install Sway + full Wayland stack
3. Install CLI tools (tmux, zsh, neovim, ripgrep, fzf, etc.)
4. Install user apps via snap (VS Code, Obsidian, Spotify, etc.)
5. Deploy all Dusk Garden configs to `~/.config/`
6. Enable system services (bluetooth, NetworkManager, PipeWire)

### Post-install

```bash
# 1. Add a default wallpaper (supports png, jpg, webp)
cp your-wallpaper.png ~/.config/sway/wallpapers/default.png

# 2. Set your city for the weather widget
#    Add to your shell profile (~/.bashrc or ~/.zshrc):
export WEATHER_CITY="London"

# 3. Start Sway
exec sway
```

---

## Keybindings

> Press `SUPER + /` inside Sway to open the interactive cheatsheet.

### Quick Launch

| Key | Action |
|---|---|
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + Space` | App launcher (Wofi) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + V` | Clipboard history |
| `SUPER + /` | Keybind cheatsheet |

### System

| Key | Action |
|---|---|
| `SUPER + X` | Power menu |
| `SUPER + D` | Toggle dark/light mode |
| `SUPER + W` | Wallpaper picker |
| `SUPER + N` | Toggle notifications |

### Screenshots & Recording

| Key | Action |
|---|---|
| `SUPER + SHIFT + S` | Area screenshot (copy) |
| `SUPER + SHIFT + 3` | Full screenshot (copy) |
| `SUPER + SHIFT + 4` | Area screenshot (copy) |
| `SUPER + SHIFT + R` | Toggle screen recording |

### Window Management

| Key | Action |
|---|---|
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + T` | Toggle float/tile |
| `SUPER + P` | Cycle layout (split/tabbed/stacking) |
| `SUPER + J` | Toggle split direction |
| `SUPER + R` | Enter resize mode |
| `SUPER + SHIFT + Q` | Exit Sway |

### Focus & Move

| Key | Action |
|---|---|
| `SUPER + arrow keys` | Move focus |
| `SUPER + H/L/K/J` | Move focus (Vim) |
| `SUPER + SHIFT + arrow keys` | Move window |
| `SUPER + SHIFT + H/L/K/J` | Move window (Vim) |
| `SUPER + R` then arrows | Resize window |
| `ALT + Tab` | Cycle windows |
| `SUPER + LMB drag` | Move window |
| `SUPER + RMB drag` | Resize window |

### Workspaces

| Key | Action |
|---|---|
| `SUPER + 1-9, 0` | Switch to workspace |
| `SUPER + SHIFT + 1-9, 0` | Move window to workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + ALT + S` | Move window to scratchpad |

### Media Keys

| Key | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume up 5% |
| `XF86AudioLowerVolume` | Volume down 5% |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp/Down` | Brightness +/-5% |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext/Prev` | Next/previous track |

---

## Customization

### Browser / default apps

Edit `sway/keybinds` and uncomment/set:
```
bindsym $mod+b exec firefox
```

### App-specific workspace assignments

Add to `sway/rules`:
```
assign [app_id="code"] workspace number 2
assign [app_id="firefox"] workspace number 3
```

Use `swaymsg -t get_tree` while an app is open to find its app_id.

### Monitor setup

Edit `sway/outputs`. Use `swaymsg -t get_outputs` to list available outputs.

```
# Single monitor (auto-detect)
output * bg ~/.config/sway/wallpapers/default.png fill

# Dual monitor example
output DP-1 resolution 2560x1440@144Hz position 0 0
output HDMI-A-1 resolution 1920x1080@60Hz position 2560 0
```

### Weather city

Set via environment variable in your shell profile:
```bash
export WEATHER_CITY="London"
```

Or edit `~/.config/sway/scripts/weather.sh` directly.

### Dark / Light mode

Toggle with `SUPER + D`. The script updates:
- Sway colors (`themes/colors`)
- Waybar CSS (`@define-color` variables)
- Dunst notification colors
- Kitty terminal colors
- GTK theme (via gsettings)

### Fonts

The config uses **JetBrainsMono Nerd Font** across all components (waybar, wofi, dunst, kitty, swaylock). **CaskaydiaCove Nerd Font** is used in kitty. SF Pro Display and Inter are listed as fallbacks in waybar/wofi CSS.

---

## Structure

```
hyprland-config/
├── sway/
│   ├── config            # Main entry — includes all below
│   ├── keybinds          # All keybindings
│   ├── autostart         # Startup programs
│   ├── rules             # Window rules (for_window)
│   ├── outputs           # Display configuration
│   ├── inputs            # Keyboard/touchpad/mouse
│   ├── appearance        # Borders, title bars, GTK
│   ├── swaylock.conf     # Lock screen configuration
│   ├── themes/
│   │   └── colors        # Color palette variables
│   ├── scripts/
│   │   ├── wallpaper.sh      # Wofi wallpaper picker
│   │   ├── powermenu.sh      # Wofi power menu
│   │   ├── darkmode-toggle.sh    # Dark/light theme switch
│   │   ├── darkmode-status.sh    # Waybar dark mode indicator
│   │   ├── dunst-status.sh       # Waybar notification indicator
│   │   ├── keybinds.sh           # Wofi keybind cheatsheet
│   │   └── weather.sh            # Waybar weather widget
│   └── wallpapers/       # Your wallpapers (png, jpg, webp)
├── hypr/                 # Legacy Hyprland configs (Arch)
├── waybar/
│   ├── config.jsonc      # Bar layout and modules
│   └── style.css         # Bar styling
├── wofi/
│   ├── config            # Wofi settings
│   └── style.css         # Wofi styling
├── dunst/
│   └── dunstrc           # Notification styling
├── kitty/
│   └── kitty.conf        # Terminal config
├── eww/
│   ├── eww.yuck          # Widget layout
│   └── eww.scss          # Widget styling
└── ubuntu_setup.sh       # Ubuntu + Sway installer
```

---

## Notes

- **Ubuntu Server:** This config is designed for Ubuntu Server 24.04 LTS with Sway installed on top. No desktop environment needed.
- **Sway vs Hyprland:** Sway does not support blur, animations, or rounded window corners natively. The visual style comes from waybar, dunst, kitty, and GTK theming.
- **Wallpapers:** Swaybg supports static images only (png, jpg, webp). The old mp4 video wallpapers from the Hyprland setup are not compatible.
- **Eww widgets:** Eww is not in Ubuntu repos — build from source if you want the clock widget. See [github.com/elkowar/eww](https://github.com/elkowar/eww).
- **Legacy Hyprland configs** are preserved in the `hypr/` directory for reference.
