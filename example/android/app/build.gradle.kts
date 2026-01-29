plugins {
    id("com.android.application") version "8.11.1"
    id("org.jetbrains.kotlin.android") version "1.9.10"
    id("dev.flutter.flutter-gradle-plugin")
}
/*
buildscript {
    val kotlin_version = "1.9.10"
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.11.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

apply(plugin = "com.android.application")
apply(plugin = "org.jetbrains.kotlin.android")
apply(plugin = "dev.flutter.flutter-gradle-plugin")


 */

// Apply plugins
android {
    namespace = "com.cwt.rw_ble_example"
    compileSdk = 36
    ndkVersion = "25.2.9519653"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }


    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.cwt.rw_ble_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}



flutter {
    source = "../.."
}

dependencies {
    implementation(project(":rw_ble"))
}

