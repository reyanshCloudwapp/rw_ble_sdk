pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        flatDir {
            dirs("libs")
        }
    }
}

//plugins {
//    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
//    id("com.android.application") version "8.11.1" apply false
//    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
//}

rootProject.name = "example"

// Include the app module
include(":app")
//project(":app").projectDir = file("app")

// Include the library module
include(":rw_ble")
project(":rw_ble").projectDir = file("../rw_ble")


