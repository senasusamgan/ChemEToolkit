import Foundation
import SwiftUI

struct BroydenNonlinearSystemView: View {
    @State private var x = "0.8"
    @State private var y = "0.6"
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Broyden Nonlinear System",
                    subtitle: "Solve a two-variable nonlinear system using a rank-one Jacobian update."
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        CalculatorInfoCard {
                            Text("Model: x² + y² = 1 and x = y. Inputs and results are dimensionless.")
                        }

                        EngineeringInputField(
                            title: "Initial x",
                            symbol: "x₀",
                            unit: "",
                            placeholder: "0.8",
                            text: $x
                        )

                        EngineeringInputField(
                            title: "Initial y",
                            symbol: "y₀",
                            unit: "",
                            placeholder: "0.6",
                            text: $y
                        )

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "function",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(label: "Solution", value: output, unit: "")
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
            let result = try BroydenNonlinearSystemEngine().solve(
                .init(
                    system: .circleAndLine,
                    initialGuess: [Double(x) ?? .nan, Double(y) ?? .nan]
                )
            )
            output = result.solution
                .map { String(format: "%.8g", $0) }
                .joined(separator: ", ")
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
