import Foundation
import SwiftUI
struct ThomasTridiagonalSolverView: View {
    @State private var lower = "-1,-1"
    @State private var diagonal = "2,2,2"
    @State private var upper = "-1,-1"
    @State private var constants = "1,0,1"
    @State private var output: String?
    @State private var errorText: String?
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 16) {
        Text("Thomas Tridiagonal Solver").font(.largeTitle.bold())
        Text("Enter comma-separated dimensionless diagonals. Off-diagonals require n−1 values.").foregroundStyle(.secondary)
        TextField("Lower diagonal", text: $lower); TextField("Main diagonal", text: $diagonal)
        TextField("Upper diagonal", text: $upper); TextField("Constants", text: $constants)
        Button("Calculate") { calculate() }.buttonStyle(.borderedProminent)
        if let output { Text("Solution: \(output)").font(.headline) }
        if let errorText { Text(errorText).foregroundStyle(.red) }
    }.textFieldStyle(.roundedBorder).padding() } }
    private func vector(_ text: String) -> [Double] { text.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) } }
    private func calculate() { do { let r = try ThomasTridiagonalSolverEngine().solve(.init(lowerDiagonal: vector(lower), mainDiagonal: vector(diagonal), upperDiagonal: vector(upper), constants: vector(constants))); output = r.solution.map { String(format: "%.8g", $0) }.joined(separator: ", "); errorText = nil } catch { output = nil; errorText = error.localizedDescription } }
}
