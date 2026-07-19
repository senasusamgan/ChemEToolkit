import Foundation
import SwiftUI
struct BroydenNonlinearSystemView: View {
    @State private var x = "0.8"
    @State private var y = "0.6"
    @State private var output: String?
    @State private var errorText: String?
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 16) {
        Text("Broyden Nonlinear System").font(.largeTitle.bold())
        Text("Model: x² + y² = 1 and x = y. Inputs and results are dimensionless.").foregroundStyle(.secondary)
        TextField("Initial x", text: $x); TextField("Initial y", text: $y)
        Button("Calculate") { calculate() }.buttonStyle(.borderedProminent)
        if let output { Text("Solution: \(output)").font(.headline) }
        if let errorText { Text(errorText).foregroundStyle(.red) }
    }.textFieldStyle(.roundedBorder).padding() } }
    private func calculate() { do { let r = try BroydenNonlinearSystemEngine().solve(.init(system: .circleAndLine, initialGuess: [Double(x) ?? .nan, Double(y) ?? .nan])); output = r.solution.map { String(format: "%.8g", $0) }.joined(separator: ", "); errorText = nil } catch { output = nil; errorText = error.localizedDescription } }
}
