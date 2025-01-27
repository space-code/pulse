<h1 align="center" style="margin-top: 0px;">pulse</h1>

<p align="center">
<a href="https://github.com/space-code/pulse/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/pulse?style=flat"></a> 
<a href="https://swiftpackageindex.com/space-code/pulse"><img alt="Swift Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fpulse%2Fbadge%3Ftype%3Dswift-versions"/></a> 
<a href="https://swiftpackageindex.com/space-code/pulse"><img alt="Platform Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fpulse%2Fbadge%3Ftype%3Dplatforms"/></a> 
<a href="https://github.com/space-code/pulse"><img alt="CI" src="https://github.com/space-code/pulse/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://codecov.io/gh/space-code/pulse"><img src="https://codecov.io/gh/space-code/pulse/graph/badge.svg?token=B5FNY6WLX0"/></a>

## Description
`pulse` is a Swift package designed to efficiently debounce values.

- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

## Usage

```swift
import Pulse

let debouncer = Debouncer<Int>(duration: .milliseconds(200)) { value in 
    print(value)
}

debouncer.emit(1)
debouncer.emit(2)
```

## Requirements

- iOS 16.0+ / macOS 13.0+ / watchOS 9.0+ / tvOS 16.0+ / visionOS 1.0+
- Xcode 16.0
- Swift 6.0

## Installation
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `pulse` does support its use on supported platforms.

Once you have your Swift package set up, adding `pulse` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/space-code/pulse.git", .upToNextMajor(from: "1.0.0"))
]
```

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Contributing
Bootstrapping development environment

```
make bootstrap
```

Please feel free to help out with this project! If you see something that could be made better or want a new feature, open up an issue or send a Pull Request!

## Author
Nikita Vasilev, nv3212@gmail.com

## License
pulse is available under the MIT license. See the LICENSE file for more info.