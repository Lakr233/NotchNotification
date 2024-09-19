//
//  App.swift
//  NotchNotification
//
//  Created by 秋星桥 on 2024/9/19.
//

import NotchNotification
import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            panel
                .frame(
                    minWidth: 400, idealWidth: 400, maxWidth: 800,
                    minHeight: 200, idealHeight: 200, maxHeight: 800,
                    alignment: .center
                )
                .background(.ultraThinMaterial)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }

    @State var message: String = "Thanks for your purchase!"
    @State var interval: TimeInterval = 3 {
        didSet { if interval < 0 { interval = 0 } }
    }

    var panel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notch Notification")
                    .bold()
                Spacer()
                Image(systemName: "questionmark.circle")
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/Lakr233/NotchNotification")!)
                    }
            }
            TextField("Message", text: $message)
                .frame(minWidth: 300)
            HStack {
                Group {
                    if interval <= 0 {
                        Text("inf")
                    } else {
                        Text("\(Int(interval))s")
                    }
                }
                .frame(width: 24, alignment: .leading)
                Button("-") { interval -= 1 }
                    .disabled(interval <= 0)
                Button("+") { interval += 1 }
                    .disabled(interval >= 16)
                Spacer()
                Button("Error") {
                    NotchNotification.present(error: message)
                }
                Button("Success") {
                    NotchNotification.present(
                        trailingView: Image(systemName: "checkmark").foregroundStyle(.green),
                        bodyView: Text(message),
                        interval: interval
                    )
                }
                Button("Message") {
                    NotchNotification.present(
                        bodyView: HStack {
                            Image(systemName: "hand.point.right")
                            Text(message).underline()
                            Image(systemName: "hand.point.left")
                        },
                        interval: interval
                    )
                }
            }
        }
        .padding(32)
    }
}
