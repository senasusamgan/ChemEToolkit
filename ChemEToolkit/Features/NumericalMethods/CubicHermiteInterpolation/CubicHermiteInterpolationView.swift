import Foundation
import SwiftUI

struct CubicHermiteInterpolationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Cubic Hermite Interpolation",
                    subtitle: "Interpolate between two points while preserving endpoint slopes."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: interpolate at x = 0.5 using endpoint values and slopes.")
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
                                        label: "Interpolated value",
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
            let result = try CubicHermiteInterpolationEngine().solve(
                .init(
                    x0: 0,
                    x1: 1,
                    y0: 0,
                    y1: 1,
                    slope0: 0,
                    slope1: 3,
                    query: 0.5
                )
            )
            output = String(
                format: "%.10g",
                result.value
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
