//
//  NotchHeaderView.swift
//  NotchNotification
//
//  Created by 秋星桥 on 2024/9/19.
//

import SwiftUI

struct NotchHeaderView: View {
    let deviceNotchWidth: CGFloat
    let height: CGFloat
    let leadingView: AnyView
    let trailingView: AnyView

    init(deviceNotchWidth: CGFloat, height: CGFloat, leadingView: AnyView, trailingView: AnyView) {
        self.deviceNotchWidth = deviceNotchWidth
        self.height = height
        self.leadingView = leadingView
        self.trailingView = trailingView
    }

    init(deviceNotchWidth: CGFloat, height: CGFloat, leadingView: some View, trailingView: some View) {
        self.init(
            deviceNotchWidth: deviceNotchWidth,
            height: height,
            leadingView: AnyView(leadingView),
            trailingView: AnyView(trailingView)
        )
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            leadingView
                .frame(width: height, height: height)
            Spacer().frame(minWidth: deviceNotchWidth)
            trailingView
                .frame(width: height, height: height)
        }
        .frame(height: height)
    }
}
