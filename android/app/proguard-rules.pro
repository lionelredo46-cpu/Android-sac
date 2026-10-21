# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
# Plugins appelés par JNI (jnigen : shared_preferences, path_provider). Les méthodes
# « suspend » ont kotlin.coroutines.Continuation dans leur signature : si R8 renomme ce
# type, JNI ne retrouve plus la méthode et l'application plante au démarrage (écran noir).
-keep class kotlin.coroutines.** { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.Unit { *; }
-keep class com.github.dart_lang.jni.** { *; }
-keep class com.github.dart_lang.jni_flutter.** { *; }
# Firebase Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
# Play Core (deferred components) non utilisés
-dontwarn com.google.android.play.core.**
