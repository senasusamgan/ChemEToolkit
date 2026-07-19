import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Newton-Raphson Nonlinear System Engine") struct NewtonRaphsonNonlinearSystemEngineTests {
    @Test("Solves the circle-line reference system") func reference() throws { let r = try NewtonRaphsonNonlinearSystemEngine().solve(.init(system: .circleAndLine, initialGuess: [0.8,0.6])); let q = 1/sqrt(2.0); #expect(abs(r.solution[0]-q) < 1e-8); #expect(abs(r.solution[1]-q) < 1e-8) }
    @Test("A closer guess requires no more iterations") func trend() throws { let e = NewtonRaphsonNonlinearSystemEngine(); let far = try e.solve(.init(system: .circleAndLine, initialGuess: [1.2,0.2])); let near = try e.solve(.init(system: .circleAndLine, initialGuess: [0.71,0.70])); #expect(near.iterations <= far.iterations) }
    @Test("Rejects an invalid equilibrium parameter") func invalid() { #expect(throws: NewtonRaphsonNonlinearSystemError.invalidParameter) { try NewtonRaphsonNonlinearSystemEngine().solve(.init(system: .equilibriumBalance, parameter: 0.5, initialGuess: [0.5,0.5])) } }
}
