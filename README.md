# myrunes.com Mobile App

These are the sources of the mobile app of [myrunes.com](https://myrunes.com). This project is currently in a very early state of development and not production ready at all.

The app is created with the [flutter](https://flutter.dev) framework.

## Demo

![](.github/demo.gif)
> *State: commit 8d055fc*

## Setup

> Following steps only represent the installation on Android.

If you want to test the app yourself or if you want to tinker around with the soucres, you need to set up flutter:
https://flutter.dev/docs/get-started/install

After that, clone the repository:
```
$ git clone https://github.com/myrunes/mobile-app.git myrunes/app
```

Following, compile the APK:
```
$ cd myrunes/app
$ flutter build apk --release
```

The final APK is located in the `build/app/outputs/flutter-apk` directory. Either, you pull the APK directly onto your device and install it manually or run `flutter install` to install it by flutter.

---

© 2020 Ringo Hoffmann (zekro Development)  
Covered by the MIT Licence.
