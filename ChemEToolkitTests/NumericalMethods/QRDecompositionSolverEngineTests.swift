import Testing
@testable import ChemEToolkit
@Suite("QR Decomposition Solver Engine") struct QRDecompositionSolverEngineTests {
    @Test("Fits an exact reference line") func reference() throws { let r = try QRDecompositionSolverEngine().solve(.init(matrix: [[1,0],[1,1],[1,2]], constants: [1,3,5])); #expect(abs(r.solution[0]-1) < 1e-10); #expect(abs(r.solution[1]-2) < 1e-10) }
    @Test("Additional consistent data preserves the solution") func trend() throws { let r = try QRDecompositionSolverEngine().solve(.init(matrix: [[1,0],[1,1],[1,2],[1,3]], constants: [1,3,5,7])); #expect(r.residualNorm < 1e-10) }
    @Test("Rejects rank deficiency") func invalid() { #expect(throws: QRDecompositionSolverError.rankDeficient) { try QRDecompositionSolverEngine().solve(.init(matrix: [[1,2],[2,4]], constants: [1,2])) } }
}
