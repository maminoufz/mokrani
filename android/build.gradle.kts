// Top-level build file where you can add configuration options common to all
// sub-projects/modules.

import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

buildscript {
    // Versions communes à tout le projet
    ext {
        kotlin_version = "1.9.0"          // gardé identique à votre config
        compileSdkVersion = 34
        minSdkVersion = 21
        targetSdkVersion = 34
        ndkVersion = "27.0.12077973"      // ✅ version NDK corrigée
    }

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
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
                compileSdk = 34
                defaultConfig {
                    minSdk = 21
                    targetSdk = 34
                }
                ndkVersion = "27.0.12077973"
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
