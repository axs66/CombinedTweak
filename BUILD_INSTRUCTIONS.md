# CombinedTweak Build Instructions

## Quick Fix for libGCUniversal Error

The error `'GcUniversal/GcImagePickerUtils.h' file not found` occurs because the build environment doesn't have access to the libGCUniversal headers.

### Solution 1: Install libGCUniversal in Build Environment

If you're using GitHub Actions or similar CI/CD:

```yaml
- name: Install libGCUniversal
  run: |
    git clone https://github.com/MrGcGamer/LibGcUniversal.git
    cd LibGcUniversal
    make package install
```

### Solution 2: Local Build with Pre-installed libGCUniversal

If you have libGCUniversal installed locally:

```bash
cd CombinedTweak
make clean
make package
```

### Solution 3: Alternative Approach (No libGCUniversal)

If you want to avoid the libGCUniversal dependency entirely, you can modify the EnekoTweak.m file to use a different video picker implementation or remove the video wallpaper functionality.

## Current Configuration

The project is configured to:
- Link against libGCUniversal library (`CombinedTweak_LIBRARIES = gcuniversal`)
- Use forward declarations for GcImagePickerUtils
- Provide runtime functionality through the linked library

## Files Modified

1. `Makefile` - Added `CombinedTweak_LIBRARIES = gcuniversal`
2. `Tweak/EnekoTweak.h` - Removed direct header import
3. `Tweak/EnekoTweak.m` - Added forward declaration for GcImagePickerUtils
4. `control` - Specified libGCUniversal dependency

This should resolve the build error while maintaining all functionality.
