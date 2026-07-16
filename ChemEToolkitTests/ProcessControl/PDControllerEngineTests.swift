import Testing
@testable import ChemEToolkit

@Suite("PD Controller Engine")
struct PDControllerEngineTests {
    private let engine = PDControllerEngine()

    @Test("Calculates PD output")
    func output() throws {
        let r = try engine.calculate(.init(
            controllerBias: 50, controllerGain: 2, currentError: 4,
            errorRateOfChange: -1.5, derivativeTime: 3,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.proportionalContribution == 8)
        #expect(r.derivativeContribution == -9)
        #expect(r.unconstrainedOutput == 49)
        #expect(r.equivalentDerivativeGain == 6)
    }

    @Test("Zero derivative time reduces to P")
    func zeroDerivative() throws {
        let r = try engine.calculate(.init(
            controllerBias: 50, controllerGain: 2, currentError: 4,
            errorRateOfChange: 100, derivativeTime: 0,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.derivativeContribution == 0)
        #expect(r.unconstrainedOutput == 58)
    }

    @Test("Rejects negative derivative time")
    func validation() {
        #expect(throws: PDControllerError.negativeDerivativeTime) {
            try engine.calculate(.init(
                controllerBias: 50, controllerGain: 2, currentError: 4,
                errorRateOfChange: -1.5, derivativeTime: -1,
                minimumOutput: 0, maximumOutput: 100
            ))
        }
    }
}
