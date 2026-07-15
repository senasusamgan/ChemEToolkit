import SwiftUI

struct MassTransferActionButtons: View {
    let loadExample: () -> Void
    let clear: () -> Void

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }

            VStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }
        }
    }

    private var loadExampleButton: some View {
        Button(action: loadExample) {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button(action: clear) {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

enum MassTransferViewSupport {
    nonisolated static func errorMessage(
        for error: Error
    ) -> String {
        if let calculationError =
            error as? CalculationError {

            let description =
                calculationError.errorDescription
                ?? "The entered values could not be processed."

            if let suggestion =
                calculationError.recoverySuggestion {

                return
                    "\(description) \(suggestion)"
            }

            return description
        }

        return error.localizedDescription
    }
}
