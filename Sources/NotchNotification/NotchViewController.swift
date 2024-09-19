//
//  NotchViewController.swift
//  NotchDrop
//
//  Created by 秋星桥 on 2024/7/7.
//

import AppKit
import Cocoa
import SwiftUI

class NotchViewController: NSHostingController<AnyView> {
    init(_ view: AnyView) {
        super.init(rootView: view)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    convenience init(_ view: some View) {
        self.init(AnyView(view))
    }
}
