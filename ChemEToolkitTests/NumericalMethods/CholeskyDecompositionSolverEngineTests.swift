import Testing
@testable import ChemEToolkit
@Suite("Cholesky Decomposition Solver Engine") struct CholeskyDecompositionSolverEngineTests {
    @Test("Solves an SPD reference system") func reference() throws { let r = try CholeskyDecompositionSolverEngine().solve(.init(matrix: [[4,1],[1,3]], constants: [1,2])); #expect(abs(r.solution[0]-1.0/11) < 1e-10); #expect(abs(r.solution[1]-7.0/11) < 1e-10) }
    @Test("Reconstructs a positive diagonal") func trend() throws { let r = try CholeskyDecompositionSolverEngine().solve(.init(matrix: [[9,3],[3,5]], constants: [1,1])); #expect(r.lowerMatrix[0][0] > 0); #expect(r.lowerMatrix[1][1] > 0) }
    @Test("Rejects a non-SPD matrix") func invalid() { #expect(throws: CholeskyDecompositionSolverError.notPositiveDefinite) { try CholeskyDecompositionSolverEngine().solve(.init(matrix: [[1,2],[2,1]], constants: [1,1])) } }
}
