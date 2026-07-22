import Foundation
import SwiftUI

struct RiddersRootFinderView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Ridders Root Finder",
                    subtitle: "Find a bracketed nonlinear root using exponential interpolation."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: solve the dimensionless equation x³ − x − 2 = 0 on the bracket [1, 2].")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Root",
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
            let result = try RiddersRootFinderEngine().solve(
                .init(
                    function: .cubic,
                    lowerBound: 1,
                    upperBound: 2
                )
            )
            output = String(format: "%.10g", result.root)
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
