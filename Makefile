APK=controldlna-kids.apk

default: all

all:: docker-pull docker-build

install:
	make all
	adb install -r $(APK)

clean:
	rm -rf build .gradle .cache

-include Makefile.local

.PHONY: default all install clean docker-pull docker-build


##### DOCKERIZED ANDROID BUILD #####

export ANDROID_DOCKER_BUILD_CONTEXT?=default
export ANDROID_DOCKER_BUILD_CACHE?=$(PWD)/.cache
# export ANDROID_DOCKER_BUILD_CACHE?=$(HOME)/.cache/android-docker-build
# export ANDROID_KEYSTORE?=$(HOME)/.android/keystore

# Use Docker Android Build Box, see
# - https://github.com/mingchen/docker-android-build-box
# - https://hub.docker.com/r/mingc/android-build-box/
# This is the last image, that supports SDK version 21, needed for Android 4.4,
# see https://github.com/mingchen/docker-android-build-box/blob/master/COMPATIBILITY.md
ANDROID_BUILD_BOX_IMAGE=mingc/android-build-box:1.17.0
docker-pull:
	docker pull $(ANDROID_BUILD_BOX_IMAGE)

GRADLE_CACHE=$(ANDROID_DOCKER_BUILD_CACHE)/gradle
JENV_CACHE=$(ANDROID_DOCKER_BUILD_CACHE)/jenv
# USE_SDK_CACHE=y

ifneq ($(USE_SDK_CACHE),)
 SDK_CACHE?=$(ANDROID_DOCKER_BUILD_CACHE)/sdk
 SDK_CACHE_ARGS=-v $(SDK_CACHE):/opt/android-sdk
endif

ifneq ($(ANDROID_KEYSTORE),)
 ANDROID_KEYSTORE_ARGS=-v $(ANDROID_KEYSTORE):/root/.keystore:ro -e ANDROID_KEYSTORE=/root/.keystore
endif

docker-build:
	mkdir -p $(GRADLE_CACHE) $(JENV_CACHE) $(SDK_CACHE)
	rm -rf $(GRADLE_CACHE)/daemon
	time docker --context $(ANDROID_DOCKER_BUILD_CONTEXT) run --rm --network bridge \
	 -v $(PWD):/project \
	 -v $(JENV_CACHE):/root/.jenv \
	 -v $(GRADLE_CACHE):/root/.gradle -e GRADLE_USER_HOME=/root/.gradle \
	 $(SDK_CACHE_ARGS) \
	 $(ANDROID_KEYSTORE_ARGS) \
	 $(ANDROID_BUILD_BOX_IMAGE) \
	 bash -c ' \
	  cd /project && \
	  GRADLE_OPTS="-Dorg.gradle.jvmargs=\"-Xmx8192m -XX:MaxMetaspaceSize=1024m -XX:+UseContainerSupport -XX:MaxRAMPercentage=97.5\"" \
	  ./gradlew assembleRelease'
	 cp build/outputs/apk/release/project-release.apk $(APK)
