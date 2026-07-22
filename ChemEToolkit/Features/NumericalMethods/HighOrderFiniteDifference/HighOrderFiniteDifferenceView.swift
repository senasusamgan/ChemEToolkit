import Foundation
import SwiftUI

struct HighOrderFiniteDifferenceView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "High-Order Finite Difference",
                    subtitle: "Five-point numerical first and second derivatives."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: calculate the first and second derivatives of exp(x) at x = 1.")
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
                                        label: "Derivatives",
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
            let result = try HighOrderFiniteDifferenceEngine().solve(
                .init(
                    function: .exponential,
                    point: 1
                )
            )
            output = String(
                format: "f′ %.8g, f″ %.8g",
                result.firstDerivative,
                result.secondDerivative
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
