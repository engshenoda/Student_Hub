plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    // ✅ أضف هنا الـ Google services plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.linkedin"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.linkedin"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM (بيخلي كل المكتبات متوافقة)
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // ✅ أضف هنا الـ SDK اللي هتستخدمه
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
}
