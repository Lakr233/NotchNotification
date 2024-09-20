//
//  NotchView.swift
//  NotchDrop
//
//  Created by 秋星桥 on 2024/7/7.
//

import SwiftUI

struct NotchView: View {
    @StateObject var vm: NotchViewModel

    var notchSize: CGSize {
        switch vm.status {
        case .closed:
            .zero
        case .opened:
            vm.notchOpenedSize
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            notch
                .zIndex(0)
                .disabled(true)
            Group {
                if vm.status == .opened {
                    VStack(spacing: 0) {
                        vm.headerView
                        vm.bodyView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: vm.notchOpenedSize.width, maxHeight: vm.notchOpenedSize.height)
                    .zIndex(1)
                }
            }
            .transition(
                .scale.combined(
                    with: .opacity
                ).combined(
                    with: .offset(y: -vm.notchOpenedSize.height / 2)
                ).animation(vm.animation)
            )
        }
        .animation(vm.animation, value: vm.status)
        .preferredColorScheme(.dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    var notch: some View {
        Rectangle()
            .foregroundStyle(.black)
            .clipShape(
                NotchRectangle(
                    topCornerRadius: vm.cornerRadius * 0.6,
                    bottomCornerRadius: vm.cornerRadius
                )
            )
            .frame(
                width: notchSize.width + vm.cornerRadius * 2,
                height: notchSize.height
            )
            .shadow(
                color: .black.opacity(([.opened].contains(vm.status)) ? 1 : 0),
                radius: 16
            )
    }

    struct NotchRectangle: Shape {
        var topCornerRadius: CGFloat
        var bottomCornerRadius: CGFloat

        func path(in rect: CGRect) -> Path {
            var path = Path()

            // Define the points for the rounded rectangle
            let tl = CGPoint(x: rect.minX, y: rect.minY)
            let tr = CGPoint(x: rect.maxX, y: rect.minY)
            let bl = CGPoint(x: rect.minX, y: rect.maxY)
            let br = CGPoint(x: rect.maxX, y: rect.maxY)

            let bottomFactor: CGFloat = 0.36
            let topFactor: CGFloat = 0.32

            let brCtrlPoint1 = CGPoint(x: br.x - topCornerRadius, y: br.y - bottomCornerRadius * bottomFactor)
            let brCtrlPoint2 = CGPoint(x: br.x - topCornerRadius - bottomCornerRadius * bottomFactor, y: br.y)

            let blCtrlPoint1 = CGPoint(x: bl.x + topCornerRadius + bottomCornerRadius * bottomFactor, y: bl.y)
            let blCtrlPoint2 = CGPoint(x: bl.x + topCornerRadius, y: bl.y - bottomCornerRadius * bottomFactor)

            let trCtrlPoint1 = CGPoint(x: tr.x - topCornerRadius + topCornerRadius * topFactor, y: tr.y)
            let trCtrlPoint2 = CGPoint(x: tr.x - topCornerRadius, y: tr.y + topCornerRadius * topFactor)

            let tlCtrlPoint1 = CGPoint(x: tl.x + topCornerRadius, y: tr.y + topCornerRadius * topFactor)
            let tlCtrlPoint2 = CGPoint(x: tl.x + topCornerRadius - topCornerRadius * topFactor, y: tr.y)

            path.move(to: tl)
            path.addLine(to: tr) // Top edge

            path.addCurve(
                to: CGPoint(x: tr.x - topCornerRadius, y: tr.y + topCornerRadius),
                control1: trCtrlPoint1,
                control2: trCtrlPoint2
            )

            path.addLine(to: CGPoint(x: br.x - topCornerRadius, y: br.y - bottomCornerRadius))

            path.addCurve(
                to: CGPoint(x: br.x - topCornerRadius - bottomCornerRadius, y: br.y),
                control1: brCtrlPoint1,
                control2: brCtrlPoint2
            )

            path.addLine(to: CGPoint(x: bl.x + topCornerRadius + bottomCornerRadius, y: bl.y))

            path.addCurve(
                to: CGPoint(x: bl.x + topCornerRadius, y: bl.y - bottomCornerRadius),
                control1: blCtrlPoint1,
                control2: blCtrlPoint2
            )

            path.addLine(to: CGPoint(x: tl.x + topCornerRadius, y: tl.y + topCornerRadius))

            path.addCurve(to: tl, control1: tlCtrlPoint1, control2: tlCtrlPoint2)

            path.closeSubpath()

            return path
        }
    }
}
