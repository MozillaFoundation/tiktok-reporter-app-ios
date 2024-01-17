# TikTok Reporter

This is the Mozilla repository for the TikTok Reporter iOS application.


## Run Locally

1. Clone the project

```bash
  git clone git@github.com:MozillaFoundation/tiktok-reporter-app-ios.git
```

2. Go to the project directory

```bash
  cd my-project
```

3. If this is your first time running the project:

```
  Go into GleanManager.swift and comment out the content of each function. (just the content, not the signature), then build the project.
```

This is done because of how Glean works. It has a build time script that generates the Swift code needed for using the framework, but, because this is your first time running it means you don't have anything generated, and so, the build will fail before Glean has a chance to generate it's files. (i.e. GleanManager uses Glean files before they are generated).

4. After a succesfull build, check that you have the `Generated/Metrics.swift` file both in TikTok Reporter and in TikTok ReporterShare folders.

5. If not:

```
  Right click on TikTok Reporter and then select Add files to (...). Select the Generated folder and add it to the project
```

6. Do the same for TikTok ReporterShare.

```
  Un-comment all of the methods in GleanManager.swift (check step 3.)
```

7. You should now be able to run the project and any changes done in Glean whould be reflected automatially.

This step needs to be done only for the first run. After that, you will have your files in `Generated/Metrics.swift`.


### Edge Cases

1. ```Error: Build input file cannot be found ...```
- This error can show up in case the files in `{Project}/Generated` are present in the project navigator, but are not present in the file system (they show up with a red text).
- To solve the issue:
  - Manually remove (Cmd + backspace) the files from both the `TikTok Reporter` and `TikTok ReporterShare` folders and try building the project again.
2. ```Error: glean_parser fail```
- This error can show up if the Glean-generated files present in the hidden `.venv/` folder are outdated.
- To solve this issue:
  - Manually delete the `.venv` folder and build the project again.


