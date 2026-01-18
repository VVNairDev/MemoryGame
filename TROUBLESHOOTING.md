# Number Memory Game - Troubleshooting Guide

## 🔧 Common Issues & Solutions

### Flutter/Dart Issues

#### Issue: "Flutter command not found"
**Solution**:
```bash
# Add Flutter to PATH
# Windows: setx PATH "%PATH%;C:\path\to\flutter\bin"

# Verify installation
flutter doctor

# Or use absolute path
C:\path\to\flutter\bin\flutter run
```

#### Issue: "No packages found"
**Solution**:
```bash
flutter pub get
flutter pub upgrade
flutter clean
flutter pub get
```

#### Issue: "Dart build fails with version conflict"
**Solution**:
```yaml
# Update pubspec.yaml with compatible versions
flutter_bloc: ^8.1.3
bloc: ^8.1.2
flutter: >=3.0.0
dart: >=3.0.0
```

---

### Android Build Issues

#### Issue: "Gradle build failed"
**Solution**:
```bash
# Clean build
cd android
./gradlew clean
cd ..

# Get dependencies again
flutter pub get

# Try building again
flutter build apk --release
```

#### Issue: "Android SDK not found"
**Solution**:
```bash
# Check Android installation
flutter doctor -v

# Update SDK via Android Studio
# Tools > SDK Manager

# Or set ANDROID_HOME
setx ANDROID_HOME C:\Users\<your-user>\AppData\Local\Android\sdk
```

#### Issue: "Minimum SDK version issue"
**Solution**:
```gradle
// In android/app/build.gradle
defaultConfig {
    minSdkVersion 21
    targetSdkVersion 33
}
```

#### Issue: "Gradle version incompatible"
**Solution**:
```gradle
// In android/gradle.properties
org.gradle.jvmargs=-Xmx4096m
android.useAndroidX=true
android.enableJetifier=true
```

---

### Emulator Issues

#### Issue: "No emulator found"
**Solution**:
```bash
# List available emulators
flutter emulators

# Create new emulator (Android Studio)
# Tools > AVD Manager > Create Virtual Device

# Launch emulator
flutter emulators launch <emulator_name>

# Check running devices
flutter devices
```

#### Issue: "Emulator crashes on app start"
**Solution**:
```bash
# Stop current emulator
adb kill-server

# Clear emulator data
emulator -avd <name> -wipe-data

# Restart emulator
flutter emulators launch <name>
```

#### Issue: "App running slow on emulator"
**Solution**:
- Test on physical device instead
- Increase emulator RAM allocation
- Use `-release` flag for better performance
- Close other apps

---

### Code Issues

#### Issue: "Import not found errors"
**Solution**:
```bash
# Regenerate generated files
flutter pub get
flutter clean
flutter pub get

# Or specific file fix
flutter pub run build_runner build
```

#### Issue: "BLoC not providing states"
**Solution**:
```dart
// Verify BlocProvider is wrapping app
BlocProvider(
  create: (context) => GameBloc(gameUtils: GameUtils()),
  child: MaterialApp(...),
)

// Check BlocBuilder is listening
BlocBuilder<GameBloc, GameState>(
  builder: (context, state) {
    // UI here
  },
)
```

#### Issue: "Context.read() returns null"
**Solution**:
```dart
// Ensure BLoC is provided in context tree
// Correct
context.read<GameBloc>()

// Not correct (outside BLocProvider)
// Use key or callback instead
```

---

### Runtime Issues

#### Issue: "App crashes on sequence display"
**Solution**:
1. Check GameBloc event handling
2. Verify sequence generation logic
3. Check animation controller disposal
4. Look for null pointer exceptions

```bash
# Run with verbose logging
flutter run -v
```

#### Issue: "Input validation not working"
**Solution**:
```dart
// Check PlayerInputEvent handling
// Verify sequence comparison logic
// Ensure input list is cleared properly

// In _onPlayerInput method:
if (playerInput.last != sequence[playerInput.length - 1]) {
    // Wrong input
}
```

#### Issue: "Memory usage keeps growing"
**Solution**:
```dart
// Ensure AnimationController disposal
@override
void dispose() {
    _animationController.dispose();
    super.dispose();
}

// Check BLoC cleanup
@override
Future<void> close() {
    // Cleanup if needed
    return super.close();
}
```

---

### Build/Release Issues

#### Issue: "APK signing error"
**Solution**:
1. Create signing key:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks ^
  -keyalg RSA -keysize 4096 -validity 10950 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/path/to/keystore.jks
```

3. Build again:
```bash
flutter build apk --release
```

#### Issue: "APK file too large (>100MB)"
**Solution**:
```bash
# Use app bundle instead
flutter build appbundle --release

