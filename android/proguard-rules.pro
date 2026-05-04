# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Keep OpenTok classes to prevent crashes
-keep class com.opentok.android.** { *; }
-keep class com.opentok.android.Session { *; }
-keep class com.opentok.android.Publisher { *; }
-keep class com.opentok.android.Subscriber { *; }
-keep class com.opentok.android.SubscriberKit { *; }
-keep class com.opentok.android.SubscriberKit$SubscriberAudioStats { *; }
-keep class com.opentok.android.SubscriberKit$SubscriberVideoStats { *; }
-keep class com.opentok.android.PublisherKit { *; }
-keep class com.opentok.android.PublisherKit$PublisherAudioStats { *; }
-keep class com.opentok.android.PublisherKit$PublisherVideoStats { *; }
-keep class com.opentok.android.Connection { *; }
-keep class com.opentok.android.Stream { *; }
-keep class com.opentok.android.Session$** { *; }
-keep class com.opentok.android.Publisher$** { *; }
-keep class com.opentok.android.Subscriber$** { *; }

# Keep OpenTok native methods
-keepclassmembers class com.opentok.android.** {
    native <methods>;
}

# Keep OpenTok enums
-keepclassmembers enum com.opentok.android.** {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep OpenTok interfaces
-keep interface com.opentok.android.** { *; }

# Keep OpenTok exceptions
-keep class com.opentok.android.**Exception { *; }

# Keep Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Flutter native methods
-keepclassmembers class io.flutter.** {
    native <methods>;
}

# Keep Flutter plugin classes
-keep class * extends io.flutter.plugin.common.MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }
-keep class * extends io.flutter.plugin.common.BasicMessageChannel$MessageHandler { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep annotation classes
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}



