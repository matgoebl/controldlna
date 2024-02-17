## Description

ControlDLNA is a DLNA and UPnP control point app for your phone.

It lets you play audio and video from any DLNA or UPnP compatible  server in the local network to a DLNA or UPnP renderer.

Additionally, other apps can utilize the MediaRouter API to play their media on a remote device.

Android 2.2 (Gingerbread) or higher is required.

Permissions: READ_PHONE_STATE is required to pause playback on phone call. All other permissions are required for UPnP functionality. ControlDLNA does not access the internet.

## About this fork

https://github.com/matgoebl/controldlna is forked from https://github.com/aabaker/controldlna and https://github.com/Nutomic/controldlna, which is in archived state.  
Changes on this fork (c) 2016-2024 Matthias Goebl (e-mail: matthias dot goebl at goebl dot net)

This version contains the following changes (some contributed back to https://github.com/aabaker/controldlna):
- [Fix crash when starting playback from a playlist with only a single item](https://github.com/aabaker/controldlna/pull/19)
- [Workaround crash when opening the preferences](https://github.com/aabaker/controldlna/pull/18)
- [Fix time display for songs longer than 99:99](https://github.com/aabaker/controldlna/pull/15)
- [Fix crash when starting playback from a playlist with only a single item](https://github.com/aabaker/controldlna/pull/14)
- [Added option to play directly on local device](https://github.com/aabaker/controldlna/pull/16)
- Improve back button behaviour not to exit app
- Add option for intelligent track selection: add all files from the current folder only if the choosen track has a number (as in an album)

I made this fork as an DLNA audio player for my kids. I have some [Motorola Defy](https://en.wikipedia.org/wiki/Motorola_Defy) phones,
running Android 4.4 KitKat (SDK version 19) from CyanogenMod.  
Therefore I prefer to build with the rather old SDK version 21.

There is an additional branch *Kids Radio*.  
This app variant has a simplified interface and restricted configuration:
- app name changed to "Kids Radio"
- stop playback and dnla discovery on app exit
- back button does not leave app
- shuffle and repeat buttons removed
- no subtitles in server list
- no context menu for adding folders or single files (intelligent track selection as a replacement)
- no options menu (therefore hardcoded preferences)
- keep screen on while playing
- hardcoded preferences:
  - playback only on local device
  - filter server list for servers with name `.*Kids.Radio.*`
  - intelligent track selection enabled

## Dockerized Building

Run `make` to perform a docker based build using [Android Build Box](https://github.com/mingchen/docker-android-build-box). 
If you also use a [rootless docker](https://docs.docker.com/engine/security/rootless/), set the environment
`export ANDROID_DOCKER_BUILD_CONTEXT=rootless`.

In order to automatically sign your APKs, create an android keystore as `$HOME/.android-keystore/keystore`.
Then create a file `$HOME/.android-keystore/keyprops` containing

    storePassword=xxx
    keyAlias=xxx
    keyPassword=xxx

and set `export ANDROID_KEYSTORE=$HOME/.android-keystore`.

## Classic Building

To build run `./gradlew assembleDebug` or `./gradlew assembleRelease`.
Windows users can use `gradlew.bat` rather than `./gradlew`.

## Icons

All icons are taken from AOSP.

## License

[BSD 3-Clause License](LICENSE.md)
