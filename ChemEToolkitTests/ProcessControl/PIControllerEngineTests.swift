import Testing
@testable import ChemEToolkit

@Suite("PI Controller Engine")
struct PIControllerEngineTests {
    private let engine = PIControllerEngine()

    @Test("Calculates PI output")
    func output() throws {
        let r = try engine.calculate(.init(
            controllerBias: 40, controllerGain: 2, currentError: 5,
            accumulatedErrorIntegral: 12, integralTime: 4,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.proportionalContribution == 10)
        #expect(r.integralContribution == 6)
        #expect(r.unconstrainedOutput == 56)
        #expect(r.equivalentIntegralGain == 0.5)
    }

    @Test("Limits integral windup output")
    func saturation() throws {
        let r = try engine.calculate(.init(
            controllerBias: 40, controllerGain: 2, currentError: 5,
            accumulatedErrorIntegral: 200, integralTime: 4,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.unconstrainedOutput == 150)
        #expect(r.constrainedOutput == 100)
        #expect(r.isSaturatedHigh)
        #expect(r.saturationAmount == -50)
    }

    @Test("Rejects invalid integral time")
    func validation() {
        #expect(throws: PIControllerError.nonPositiveIntegralTime) {
            try engine.calculate(.init(
                controllerBias: 40, controllerGain: 2, currentError: 5,
                accumulatedErrorIntegral: 12, integralTime: 0,
                minimumOutput: 0, maximumOutput: 100
            ))
        }
    }
}
