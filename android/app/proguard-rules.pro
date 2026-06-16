# ProGuard rules for VisionSafe
# Ensure MediaPipe and CameraX classes are not obfuscated/stripped out by R8 in Release Build.

-keep class com.google.mediapipe.** { *; }
-keep class androidx.camera.** { *; }
-keep class com.hn.visionsafe.** { *; }

-dontwarn com.google.mediapipe.**
-dontwarn androidx.camera.**

# Fix for R8 Missing Classes (Java Desktop Annotations used by MediaPipe/AutoValue)
-dontwarn javax.annotation.processing.**
-dontwarn javax.lang.model.**
-dontwarn com.google.auto.value.**
-dontwarn autovalue.shaded.**
