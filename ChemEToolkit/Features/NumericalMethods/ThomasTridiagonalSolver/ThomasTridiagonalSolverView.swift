import Foundation
import SwiftUI

struct ThomasTridiagonalSolverView: View {
    @State private var lower = "-1,-1"
    @State private var diagonal = "2,2,2"
    @State private var upper = "-1,-1"
    @State private var constants = "1,0,1"
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Thomas Tridiagonal Solver",
                    subtitle: "Efficiently solve tridiagonal linear systems."
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        CalculatorInfoCard {
                            Text("Enter comma-separated dimensionless diagonals. Off-diagonals require n − 1 values.")
                        }

                        EngineeringInputField(
                            title: "Lower diagonal",
                            symbol: "a",
                            unit: "",
                            placeholder: "-1,-1",
                            text: $lower
                        )

                        EngineeringInputField(
                            title: "Main diagonal",
                            symbol: "b",
                            unit: "",
                            placeholder: "2,2,2",
                            text: $diagonal
                        )

                        EngineeringInputField(
                            title: "Upper diagonal",
                            symbol: "c",
                            unit: "",
                            placeholder: "-1,-1",
                            text: $upper
                        )

                        EngineeringInputField(
                            title: "Constants",
                            symbol: "d",
                            unit: "",
                            placeholder: "1,0,1",
                            text: $constants
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

    private func vector(_ text: String) -> [Double] {
        text.split(separator: ",").compactMap {
            Double($0.trimmingCharacters(in: .whitespaces))
        }
    }

    private func calculate() {
        do {
            let result = try ThomasTridiagonalSolverEngine().solve(
                .init(
                    lowerDiagonal: vector(lower),
                    mainDiagonal: vector(diagonal),
                    upperDiagonal: vector(upper),
                    constants: vector(constants)
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
