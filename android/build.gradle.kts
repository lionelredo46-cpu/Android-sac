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
}
// Certains plugins (ex. file_picker 8.x) compilent encore contre android-34 alors que
// leurs dépendances AndroidX exigent android-36 : on aligne tous les plugins sur 36.
subprojects {
    val alignCompileSdk = {
        extensions.findByType(com.android.build.api.dsl.LibraryExtension::class.java)?.let { ext ->
            if ((ext.compileSdk ?: 0) < 36) ext.compileSdk = 36
        }
    }
    if (state.executed) alignCompileSdk() else afterEvaluate { alignCompileSdk() }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
