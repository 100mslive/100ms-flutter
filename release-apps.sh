#!/bin/sh
#alias rel='sh -x release-apps.sh'

set -x

flutter pub get

cd ./example

flutter packages pub run build_runner build --delete-conflicting-outputs

cd ./android

bundle install --verbose

bundle exec fastlane release_on_firebase

cd ../ios

pod install --verbose 

bundle install --verbose

bundle exec fastlane release_on_firebase
