import Foundation
import SwiftUI

struct NumericalJacobianView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Numerical Jacobian",
                    subtitle: "Approximate a two-equation system Jacobian with central differences."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: evaluate the supported nonlinear system at the dimensionless point (1, 2).")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Jacobian matrix",
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
            let result = try NumericalJacobianEngine().solve(
                .init(
                    system: .nonlinear,
                    point: [1, 2]
                )
            )
            output = result.jacobian
                .map {
                    $0.map { String(format: "%.6g", $0) }
                        .joined(separator: ", ")
                }
                .joined(separator: "; ")
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
