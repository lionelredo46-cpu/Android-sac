# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
# Firebase Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
# Play Core (deferred components) non utilisés
-dontwarn com.google.android.play.core.**
