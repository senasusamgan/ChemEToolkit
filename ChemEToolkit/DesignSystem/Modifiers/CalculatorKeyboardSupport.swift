import SwiftUI

#if os(iOS)
import UIKit
#endif

extension View {
    @ViewBuilder
    func calculatorKeyboardSupport() -> some View {
        #if os(iOS)
        self
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItemGroup(
                    placement: .keyboard
                ) {
                    Spacer()

                    Button("Done") {
                        UIApplication.shared.sendAction(
                            #selector(
                                UIResponder
                                    .resignFirstResponder
                            ),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }
            }
        #else
        self
        #endif
    }

    @ViewBuilder
    func engineeringNumberKeyboard() -> some View {
        #if os(iOS)
        self
            .keyboardType(
                .numbersAndPunctuation
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        #else
        self
        #endif
    }
}
