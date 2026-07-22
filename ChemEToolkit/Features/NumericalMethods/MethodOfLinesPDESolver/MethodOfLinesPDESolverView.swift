import Foundation
import SwiftUI

struct MethodOfLinesPDESolverView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Method of Lines PDE Solver",
                    subtitle: "Solve a diffusion-reaction PDE by spatial discretization and RK4 integration."
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        CalculatorInfoCard {
                            Text("Example: one-dimensional diffusion with first-order reaction, fixed boundaries, and a sine-pulse initial profile.")
                        }

                        PrimaryActionButton(
                            title: "Calculate Example",
                            systemImage: "play.fill",
                            action: calculate
                        )

                        if let output {
                            CalculationResultCard(items: [
                                .init(
                                    label: "Center concentration",
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
            let result = try MethodOfLinesPDESolverEngine().solve(
                .init(
                    diffusivity: 0.01,
                    reactionRateConstant: 0.1,
                    length: 1,
                    totalTime: 0.1,
                    spatialNodes: 41,
                    timeSteps: 400,
                    initialConcentration: 1
                )
            )
            output = String(
                format: "%.8g",
                result.concentrations[result.concentrations.count / 2]
            )
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
