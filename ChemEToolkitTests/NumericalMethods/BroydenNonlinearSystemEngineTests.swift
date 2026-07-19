import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Broyden Nonlinear System Engine") struct BroydenNonlinearSystemEngineTests {
    @Test("Solves the circle-line reference system") func reference() throws { let r = try BroydenNonlinearSystemEngine().solve(.init(system: .circleAndLine, initialGuess: [0.8,0.6])); let q = 1/sqrt(2.0); #expect(abs(r.solution[0]-q) < 1e-7); #expect(abs(r.solution[1]-q) < 1e-7) }
    @Test("Converged residual meets tolerance") func trend() throws { let r = try BroydenNonlinearSystemEngine().solve(.init(system: .equilibriumBalance, parameter: 0.16, initialGuess: [0.7,0.3])); #expect(r.residualNorm <= 1e-10) }
    @Test("Rejects an invalid initial guess") func invalid() { #expect(throws: BroydenNonlinearSystemError.invalidInitialGuess) { try BroydenNonlinearSystemEngine().solve(.init(system: .circleAndLine, initialGuess: [1])) } }
}
