import Cocoa
import Combine
import Foundation
import SwiftUI

class NotchViewModel: NSObject, ObservableObject {
    let notchOpenedSize: CGSize

    let headerView: AnyView
    let bodyView: AnyView

    let cornerRadius: CGFloat

    var referencedWindow: NotchWindowController? = nil

    init(screen: NSScreen, headerLeadingView: AnyView, headerTrailingView: AnyView, bodyView: AnyView) {
        let headerView = NotchHeaderView(
            spacing: screen.headerSpacingWidth + 64,
            height: screen.headerHeight,
            leadingView: headerLeadingView,
            trailingView: headerTrailingView
        )

        self.headerView = AnyView(headerView.padding(.horizontal, 8))
        self.bodyView = AnyView(
            bodyView.padding(.bottom, 16).padding(.horizontal, 16))

        let headerFittingSize = NSHostingView(rootView: self.headerView)
            .fittingSize
        let bodyFittingSize = NSHostingView(rootView: self.bodyView).fittingSize

        notchOpenedSize = .init(
            width: max(headerFittingSize.width, bodyFittingSize.width),
            height: max(headerFittingSize.height + bodyFittingSize.height, 0)
        )

        cornerRadius = min(notchOpenedSize.height / 3, 16)

        super.init()
    }

    convenience init(
        screen: NSScreen, headerLeadingView: some View, headerTrailingView: some View, bodyView: some View
    ) {
        self.init(
            screen: screen,
            headerLeadingView: AnyView(headerLeadingView),
            headerTrailingView: AnyView(headerTrailingView),
            bodyView: AnyView(bodyView)
        )
    }

    let animation: Animation = .interactiveSpring(
        duration: 0.5,
        extraBounce: 0.25,
        blendDuration: 0.125
    )

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
