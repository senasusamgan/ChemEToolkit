import Foundation
import SwiftUI

struct OneDimensionalWaveEquationView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "One-Dimensional Wave Equation",
                    subtitle: "Simulate fixed-end vibration with an explicit finite-difference scheme."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: propagate a sine-mode displacement on a unit domain while satisfying the CFL stability limit.")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Center displacement",
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
            let result = try OneDimensionalWaveEquationEngine().solve(
                .init(
                    waveSpeed: 1,
                    length: 1,
                    totalTime: 0.5,
                    spatialNodes: 51,
                    timeSteps: 50,
                    initialAmplitude: 1
                )
            )
            output = String(
                format: "%.6g",
                result.displacements[result.displacements.count / 2]
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
