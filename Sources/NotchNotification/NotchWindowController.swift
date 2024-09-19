//
//  NotchWindowController.swift
//  NotchDrop
//
//  Created by 秋星桥 on 2024/7/7.
//

import Cocoa

private let notchHeight: CGFloat = 200

class NotchWindowController: NSWindowController {
    init(screen: NSScreen) {
        let window = NotchWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }
}