# Or enable shrinking
# In android/app/build.gradle
buildTypes {
    release {
        shrinkResources true
        minifyEnabled true
    }
}
```

#### Issue: "Build stuck or timing out"
**Solution**:
```bash
# Increase gradle memory
# In android/gradle.properties
org.gradle.jvmargs=-Xmx4096m

# Build with verbose output
flutter build apk --release -v

# Try clean build
flutter clean
flutter build apk --release
```

---

### Play Store Submission Issues

#### Issue: "Missing required fields in Play Store"
**Solution**: Complete all these sections:
- [ ] App title
- [ ] Description
- [ ] Screenshots (minimum 2)
- [ ] Feature graphic (1024x500px)
- [ ] Content rating
- [ ] Pricing
- [ ] Category
- [ ] Target audience
- [ ] Privacy policy URL (if applicable)

#### Issue: "App rejected for missing permissions declaration"
**Solution**:
- Our app needs NO permissions
- If store requires, add to AndroidManifest:
```xml
<!-- No permissions needed for this app -->
```

#### Issue: "Build too old or version code not incremented"
**Solution**:
```yaml
# In pubspec.yaml
version: 1.0.1+2  # Increment +2 for each release
```

---

### Performance Issues

#### Issue: "App runs slow/laggy"
**Solution**:
1. Profile with DevTools:
```bash
flutter pub global activate devtools
devtools
```

2. Check for unnecessary rebuilds:
- Use `const` constructors
- Optimize `build()` methods
- Use `RepaintBoundary` if needed

3. Optimize animations:
- Reduce animation frame rate
- Use `SingleTickerProviderStateMixin`
- Clean up listeners

#### Issue: "High battery drain"
**Solution**:
- App should have minimal battery impact
- Check if animations are running when not visible
- Dispose controllers properly
- No background processes active

#### Issue: "App takes long to start"
**Solution**:
1. Profile startup:
```bash
flutter run --profile
```

2. Optimize BLoC initialization
3. Lazy load screens if needed
4. Reduce initial asset loading

---

### Debugging Tips

#### Enable Verbose Logging
```bash
flutter run -v
```

#### Check Device Logs
```bash
adb logcat | grep flutter
```

#### Dart DevTools
```bash
flutter pub global activate devtools
devtools
```

#### Hot Reload Issues
```bash
# If hot reload fails, do hot restart
r - Hot reload
R - Hot restart
q - Quit
```

#### View Widget Tree
```dart
// In main.dart, add debugPrintBeginFrameBanner=false to hide frame info
void main() {
  debugPrintBeginFrameBanner = false;
  runApp(const MyApp());
}
```

---

### Diagnostic Commands

```bash
# Full system check
flutter doctor -v

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Get dependencies info
flutter pub outdated

# Check for issues
flutter doctor --android-licenses

# Clean everything
flutter clean
rm -rf android/.gradle
rm -rf build
```

---

### Quick Fixes Checklist

When app crashes or doesn't work:

- [ ] `flutter clean`
- [ ] `flutter pub get`
- [ ] Check imports are correct
- [ ] Verify BLoC is provided
- [ ] Check for null pointers
- [ ] Ensure no syntax errors
- [ ] Test on device, not just emulator
- [ ] Check logcat for errors
- [ ] Try hot restart (R key)
- [ ] Restart emulator/device
- [ ] Rebuild project

---

### Getting Help

1. **Check logs**: `flutter run -v`
2. **Visit Flutter docs**: https://flutter.dev/docs
3. **Search Stack Overflow**: Tag flutter, dart
4. **GitHub Issues**: flutter/flutter repository
5. **Discord Community**: Flutter Discord server

---

## 📱 Device-Specific Issues

### Android Emulator
- Slower performance - test on device for accuracy
- Memory issues - allocate more RAM in AVD settings
- Networking - may not work properly

### Physical Device
- Enable USB debugging
- Install USB driver if needed
- Verify device connection: `adb devices`
- Best for performance testing

---

## 🎯 Pre-Release Checklist

Before submitting to Play Store:

- [ ] Build runs without crashes
- [ ] All 100 levels accessible
- [ ] Sequence display works correctly
- [ ] Input validation correct
- [ ] Results display accurate
- [ ] No memory leaks
- [ ] Animations smooth
- [ ] No crashes on rapid tapping
- [ ] Works on minimum API 21
- [ ] Works on latest Android
- [ ] UI looks good on all sizes
- [ ] No lint errors
- [ ] Documentation complete

---

## 📞 Emergency Contacts

- Flutter Team: https://flutter.dev/support
- Dart Team: https://dart.dev
- Stack Overflow: Tag your questions with `flutter`
- GitHub: Report issues in flutter/flutter repo

---

**Remember**: Most issues have simple solutions. Start with `flutter clean` and `flutter pub get`!

Good luck troubleshooting! 🚀
