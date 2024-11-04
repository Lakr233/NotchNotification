import Cocoa
import Combine
import Foundation
import SwiftUI

class NotchViewModel: NSObject, ObservableObject {
    let notchOpenedSize: CGSize
    let headerView: AnyView
    let bodyView: AnyView
    let cornerRadius: CGFloat
    let animated: Bool

    var referencedWindow: NotchWindowController? = nil

    init(screen: NSScreen, headerLeadingView: AnyView, headerTrailingView: AnyView, bodyView: AnyView, animated: Bool) {
        let headerView = NotchHeaderView(
            deviceNotchWidth: screen.notchSize.width,
            height: screen.headerHeight,
            leadingView: headerLeadingView,
            trailingView: headerTrailingView
        )

        self.headerView = AnyView(headerView)

        let originalBodyFittingSize = NSHostingView(rootView: bodyView).fittingSize
        if originalBodyFittingSize.height < 1, originalBodyFittingSize.width < 1 {
            self.bodyView = AnyView(bodyView) // should be empty, omit bodyView
        } else {
            self.bodyView = AnyView(bodyView.padding(.bottom, 16).padding(.horizontal, 16))
        }

        let headerFittingSize = NSHostingView(rootView: self.headerView).fittingSize
        let bodyFittingSize = NSHostingView(rootView: self.bodyView).fittingSize

        notchOpenedSize = .init(
            width: ceil(max(headerFittingSize.width, bodyFittingSize.width)),
            height: ceil(max(headerFittingSize.height + bodyFittingSize.height, 0))
        )

        cornerRadius = min(ceil(notchOpenedSize.height / 3), 16)
        self.animated = animated

        super.init()
    }

    convenience init(
        screen: NSScreen,
        headerLeadingView: some View,
        headerTrailingView: some View,
        bodyView: some View,
        animated: Bool
    ) {
        self.init(
            screen: screen,
            headerLeadingView: AnyView(headerLeadingView),
            headerTrailingView: AnyView(headerTrailingView),
            bodyView: AnyView(bodyView),
            animated: animated
        )
    }

    var animation: Animation? {
        if animated {
            .interactiveSpring(
                duration: 0.5,
                extraBounce: 0.25,
                blendDuration: 0.125
            )
        } else {
            nil
        }
    }

    enum Status: String, Codable, Hashable, Equatable {
        case closed
        case opened
    }

    @Published private(set) var status: Status = .closed

    func open() {
        status = .opened
    }

    func close() { status = .closed }

    func scheduleClose(after interval: TimeInterval) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(destroy), with: nil, afterDelay: interval)
    }

    @objc func destroy() {
        close()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.destroyMemory()
        }
    }

    func destroyMemory() {
        referencedWindow?.window?.contentViewController = nil
        referencedWindow?.window?.close()
        referencedWindow?.close()
        referencedWindow = nil
    }
}
