import Foundation
import SwiftUI

struct QRDecompositionSolverView: View {
    @State private var matrixText = "1,0;1,1;1,2"
    @State private var vectorText = "1,3,5"
    @State private var resultText: String?
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("QR Decomposition Solver").font(.largeTitle.bold())
                Text("The matrix must have at least as many rows as columns and full column rank.").foregroundStyle(.secondary)
                Group { Text("Matrix A (rows separated by ;)"); TextField("Matrix", text: $matrixText)
                    Text("Vector b"); TextField("Vector", text: $vectorText) }.textFieldStyle(.roundedBorder)
                Button("Calculate") { calculate() }.buttonStyle(.borderedProminent)
                if let resultText { Text("Solution: \(resultText)").font(.headline) }
                if let errorText { Text(errorText).foregroundStyle(.red) }
            }.padding()
        }
    }
    private func parseVector(_ text: String) -> [Double] { text.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) } }
    private func parseMatrix(_ text: String) -> [[Double]] { text.split(separator: ";").map { parseVector(String($0)) } }
    private func calculate() {
        do { let result = try QRDecompositionSolverEngine().solve(.init(matrix: parseMatrix(matrixText), constants: parseVector(vectorText))); resultText = result.solution.map { String(format: "%.8g", $0) }.joined(separator: ", "); errorText = nil }
        catch { resultText = nil; errorText = error.localizedDescription }
    }
}
