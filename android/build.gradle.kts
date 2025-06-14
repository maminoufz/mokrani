// Top-level build file where you can add configuration options common to all
// sub-projects/modules.

import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// Variables globales (définies en haut, hors de buildscript)
val kotlinVersion = "1.9.0"
val compileSdkVersion = 33
val minSdkVersion = 21
val targetSdkVersion = 33
val ndkVersion = "25.1.8937393"
val gradlePluginVersion = "8.1.0"

buildscript {
    // Versions communes à tout le projet
    ext {
        kotlin_version = kotlinVersion
        compileSdkVersion = compileSdkVersion
        minSdkVersion = minSdkVersion
        targetSdkVersion = targetSdkVersion
        ndkVersion = ndkVersion
    }

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:$gradlePluginVersion")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuration commune pour tous les sous-projets Android
subprojects {
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.application") || 
            project.plugins.hasPlugin("com.android.library")) {
            android {
                compileSdk = rootProject.extra["compileSdkVersion"] as Int
                defaultConfig {
                    minSdk = rootProject.extra["minSdkVersion"] as Int
                    targetSdk = rootProject.extra["targetSdkVersion"] as Int
                }
                ndkVersion = rootProject.extra["ndkVersion"] as String
            }
        }
    }
}

// Dir de sortie partagé (« ../../build ») :
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Chaque sous-projet écrit dans « ../../build/<module> »
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")   // s'assure que :app est évalué d'abord
}

// Tâche clean : supprime tout le répertoire build partagé
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
