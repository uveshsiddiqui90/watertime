# --- flutter_local_notifications + Gson ke liye rules ---

# Preserve generic type info (Gson ko chahiye hota hai)
-keepattributes Signature
-keepattributes *Annotation*

# Keep flutter_local_notifications plugin classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# Keep Gson (runtime serialization)
-keep class com.google.gson.** { *; }

# Keep top-level entry points (AlarmManager + background handlers)
-keepclassmembers class * {
    @androidx.annotation.Keep <methods>;
}
-keepclassmembers class * {
    @android.annotation.Keep <methods>;
}
