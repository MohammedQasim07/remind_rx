# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve generic signatures and annotations for GSON/Reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses


# Isar Database Keep Rules
-keep class io.isar.** { *; }
-keep enum io.isar.** { *; }
-keep interface io.isar.** { *; }

# Keep your data models and generated Isar code
-keep class com.healthcare.remind_rx.features.user.data.models.** { *; }
-keep class com.healthcare.remind_rx.features.medicine.data.models.** { *; }
-keep class com.healthcare.remind_rx.features.schedule.data.models.** { *; }
-keep class com.healthcare.remind_rx.features.dose_history.data.models.** { *; }

# Also keep the generated Isar schemas/adapters (they are usually in the same package)
-keep class **ModelSchema { *; }
-keep class **Adapter { *; }

# Dio and other libraries that use reflection or need to keep names
-keep class com.healthcare.remind_rx.core.network.** { *; }
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter Local Notifications (uses Gson)
-keep class com.dexterous.** { *; }


# Flutter Secure Storage
-keep class com.it_verify.flutter_secure_storage.** { *; }

# Ignore missing references to optional libraries
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

