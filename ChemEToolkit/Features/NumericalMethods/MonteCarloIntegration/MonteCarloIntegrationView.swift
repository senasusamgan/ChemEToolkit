import Foundation
import SwiftUI

struct MonteCarloIntegrationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Monte Carlo Integration",
                    subtitle: "Estimate an integral using reproducible seeded random sampling."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: estimate the dimensionless integral of x² from 0 to 1 with 100,000 samples.")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Integral estimate ± standard error",
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
            let result = try MonteCarloIntegrationEngine().solve(
                .init(
                    function: .square,
                    lowerBound: 0,
                    upperBound: 1
                )
            )
            output = String(
                format: "%.8g ± %.2g",
                result.integral,
                result.standardError
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
