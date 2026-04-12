# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

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

# Flutter Secure Storage
-keep class com.it_verify.flutter_secure_storage.** { *; }

# Ignore missing references to optional libraries
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

