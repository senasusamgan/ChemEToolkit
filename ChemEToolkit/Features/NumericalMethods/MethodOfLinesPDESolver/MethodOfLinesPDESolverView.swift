import Foundation
import SwiftUI

struct MethodOfLinesPDESolverView: View {
    @State private var output: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Method of Lines PDE Solver")
                    .font(.largeTitle.bold())
                Text("Solves one-dimensional diffusion with first-order reaction using central spatial differences and RK4 time integration.")
                    .foregroundStyle(.secondary)
                Button("Calculate Example") { calculate() }
                    .buttonStyle(.borderedProminent)
                if let output {
                    Text("Result: \(output)").font(.headline)
                }
                if let errorText {
                    Text(errorText).foregroundStyle(.red)
                }
            }
            .padding()
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
            output = String(format: "Center concentration %.8g", result.concentrations[result.concentrations.count / 2])
            errorText = nil
        } catch {
            output = nil
            errorText = error.localizedDescription
        }
    }
}
