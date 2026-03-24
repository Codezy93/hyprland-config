# Dusk Garden — Hyprland Config

A macOS-inspired Hyprland rice with a subtle cyberpunk accent. Clean, dark, minimal.

**Theme:** Dusk Garden — soft neutrals with mint/rose highlights
**Platform:** Arch Linux + Hyprland (NVIDIA supported)

---

## Preview

Colors: `#1C1C1E` bg · `#99E1D9` mint · `#B48291` rose · `#FFFAE3` cream

---

## Requirements

| Component | Package |
|---|---|
| Window manager | `hyprland` |
| Status bar | `waybar` |
| Launcher | `wofi` |
| Terminal | `kitty` |
| Notifications | `dunst` |
| Wallpaper | `swww` |
| Screen lock | `hyprlock` |
| Idle daemon | `hypridle` |
| File manager | `thunar` |
| Screenshots | `grimblast-git` |
| Clipboard | `wl-clipboard` `cliphist` |
| Audio | `pipewire` `pipewire-pulse` `wireplumber` |
| Brightness | `brightnessctl` |
| Media control | `playerctl` |
| Network | `network-manager-applet` |
| Bluetooth | `blueman` |
| Audio GUI | `pavucontrol` |
| Auth agent | `polkit-kde-agent` |
| Fonts | `ttf-jetbrains-mono-nerd` `noto-fonts` `noto-fonts-emoji` |
| Cursor | `apple-cursor` (macOS-Monterey) |
| GTK | `nwg-look` `adw-gtk3` |
| Qt | `qt6ct` |
| Weather | `curl` `jq` |

> **NVIDIA users:** also install `nvidia-dkms` `nvidia-utils` `egl-wayland` and set `nvidia_drm.modeset=1` in your kernel params.

---

## Installation

```bash
git clone https://github.com/yourusername/hyprland-config
cd hyprland-config
chmod +x install.sh
./install.sh
```

The installer will:
1. Auto-detect your AUR helper (`paru` preferred, falls back to `yay`, offers to install paru if neither is found)
2. Install all required packages
3. Back up any existing configs (optional prompt)
4. Deploy configs to `~/.config/`
5. Enable system services (bluetooth, NetworkManager, PipeWire)
6. Set cursor theme and check NVIDIA kernel params

### Post-install

```bash
# 1. Add a default wallpaper
cp your-wallpaper.png ~/.config/hypr/wallpapers/default.png

# 2. Set your city for the weather widget
#    Edit ~/.config/hypr/scripts/weather.sh and change CITY="Mumbai"

# 3. NVIDIA — verify kernel params if warned during install

# 4. Log out and select Hyprland from your display manager
```

---

## Keybindings

> Press `SUPER + /` inside Hyprland to open the interactive cheatsheet.

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

### Screenshots

| Key | Action |
|---|---|
| `SUPER + SHIFT + S` | Area screenshot (copy) |
| `SUPER + SHIFT + 3` | Full screenshot (copy) |
| `SUPER + SHIFT + 4` | Area screenshot (copy) |

### Window Management

| Key | Action |
|---|---|
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + M` | Maximize (monocle) |
| `SUPER + T` | Toggle float/tile |
| `SUPER + C` | Center window |
| `SUPER + P` | Pseudo-tile |
| `SUPER + J` | Toggle split direction |
| `SUPER + SHIFT + Q` | Exit Hyprland |

### Focus & Move

| Key | Action |
|---|---|
| `SUPER + ←/→/↑/↓` | Move focus |
| `SUPER + H/L/K/J` | Move focus (Vim) |
| `SUPER + SHIFT + ←/→/↑/↓` | Move window |
| `SUPER + SHIFT + H/L/K/J` | Move window (Vim) |
| `SUPER + CTRL + ←/→/↑/↓` | Resize window |
| `ALT + Tab` | Cycle windows |
| `SUPER + LMB drag` | Move window |
| `SUPER + RMB drag` | Resize window |

### Workspaces

| Key | Action |
|---|---|
| `SUPER + 1–9, 0` | Switch to workspace |
| `SUPER + SHIFT + 1–9, 0` | Move window to workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + ALT + S` | Move window to scratchpad |
| `SUPER + scroll` | Cycle workspaces |

### Media Keys

| Key | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume up 5% |
| `XF86AudioLowerVolume` | Volume down 5% |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp/Down` | Brightness ±5% |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext/Prev` | Next/previous track |

---

## Customization

### Browser / default apps

Edit `hypr/hyprland.conf` and uncomment/set:
```ini
env = BROWSER, firefox   # your preferred browser
```

Add a browser launch keybind in `hypr/keybinds.conf`:
```ini
bind = $mainMod, B, exec, firefox
```

### App-specific workspace assignments

Add to `hypr/rules.conf`:
```ini
windowrule = workspace 2, match:class:^(YourEditor)$
windowrule = workspace 3, match:class:^(YourBrowser)$
```

Use `hyprctl clients` while an app is open to find its class name.

### Monitor setup

Edit `hypr/monitors.conf`. Use `hyprctl monitors all` to list available outputs.

```ini
# Single monitor (auto-detect)
monitor = , preferred, auto, 1

# Dual monitor example
monitor = DP-1, 2560x1440@144, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1
```

### Weather city

Edit `hypr/scripts/weather.sh`:
```bash
CITY="YourCity"
```

### Dark / Light mode

Toggle with `SUPER + D`. The script writes a new `colors.conf` and sends `SIGUSR2` to waybar. To make the change persist through `hyprctl reload`, the toggle must have been run at least once after boot.

### Fonts

The config uses **JetBrainsMono Nerd Font** for the lock screen and **SF Pro Display / Inter** for waybar (falls back to JetBrainsMono Nerd Font if SF Pro isn't installed).

---

## Structure

```
hyprland-config/
├── hypr/
│   ├── hyprland.conf       # Main entry — sources all below
│   ├── appearance.conf     # Decorations, animations, blur
│   ├── keybinds.conf       # All keybindings
│   ├── rules.conf          # Window/layer rules
│   ├── autostart.conf      # Startup programs
│   ├── monitors.conf       # Display configuration
│   ├── hypridle.conf       # Idle/sleep timeouts
│   ├── hyprlock.conf       # Lock screen layout
│   ├── themes/
│   │   └── colors.conf     # Color palette variables
│   └── scripts/
│       ├── wallpaper.sh    # Wofi wallpaper picker
│       ├── powermenu.sh    # Wofi power menu
│       ├── darkmode-toggle.sh  # Dark/light theme switch
│       ├── darkmode-status.sh  # Waybar dark mode indicator
│       ├── dunst-status.sh     # Waybar notification indicator
│       ├── keybinds.sh         # Wofi keybind cheatsheet
│       └── weather.sh          # Waybar weather widget
├── waybar/
│   ├── config.jsonc        # Bar layout and modules
│   └── style.css           # Bar styling
├── wofi/
│   ├── config              # Wofi settings
│   └── style.css           # Wofi styling
├── dunst/
│   └── dunstrc             # Notification styling
├── kitty/
│   └── kitty.conf          # Terminal config
└── install.sh              # Arch Linux installer
```

---

## Notes

- **NVIDIA:** The config includes `NVD_BACKEND, direct` and `GBM_BACKEND, nvidia-drm` env vars. Remove these if you're not on NVIDIA.
- **Gestures:** Workspace swipe gestures are present but commented out in `hyprland.conf` — uncomment to enable.
- **Cursor:** Uses `macOS-Monterey` from the `apple-cursor` AUR package. Change in `hypr/appearance.conf` and `hypr/autostart.conf` if you prefer another.
