import Foundation
import SwiftUI

struct RombergIntegrationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Romberg Integration",
                    subtitle: "Refine trapezoidal estimates with Richardson extrapolation."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: integrate the dimensionless function exp(−x) from 0 to 1 using a Romberg convergence table.")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Integral",
                                    value: output,
                                    unit: ""
                                )
                            ])
                        }

                        if let errorText {
                            CalculationErrorCard(message: errorText)
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
            let result = try RombergIntegrationEngine().solve(
                .init(
                    function: .exponentialDecay,
                    lowerBound: 0,
                    upperBound: 1
                )
            )
            output = String(format: "%.10g", result.integral)
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
