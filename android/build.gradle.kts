allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.plugins.withType<com.android.build.gradle.BasePlugin> {
        project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
            compileSdkVersion(36)
            buildToolsVersion("34.0.0")
            defaultConfig {
                targetSdkVersion(36)
            }
        }
    }
}

subprojects {
    project.configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.core" && requested.name == "core") {
                useVersion("1.13.1")
            }
            if (requested.group == "androidx.annotation" && requested.name == "annotation") {
                useVersion("1.6.0")
            }
        }
    }
}

subprojects {
    tasks.matching { it.name.contains("verifyReleaseResources", ignoreCase = true) }.configureEach {
        enabled = false
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
