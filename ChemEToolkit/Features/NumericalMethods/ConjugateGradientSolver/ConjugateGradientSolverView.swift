import Foundation
import SwiftUI

struct ConjugateGradientSolverView: View {
    @State private var matrixText = "4,1;1,3"
    @State private var vectorText = "1,2"
    @State private var resultText: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Conjugate Gradient Solver",
                    subtitle: "Iteratively solve symmetric positive-definite linear systems."
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        CalculatorInfoCard {
                            Text("The matrix must be symmetric positive definite. The initial guess is zero.")
                        }

                        EngineeringInputField(
                            title: "Matrix A",
                            symbol: "A",
                            unit: "",
                            placeholder: "4,1;1,3",
                            text: $matrixText
                        )

                        EngineeringInputField(
                            title: "Vector b",
                            symbol: "b",
                            unit: "",
                            placeholder: "1,2",
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
            let constants = parseVector(vectorText)
            let result = try ConjugateGradientSolverEngine().solve(
                .init(
                    matrix: parseMatrix(matrixText),
                    constants: constants,
                    initialGuess: Array(repeating: 0, count: constants.count)
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
