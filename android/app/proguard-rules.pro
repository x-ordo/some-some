# Flutter-specific ProGuard rules
# Keep Flutter wrapper class
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep audioplayers plugin
-keep class xyz.luan.audioplayers.** { *; }

# Keep share_plus plugin
-keep class dev.fluttercommunity.plus.share.** { *; }

# Keep path_provider plugin
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep shared_preferences plugin
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# General Android rules
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Prevent stripping of native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep Serializable implementations
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
