//
//  NotificationContext.swift
//  NotchNotification
//
//  Created by 秋星桥 on 2024/9/19.
//

import Cocoa
import Foundation
import SwiftUI

struct NotificationContext {
    let screen: NSScreen
    let headerLeadingView: AnyView
    let headerTrailingView: AnyView
    let bodyView: AnyView

    init(screen: NSScreen, headerLeadingView: AnyView, headerTrailingView: AnyView, bodyView: AnyView) {
        self.screen = screen
        self.headerLeadingView = headerLeadingView
        self.headerTrailingView = headerTrailingView
        self.bodyView = bodyView
    }

    init?(headerLeadingView: AnyView, headerTrailingView: AnyView, bodyView: AnyView) {
        let mouseLocation = NSEvent.mouseLocation
        let screens = NSScreen.screens
        let screenWithMouse =
            (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

        guard let screen = screenWithMouse ?? NSScreen.buildin else {
            return nil
        }
        self.init(
            screen: screen,
            headerLeadingView: headerLeadingView,
            headerTrailingView: headerTrailingView,
            bodyView: bodyView
        )
    }

    init?(
        headerLeadingView: some View, headerTrailingView: some View, bodyView: some View
    ) {
        self.init(
            headerLeadingView: AnyView(headerLeadingView),
            headerTrailingView: AnyView(headerTrailingView),
            bodyView: AnyView(bodyView)
        )
    }

    func open(forInterval interval: TimeInterval = 0) {
        let window = NotchWindowController(screen: screen)
        window.window?.setFrameOrigin(.zero)

        let viewModel = NotchViewModel(
            screen: screen,
            headerLeadingView: headerLeadingView,
            headerTrailingView: headerTrailingView,
            bodyView: bodyView
        )
        let view = NotchView(vm: viewModel)
        let viewController = NotchViewController(view)
        window.contentViewController = viewController

        let shadowInset: CGFloat = 50

        let topRect = CGRect(
            x: screen.frame.origin.x,
            y: screen.frame.origin.y + screen.frame.height - viewModel.notchOpenedSize.height - shadowInset,
            width: screen.frame.width,
            height: viewModel.notchOpenedSize.height + shadowInset // for shadow
        )
        window.window?.setFrameOrigin(topRect.origin)
        window.window?.setContentSize(topRect.size)

//        window.showWindow(nil)
        window.window?.orderFront(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.open()
        }

        viewModel.referencedWindow = window

        guard interval > 0 else { return }
        viewModel.scheduleClose(after: interval)
    }
}
