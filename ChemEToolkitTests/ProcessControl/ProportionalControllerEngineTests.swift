import Testing
@testable import ChemEToolkit

@Suite("Proportional Controller Engine")
struct ProportionalControllerEngineTests {
    private let engine = ProportionalControllerEngine()

    @Test("Calculates proportional output")
    func output() throws {
        let r = try engine.calculate(.init(
            controllerBias: 50, controllerGain: 2, currentError: 10,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(r.proportionalContribution == 20)
        #expect(r.unconstrainedOutput == 70)
        #expect(r.constrainedOutput == 70)
        #expect(!r.isSaturatedLow)
        #expect(!r.isSaturatedHigh)
    }

    @Test("Applies saturation")
    func saturation() throws {
        let high = try engine.calculate(.init(
            controllerBias: 50, controllerGain: 10, currentError: 10,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(high.constrainedOutput == 100)
        #expect(high.isSaturatedHigh)
        #expect(high.saturationAmount == -50)

        let low = try engine.calculate(.init(
            controllerBias: 50, controllerGain: 10, currentError: -10,
            minimumOutput: 0, maximumOutput: 100
        ))
        #expect(low.constrainedOutput == 0)
        #expect(low.isSaturatedLow)
        #expect(low.saturationAmount == 50)
    }

    @Test("Rejects invalid limits")
    func validation() {
        #expect(throws: ProportionalControllerError.invalidOutputLimits) {
            try engine.calculate(.init(
                controllerBias: 50, controllerGain: 2, currentError: 10,
                minimumOutput: 100, maximumOutput: 0
            ))
        }
    }
}
