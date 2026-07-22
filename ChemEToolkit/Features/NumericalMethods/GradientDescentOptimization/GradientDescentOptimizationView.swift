import Foundation
import SwiftUI

struct GradientDescentOptimizationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Gradient Descent Optimization",
                    subtitle: "Line-search optimization for supported two-variable objectives."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: minimize a dimensionless two-variable quadratic objective from the origin.")
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
                                        label: "Optimum point",
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
            let result = try GradientDescentOptimizationEngine().solve(
                .init(
                    objective: .quadratic,
                    initialPoint: [0, 0]
                )
            )
            output = result.optimum
                .map { String(format: "%.8g", $0) }
                .joined(separator: ", ")
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
