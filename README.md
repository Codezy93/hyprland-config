# Dusk Garden — Hyprland Config

A macOS-inspired Hyprland rice with a subtle cyberpunk accent. Clean, dark, minimal.

**Theme:** Dusk Garden — soft neutrals with mint/rose highlights
**Platform:** Arch Linux + Hyprland (NVIDIA optional)

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
| Screen recording | `wf-recorder` `slurp` |
| Clipboard | `wl-clipboard` `cliphist` |
| Desktop widgets | `eww-wayland` |
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
| Shell extras | `pokemon-colorscripts-git` `fastfetch` |

> **NVIDIA users:** The installer will prompt you. If you select NVIDIA, it installs `nvidia-dkms` `nvidia-utils` `egl-wayland` and enables `hypr/nvidia.conf`. You also need `nvidia_drm.modeset=1` in your kernel params.

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
5. Optionally configure NVIDIA drivers and kernel hooks
6. Enable system services (bluetooth, NetworkManager, PipeWire)

### Updating configs

To re-deploy configs without reinstalling packages:

```bash
chmod +x update.sh
./update.sh
```

This copies all config files and reloads Hyprland, Waybar, Dunst, and Eww.

### Post-install

```bash
# 1. Add a default wallpaper (supports png, jpg, gif, webp)
cp your-wallpaper.gif ~/.config/hypr/wallpapers/default.gif

# 2. Set your city for the weather widget
#    Add to your shell profile (~/.bashrc or ~/.zshrc):
export WEATHER_CITY="London"

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
| `SUPER + M` | Maximize (monocle) |
| `SUPER + T` | Toggle float/tile |
| `SUPER + C` | Center window |
| `SUPER + P` | Pseudo-tile |
| `SUPER + J` | Toggle split direction |
| `SUPER + SHIFT + Q` | Exit Hyprland |

### Focus & Move

| Key | Action |
|---|---|
| `SUPER + arrow keys` | Move focus |
| `SUPER + H/L/K/J` | Move focus (Vim) |
| `SUPER + SHIFT + arrow keys` | Move window |
| `SUPER + SHIFT + H/L/K/J` | Move window (Vim) |
| `SUPER + CTRL + arrow keys` | Resize window |
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
| `SUPER + scroll` | Cycle workspaces |

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

Edit `hypr/keybinds.conf` and uncomment/set:
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

Set via environment variable in your shell profile:
```bash
export WEATHER_CITY="London"
```

Or edit `~/.config/hypr/scripts/weather.sh` directly.

### Dark / Light mode

Toggle with `SUPER + D`. The script updates:
- Hyprland colors (`colors.conf`)
- Waybar CSS (`@define-color` variables)
- Dunst notification colors
- Kitty terminal colors
- GTK theme (via gsettings)

### NVIDIA

NVIDIA env vars live in `hypr/nvidia.conf` (separate from the main config). The installer enables this automatically if you select NVIDIA during setup. To enable/disable manually:

```ini
# In hypr/hyprland.conf, uncomment to enable:
source = ~/.config/hypr/nvidia.conf
```

### Fonts

The config uses **JetBrainsMono Nerd Font** across all components (waybar, wofi, dunst, kitty, hyprlock). SF Pro Display and Inter are listed as fallbacks in waybar/wofi CSS.

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
│   ├── nvidia.conf         # NVIDIA env vars (optional source)
│   ├── hypridle.conf       # Idle/sleep timeouts
│   ├── hyprlock.conf       # Lock screen layout
│   ├── themes/
│   │   └── colors.conf     # Color palette variables
│   ├── scripts/
│   │   ├── wallpaper.sh    # Wofi wallpaper picker
│   │   ├── powermenu.sh    # Wofi power menu
│   │   ├── darkmode-toggle.sh  # Dark/light theme switch
│   │   ├── darkmode-status.sh  # Waybar dark mode indicator
│   │   ├── dunst-status.sh     # Waybar notification indicator
│   │   ├── keybinds.sh         # Wofi keybind cheatsheet
│   │   └── weather.sh          # Waybar weather widget
│   └── wallpapers/         # Your wallpapers (gitignored)
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
├── eww/
│   ├── eww.yuck            # Widget layout
│   └── eww.scss            # Widget styling
├── install.sh              # Full Arch Linux installer
└── update.sh               # Config-only updater (no packages)
```

---

## Notes

- **NVIDIA:** Env vars are in a separate `hypr/nvidia.conf` file, sourced only when enabled. Non-NVIDIA users don't need to touch anything.
- **Gestures:** Workspace swipe gestures are present but commented out in `hyprland.conf` — uncomment to enable.
- **Cursor:** Uses `macOS-Monterey` from the `apple-cursor` AUR package. Change in `hypr/appearance.conf` and `hypr/autostart.conf` if you prefer another.
- **Shell extras:** The installer adds `pokemon-colorscripts-git` and `fastfetch` for terminal flair.
- **Desktop widgets:** Eww is configured with a clock widget. Customize in `eww/eww.yuck` and `eww/eww.scss`.
