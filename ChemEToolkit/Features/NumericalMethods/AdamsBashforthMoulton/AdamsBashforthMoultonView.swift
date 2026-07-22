import Foundation
import SwiftUI

struct AdamsBashforthMoultonView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Adams-Bashforth-Moulton ODE",
                    subtitle: "Fourth-order predictor-corrector integration for supported ODEs."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: solve y′ = y from x = 0 to 1 with y(0) = 1.")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "function",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Final value",
                                        value: output,
                                        unit: ""
                                    )
                                ]
                            )
                        }

                        if let errorText {
                            CalculationErrorCard(
                                message: errorText
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.xLarge)
        }
    }

    private func calculate() {
        do {
            let result = try AdamsBashforthMoultonEngine().solve(
                .init(
                    equation: .exponentialGrowth,
                    initialX: 0,
                    initialY: 1,
                    finalX: 1
                )
            )
            output = String(
                format: "%.10g",
                result.finalValue
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
