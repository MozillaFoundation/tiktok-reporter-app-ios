
# TikTok Reporter

This is the Mozilla repository for the TikTok Reporter iOS application.


## Run Locally

Clone the project

```bash
  git clone git@github.com:MozillaFoundation/tiktok-reporter-app-ios.git
```

Go to the project directory

```bash
  cd my-project
```

If this is your first time running the project:

```bash
  Go into GleanManager.swift and comment out the content of each function. (just the content, not the signature), then build the project.
```

This is done because of how Glean works. It has a build time script that generates the Swift code needed for using the framework, but, because this is your first time running it means you don't have anything generated, and so, the build will fail before Glean has a chance to generate it's files. (i.e. GleanManager uses Glean files before they are generated).

This step needs to be done only for the first run. After that, you will have your files in `Generated/Metrics.swift`.

