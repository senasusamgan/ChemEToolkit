import Foundation
import SwiftUI

struct LevenbergMarquardtRegressionView: View {
    @State private var xText = "0,1,2,3"
    @State private var yText = "2,3.2974,5.4366,8.9634"
    @State private var p0 = "1.5"
    @State private var p1 = "0.4"
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Levenberg–Marquardt Regression",
                    subtitle: "Fit a nonlinear exponential model using adaptive damping."
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        CalculatorInfoCard {
                            Text("Model: y = a·exp(bx). Enter comma-separated x and y values with mutually consistent units.")
                        }

                        EngineeringInputField(
                            title: "x values",
                            symbol: "x",
                            unit: "",
                            placeholder: "0,1,2,3",
                            text: $xText
                        )

                        EngineeringInputField(
                            title: "y values",
                            symbol: "y",
                            unit: "",
                            placeholder: "2,3.2974,5.4366,8.9634",
                            text: $yText
                        )

                        EngineeringInputField(
                            title: "Initial a",
                            symbol: "a₀",
                            unit: "",
                            placeholder: "1.5",
                            text: $p0
                        )

                        EngineeringInputField(
                            title: "Initial b",
                            symbol: "b₀",
                            unit: "",
                            placeholder: "0.4",
                            text: $p1
                        )

                        PrimaryActionButton(
                            title: "Fit",
                            systemImage: "chart.xyaxis.line",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(label: "Parameters (a, b)", value: output, unit: "")
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

    private func values(_ text: String) -> [Double] {
        text.split(separator: ",").compactMap {
            Double($0.trimmingCharacters(in: .whitespaces))
        }
    }

    private func calculate() {
        do {
            let result = try LevenbergMarquardtRegressionEngine().solve(
                .init(
                    xValues: values(xText),
                    yValues: values(yText),
                    model: .exponential,
                    initialParameters: [Double(p0) ?? .nan, Double(p1) ?? .nan]
                )
            )
            output = result.parameters
                .map { String(format: "%.8g", $0) }
                .joined(separator: ", ")
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
