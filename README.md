# CombinedTweak

A combined iOS jailbreak tweak that merges **Eneko** (dynamic wallpapers) and **Gravitation** (gravity effects) into a single, unified package.

## Features

### Eneko - Dynamic Wallpapers
- Set video wallpapers for lock screen and home screen
- Volume control for wallpaper audio
- Smart behavior settings (mute when music plays, disable in low power mode)
- Wallpaper zoom options
- Support for various video formats

### Gravitation - Gravity Effects
- Gravity-based physics for home screen icons
- Device motion sensing for realistic gravity effects
- Finger gravity interaction
- Shake to toggle effects
- Smooth animations and transitions

## Installation

1. Download the latest `.deb` package from releases
2. Install via your preferred package manager (Sileo, Zebra, etc.)
3. Respring your device
4. Configure settings in **Settings > CombinedTweak**

## Requirements

- iOS 14.5 or later
- Jailbroken device
- libGCUniversal dependency

## Building from Source

### Prerequisites
- Theos development environment
- libGCUniversal library

### Installing libGCUniversal
```bash
git clone https://github.com/MrGcGamer/LibGcUniversal.git
cd LibGcUniversal
make package install
```

### Building CombinedTweak
```bash
cd CombinedTweak
make clean
make package
```

### Troubleshooting Build Issues

If you encounter the error `'GcUniversal/GcImagePickerUtils.h' file not found`:

1. Ensure libGCUniversal is properly installed
2. Check that the library is linked correctly in the Makefile
3. The project uses `CombinedTweak_LIBRARIES = gcuniversal` to link the library
4. No direct header import is needed - the library provides the functionality at runtime

## Configuration

The tweak provides a unified preferences panel with sections for:

- **Eneko Settings**: Enable/disable dynamic wallpapers, configure lock screen and home screen wallpapers, adjust volume levels
- **Gravitation Settings**: Enable/disable gravity effects, configure finger gravity interaction
- **Tools**: Respring and reset preferences options
- **Links**: Source code and support links

## Compatibility

- iPhone, iPad, and iPod touch
- iOS/iPadOS 14.5+
- Supports both Rootless and traditional jailbreak environments

## Credits

- **Eneko** by Alexandra (@Traurige)
- **Gravitation** by Axs Studio
- Combined and maintained by CombinedTweak team

## License

This project combines components from both Eneko (GPLv3) and Gravitation projects. Please refer to individual component licenses for details.

## Support

For issues and feature requests, please visit the respective source repositories:
- [Eneko Issues](https://github.com/Traurige/Eneko/issues)
- [Gravitation Issues](https://github.com/AxsStudio/Gravitation/issues)
