import Foundation
import SwiftUI

struct GaussLegendreQuadratureView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Gauss–Legendre Quadrature",
                    subtitle: "High-order fixed-node integration on a finite interval."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: evaluate the five-node integral of x² from 0 to 1.")
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
                                        label: "Integral",
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
            let result = try GaussLegendreQuadratureEngine().solve(
                .init(
                    function: .square,
                    lowerBound: 0,
                    upperBound: 1
                )
            )
            output = String(
                format: "%.10g",
                result.integral
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
