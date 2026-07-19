import Testing
@testable import ChemEToolkit
@Suite("LU Decomposition Solver Engine") struct LUDecompositionSolverEngineTests {
    @Test("Solves a reference system") func reference() throws { let r = try LUDecompositionSolverEngine().solve(.init(matrix: [[3,1],[1,2]], constants: [9,8])); #expect(abs(r.solution[0]-2) < 1e-10); #expect(abs(r.solution[1]-3) < 1e-10) }
    @Test("Partial pivoting handles a zero leading entry") func pivoting() throws { let r = try LUDecompositionSolverEngine().solve(.init(matrix: [[0,2],[1,3]], constants: [4,7])); #expect(r.residualNorm < 1e-10) }
    @Test("Rejects a singular matrix") func invalid() { #expect(throws: LUDecompositionSolverError.singularMatrix) { try LUDecompositionSolverEngine().solve(.init(matrix: [[1,2],[2,4]], constants: [1,2])) } }
}
