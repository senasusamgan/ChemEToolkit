import Foundation
import SwiftUI

struct LaplaceEquationFiniteDifferenceView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Laplace Equation Finite Difference",
                    subtitle: "Steady two-dimensional field solution on a rectangular grid."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: solve an 11 × 11 source-free field with one boundary fixed at 100.")
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
                                        label: "Center value",
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
            let result = try LaplaceEquationFiniteDifferenceEngine().solve(
                .init(
                    rows: 11,
                    columns: 11,
                    topBoundary: 100,
                    bottomBoundary: 0,
                    leftBoundary: 0,
                    rightBoundary: 0
                )
            )
            output = String(
                format: "%.6g",
                result.field[5][5]
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
