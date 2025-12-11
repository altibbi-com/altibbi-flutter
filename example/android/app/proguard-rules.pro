-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

-keepclassmembers class io.flutter.** {
    native <methods>;
}

-keep class * extends io.flutter.plugin.common.MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }
-keep class * extends io.flutter.plugin.common.BasicMessageChannel$MessageHandler { *; }

-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

-keepclassmembers,allowshrinking,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

-keep class retrofit2.** { *; }
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

-keep class com.pusher.** { *; }
-keep class com.pusher.java_websocket.** { *; }

-keep class com.pusher.client.** { *; }
-keep class com.pusher.client.channel.** { *; }
-keep class com.pusher.client.connection.** { *; }
-keep class com.pusher.client.util.** { *; }

-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class **.R
-keep class **.R$* {
    <fields>;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keep class com.google.firebase.crashlytics.** { *; }
-keep class com.google.firebase.analytics.** { *; }

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Security: Aggressive obfuscation settings
-optimizationpasses 5
-overloadaggressively
-repackageclasses ''
-allowaccessmodification

# Security: Remove all logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Security: Keep minimal attributes for crash reporting
-keepattributes SourceFile,LineNumberTable

-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.app.FlutterPlayStoreSplitApplication { *; }

-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response

-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# OpenTok API classes
-keep class com.opentok.android.** { *; }
-keep class com.opentok.impl.** { *; }

# OpenTok inner classes - Required to prevent ClassNotFoundException
-keep class com.opentok.android.SubscriberKit { *; }
-keep class com.opentok.android.SubscriberKit$SubscriberAudioStats { *; }
-keep class com.opentok.android.SubscriberKit$SubscriberVideoStats { *; }
-keep class com.opentok.android.PublisherKit { *; }
-keep class com.opentok.android.PublisherKit$PublisherAudioStats { *; }
-keep class com.opentok.android.PublisherKit$PublisherVideoStats { *; }
-keep class com.opentok.android.Session$** { *; }
-keep class com.opentok.android.Publisher$** { *; }
-keep class com.opentok.android.Subscriber$** { *; }

-keepclassmembers class com.opentok.android.** {
    native <methods>;
}

-keepclassmembers enum com.opentok.android.** {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep interface com.opentok.android.** { *; }

-keep class com.vonage.webrtc.** { *; }
-keep class com.vonage.webrtc.voiceengine.** { *; }
-keep class com.vonage.** { *; }

-keepattributes InnerClasses,EnclosingMethod
