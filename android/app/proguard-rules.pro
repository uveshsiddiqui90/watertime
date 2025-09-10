# flutter_local_notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# WorkManager (agar use kar rahe ho)
-keep class androidx.work.** { *; }
-keepclassmembers class * extends androidx.work.ListenableWorker {
    <init>(...);
}

# android_alarm_manager_plus
-keep class io.flutter.plugins.androidalarmmanager.** { *; }
