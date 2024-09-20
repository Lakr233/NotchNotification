# NotchNotification

Display notifications through your device's notch area.

The code has been refactored from [NotchDrop](https://github.com/Lakr233/NotchDrop) and modified to better suit the current use case.

## Preview

![Preview GIF](./Example/demo.gif)

## Platforms

NotchNotification supports all AppKit platforms and works even on devices without a notch.

```swift
platforms: [.macOS(.v12)],
```

## Usage

To add this package to your project:

```swift
dependencies: [
    .package(url: "https://github.com/Lakr233/NotchNotification.git", from: "1.1.0"),
]
```

To display a notification, use the following code:

```swift
NotchNotification.present(message: message)
```

For presenting an error notification with a custom interval:

```swift
NotchNotification.present(error: error, interval: 3)
```

To fully customize the notification view:

```swift
NotchNotification.present(
    bodyView: HStack {
        Image(systemName: "hand.point.right")
        Text(message).underline()
        Image(systemName: "hand.point.left")
    },
    interval: interval
)
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

© 2024 Lakr Aream. All Rights Reserved.
