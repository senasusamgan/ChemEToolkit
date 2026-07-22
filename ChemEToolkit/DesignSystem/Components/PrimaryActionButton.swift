import SwiftUI

struct PrimaryActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(
                title,
                systemImage: systemImage
            )
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .keyboardShortcut(
            .return,
            modifiers: .command
        )
        .accessibilityLabel(title)
        .accessibilityHint(
            "Keyboard shortcut: Command-Return"
        )
    }
}
