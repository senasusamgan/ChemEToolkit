import Foundation
import SwiftUI

struct QRDecompositionSolverView: View {
    @State private var matrixText = "1,0;1,1;1,2"
    @State private var vectorText = "1,3,5"
    @State private var resultText: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "QR Decomposition Solver",
                    subtitle: "Solve full-rank square or overdetermined least-squares systems."
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        CalculatorInfoCard {
                            Text("The matrix needs at least as many rows as columns and full column rank.")
                        }

                        EngineeringInputField(
                            title: "Matrix A",
                            symbol: "A",
                            unit: "",
                            placeholder: "1,0;1,1;1,2",
                            text: $matrixText
                        )

                        EngineeringInputField(
                            title: "Vector b",
                            symbol: "b",
                            unit: "",
                            placeholder: "1,3,5",
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
            let result = try QRDecompositionSolverEngine().solve(
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
