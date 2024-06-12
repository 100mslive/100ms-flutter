# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# https://firebase.google.com/docs/crashlytics/get-deobfuscated-reports?platform=android
-keepattributes SourceFile,LineNumberTable        # Keep file names and line numbers.
#-keep public class * extends java.lang.Exception  # Optional: Keep custom exceptions.

# https://developer.android.com/guide/navigation/navigation-pass-data#proguard_considerations


# Video libs
-keep class org.webrtc.** { *; }
-keep class live.hms.video.** { *; }

-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE
-dontwarn com.google.mediapipe.proto.CalculatorOptionsProto$CalculatorOptions$Builder
-dontwarn com.google.mediapipe.proto.CalculatorOptionsProto$CalculatorOptions
-dontwarn com.google.mediapipe.proto.CalculatorProfileProto$CalculatorProfile
-dontwarn com.google.mediapipe.proto.GraphTemplateProto$CalculatorGraphTemplate
-dontwarn com.google.mediapipe.proto.MediaPipeOptionsProto$MediaPipeOptions$Builder
-dontwarn com.google.mediapipe.proto.MediaPipeOptionsProto$MediaPipeOptions
-dontwarn com.google.mediapipe.proto.StreamHandlerProto$InputStreamHandlerConfig$Builder
-dontwarn com.google.mediapipe.proto.StreamHandlerProto$InputStreamHandlerConfig
-dontwarn com.google.mediapipe.proto.StreamHandlerProto$OutputStreamHandlerConfig$Builder
-dontwarn com.google.mediapipe.proto.StreamHandlerProto$OutputStreamHandlerConfig
-dontwarn mediapipe.PacketFactory$PacketFactoryConfig$Builder
-dontwarn mediapipe.PacketFactory$PacketFactoryConfig
-dontwarn mediapipe.PacketFactory$PacketFactoryConfigOrBuilder
-dontwarn mediapipe.PacketGenerator$PacketGeneratorConfig$Builder
-dontwarn mediapipe.PacketGenerator$PacketGeneratorConfig
-dontwarn mediapipe.PacketGenerator$PacketGeneratorConfigOrBuilder
-dontwarn mediapipe.StatusHandler$StatusHandlerConfig$Builder
-dontwarn mediapipe.StatusHandler$StatusHandlerConfig
-dontwarn mediapipe.StatusHandler$StatusHandlerConfigOrBuilder