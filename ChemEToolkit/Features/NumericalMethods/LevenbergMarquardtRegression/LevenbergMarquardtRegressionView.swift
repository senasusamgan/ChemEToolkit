import Foundation
import SwiftUI
struct LevenbergMarquardtRegressionView: View {
    @State private var xText = "0,1,2,3"
    @State private var yText = "2,3.2974,5.4366,8.9634"
    @State private var p0 = "1.5"
    @State private var p1 = "0.4"
    @State private var output: String?
    @State private var errorText: String?
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 16) {
        Text("Levenberg–Marquardt Regression").font(.largeTitle.bold())
        Text("Model: y = a·exp(bx). x and y units must be mutually consistent; parameters inherit those units.").foregroundStyle(.secondary)
        TextField("x values", text: $xText); TextField("y values", text: $yText)
        TextField("Initial a", text: $p0); TextField("Initial b", text: $p1)
        Button("Fit") { calculate() }.buttonStyle(.borderedProminent)
        if let output { Text("Parameters: \(output)").font(.headline) }
        if let errorText { Text(errorText).foregroundStyle(.red) }
    }.textFieldStyle(.roundedBorder).padding() } }
    private func values(_ text: String) -> [Double] { text.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) } }
    private func calculate() { do { let r = try LevenbergMarquardtRegressionEngine().solve(.init(xValues: values(xText), yValues: values(yText), model: .exponential, initialParameters: [Double(p0) ?? .nan, Double(p1) ?? .nan])); output = r.parameters.map { String(format: "%.8g", $0) }.joined(separator: ", "); errorText = nil } catch { output = nil; errorText = error.localizedDescription } }
}
