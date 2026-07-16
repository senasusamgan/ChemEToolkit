import Testing
@testable import ChemEToolkit

@Suite("PID Controller Engine")
struct PIDControllerEngineTests {
    private let engine = PIDControllerEngine()

    @Test("Calculates all PID terms")
    func output() throws {
        let r = try engine.calculate(.init(
            controllerBias: 40, controllerGain: 2, currentError: 5,
            accumulatedErrorIntegral: 12, errorRateOfChange: -1,
            integralTime: 4, derivativeTime: 2,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.proportionalContribution == 10)
        #expect(r.integralContribution == 6)
        #expect(r.derivativeContribution == -4)
        #expect(r.unconstrainedOutput == 52)
        #expect(abs(r.proportionalShareFraction! - 0.5) < 1e-12)
        #expect(abs(r.integralShareFraction! - 0.3) < 1e-12)
        #expect(abs(r.derivativeShareFraction! - 0.2) < 1e-12)
    }

    @Test("Zero contributions return nil shares")
    func zeroContributions() throws {
        let r = try engine.calculate(.init(
            controllerBias: 40, controllerGain: 2, currentError: 0,
            accumulatedErrorIntegral: 0, errorRateOfChange: 0,
            integralTime: 4, derivativeTime: 2,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.unconstrainedOutput == 40)
        #expect(r.proportionalShareFraction == nil)
        #expect(r.integralShareFraction == nil)
        #expect(r.derivativeShareFraction == nil)
    }

    @Test("Rejects invalid PID times")
    func validation() {
        #expect(throws: PIDControllerError.nonPositiveIntegralTime) {
            try engine.calculate(.init(
                controllerBias: 40, controllerGain: 2, currentError: 5,
                accumulatedErrorIntegral: 12, errorRateOfChange: -1,
                integralTime: 0, derivativeTime: 2,
                minimumOutput: 0, maximumOutput: 100
            ))
        }
        #expect(throws: PIDControllerError.negativeDerivativeTime) {
            try engine.calculate(.init(
                controllerBias: 40, controllerGain: 2, currentError: 5,
                accumulatedErrorIntegral: 12, errorRateOfChange: -1,
                integralTime: 4, derivativeTime: -1,
                minimumOutput: 0, maximumOutput: 100
            ))
        }
    }
}
