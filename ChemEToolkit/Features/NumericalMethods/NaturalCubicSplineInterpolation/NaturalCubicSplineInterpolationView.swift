import Foundation
import SwiftUI

struct NaturalCubicSplineInterpolationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Natural Cubic Spline Interpolation",
                    subtitle: "Interpolate tabulated data with a smooth natural cubic spline."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: interpolate y at x = 1.5 from the dimensionless points (0, 0), (1, 1), (2, 4), and (3, 9).")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Interpolated value",
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
            let result = try NaturalCubicSplineInterpolationEngine().solve(
                .init(
                    xValues: [0, 1, 2, 3],
                    yValues: [0, 1, 4, 9],
                    query: 1.5
                )
            )
            output = String(format: "%.10g", result.value)
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
