allprojects {
    repositories {
        google()
        mavenCentral()
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

    // Force all plugin subprojects to compileSdk 36.
    // finalizeDsl runs after the plugin's build script sets compileSdk
    // but before AGP locks the value.
    plugins.withId("com.android.library") {
        val androidComponents = extensions.getByType(
            com.android.build.api.variant.LibraryAndroidComponentsExtension::class.java
        )
        androidComponents.finalizeDsl { extension ->
            if ((extension.compileSdk ?: 0) < 36) {
                extension.compileSdk = 36
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
