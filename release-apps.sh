#!/bin/sh
#alias rel='sh -x release-apps.sh'

# set -e
# set -x

echo "🌳🍀 git branch: $(git rev-parse --abbrev-ref HEAD)"

git pull --verbose

flutter pub get

cd ./example

flutter packages pub run build_runner build --delete-conflicting-outputs

cd ./android

bundle install --verbose

bundle exec fastlane release_on_firebase

cd ../ios

pod install --verbose 

bundle install --verbose

bundle exec fastlane distribute_app

cd .. ; cd ..

while read line; do
    if [[ $line =~ ^versionCode.[0-9]+$ ]]; then 
        buildNumber=$(echo $line | grep -o -E '[0-9]+')
    elif [[ $line =~ ^versionName.*$ ]]; then
        versionCode=$(echo $line | grep -o -E '[0-9].[0-9].[0-9]+')
    fi
done <example/android/app/build.gradle

# set debug to true in example/lib/main.dart

cd example
while read line do
    if [[ $line =~ ^.DEBUG.$ ]]; then
        echo "const DEBUG = true" >> $line
    fi
done <example/lib/main.dart 

git add example/android/app/build.gradle
git add example/ios/Podfile.lock
git add example/ios/Runner/Info.plist
git add example/ios/Runner.xcodeproj/project.pbxproj

git commit -m "released sample app version $versionCode ($buildNumber) 🍀"
