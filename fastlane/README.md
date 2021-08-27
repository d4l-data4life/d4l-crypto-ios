fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Run unit tests and upload code coverage
### ios prepare_release
```
fastlane ios prepare_release
```
Prepare release

#### Options

 * **`version`** (required): The new version of the framework

 * **`api_token`** (required): Github API token
### ios update_badge
```
fastlane ios update_badge
```
Update readme badge
### ios build_crypto
```
fastlane ios build_crypto
```
Build xcframework for distribution
### ios build_xcframework
```
fastlane ios build_xcframework
```
Build any project xcframework
### ios build_crypto_xcframework
```
fastlane ios build_crypto_xcframework
```
Build xcframework for distribution
### ios create_github_draft
```
fastlane ios create_github_draft
```
Upload to a github release
### ios update_plist_versions
```
fastlane ios update_plist_versions
```
Update AppStore and Data4LifeSDK version number in project plists
### ios lint
```
fastlane ios lint
```
Lint sources using swiftlint and check the license headers
### ios lint_headers
```
fastlane ios lint_headers
```
Check license headers
### ios update_readme_versions
```
fastlane ios update_readme_versions
```
Update version numbers in README.adoc

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
