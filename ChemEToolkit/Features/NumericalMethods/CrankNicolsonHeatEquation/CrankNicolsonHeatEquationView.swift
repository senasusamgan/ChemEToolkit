import Foundation
import SwiftUI

struct CrankNicolsonHeatEquationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Crank-Nicolson Heat Equation",
                    subtitle: "Implicit finite-difference transient conduction in a one-dimensional slab."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: transient conduction in a 0.1 m slab with fixed boundary temperatures.")
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
                                        label: "Center temperature",
                                        value: output,
                                        unit: "°C"
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
            let result = try CrankNicolsonHeatEquationEngine().solve(
                .init(
                    thermalDiffusivity: 1e-5,
                    length: 0.1,
                    totalTime: 100,
                    spatialNodes: 11,
                    timeSteps: 20,
                    initialTemperature: 20,
                    leftBoundaryTemperature: 100,
                    rightBoundaryTemperature: 20
                )
            )
            output = String(
                format: "%.6g",
                result.temperatures[
                    result.temperatures.count / 2
                ]
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
