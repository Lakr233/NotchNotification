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
            .mask(notchBackgroundMaskGroup)
            .frame(
                width: notchSize.width + vm.cornerRadius * 2,
                height: notchSize.height
            )
            .shadow(
                color: .black.opacity(([.opened].contains(vm.status)) ? 1 : 0),
                radius: 16
            )
    }

    var notchBackgroundMaskGroup: some View {
        Rectangle()
            .foregroundStyle(.black)
            .frame(
                width: notchSize.width,
                height: notchSize.height
            )
            .clipShape(.rect(
                bottomLeadingRadius: vm.cornerRadius,
                bottomTrailingRadius: vm.cornerRadius
            ))
            .overlay {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .frame(width: vm.cornerRadius, height: vm.cornerRadius)
                        .foregroundStyle(.black)
                    Rectangle()
                        .clipShape(.rect(topTrailingRadius: vm.cornerRadius))
                        .foregroundStyle(.white)
                        .frame(
                            width: vm.cornerRadius,
                            height: vm.cornerRadius
                        )
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -vm.cornerRadius + 0.5, y: -0.5)
            }
            .overlay {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .frame(width: vm.cornerRadius, height: vm.cornerRadius)
                        .foregroundStyle(.black)
                    Rectangle()
                        .clipShape(.rect(topLeadingRadius: vm.cornerRadius))
                        .foregroundStyle(.white)
                        .frame(
                            width: vm.cornerRadius,
                            height: vm.cornerRadius
                        )
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: vm.cornerRadius - 0.5, y: -0.5)
            }
    }
}
