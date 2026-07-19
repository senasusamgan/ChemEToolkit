import Testing
@testable import ChemEToolkit
@Suite("Conjugate Gradient Solver Engine") struct ConjugateGradientSolverEngineTests {
    @Test("Solves an SPD reference system") func reference() throws { let r = try ConjugateGradientSolverEngine().solve(.init(matrix: [[4,1],[1,3]], constants: [1,2], initialGuess: [0,0])); #expect(abs(r.solution[0]-1.0/11) < 1e-9); #expect(abs(r.solution[1]-7.0/11) < 1e-9) }
    @Test("Residual decreases from the initial guess") func trend() throws { let r = try ConjugateGradientSolverEngine().solve(.init(matrix: [[4,1],[1,3]], constants: [1,2], initialGuess: [0,0])); #expect(r.residualHistory.last! < r.residualHistory.first!) }
    @Test("Rejects a nonsymmetric matrix") func invalid() { #expect(throws: ConjugateGradientSolverError.notSymmetric) { try ConjugateGradientSolverEngine().solve(.init(matrix: [[2,1],[0,2]], constants: [1,1], initialGuess: [0,0])) } }
}
