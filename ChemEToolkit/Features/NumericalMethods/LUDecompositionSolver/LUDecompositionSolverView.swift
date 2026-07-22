import Foundation
import SwiftUI

struct LUDecompositionSolverView: View {
    @State private var matrixText = "3,1;1,2"
    @State private var vectorText = "9,8"
    @State private var resultText: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "LU Decomposition Solver",
                    subtitle: "Solve square linear systems using partial-pivoted LU factorization."
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        CalculatorInfoCard {
                            Text("Partial pivoting is used. Separate matrix rows with semicolons and values with commas.")
                        }

                        EngineeringInputField(
                            title: "Matrix A",
                            symbol: "A",
                            unit: "",
                            placeholder: "3,1;1,2",
                            text: $matrixText
                        )

                        EngineeringInputField(
                            title: "Vector b",
                            symbol: "b",
                            unit: "",
                            placeholder: "9,8",
                            text: $vectorText
                        )

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "function",
                            action: calculate
                        )

                        if let resultText {
                            CalculationResultCard(items: [
                                .init(label: "Solution", value: resultText, unit: "")
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

    private func parseVector(_ text: String) -> [Double] {
        text.split(separator: ",").compactMap {
            Double($0.trimmingCharacters(in: .whitespaces))
        }
    }

    private func parseMatrix(_ text: String) -> [[Double]] {
        text.split(separator: ";").map { parseVector(String($0)) }
    }

    private func calculate() {
        do {
            let result = try LUDecompositionSolverEngine().solve(
                .init(
                    matrix: parseMatrix(matrixText),
                    constants: parseVector(vectorText)
                )
            )
            resultText = result.solution
                .map { String(format: "%.8g", $0) }
                .joined(separator: ", ")
            errorText = nil
        } catch {
            resultText = nil
            errorText = error.localizedDescription
        }
    }
}
