import Testing
@testable import ChemEToolkit

@Suite("Second-Order Frequency Response Engine")
struct SecondOrderFrequencyResponseEngineTests {
    private let engine = SecondOrderFrequencyResponseEngine()

    @Test("Calculates response at natural frequency")
    func naturalFrequencyResponse() throws {
        let result = try engine.calculate(.init(processGain: 1, naturalFrequency: 2, dampingRatio: 0.4, angularFrequency: 2))
        #expect(result.normalizedFrequency == 1)
        #expect(abs(result.magnitude - 1.25) < 1e-12)
        #expect(abs(result.phaseDegrees + 90) < 1e-12)
        #expect(result.resonanceExists)
    }

    @Test("High damping removes resonant peak")
    func noResonance() throws {
        let result = try engine.calculate(.init(processGain: 1, naturalFrequency: 2, dampingRatio: 1, angularFrequency: 2))
        #expect(!result.resonanceExists)
        #expect(result.resonanceAngularFrequency == nil)
        #expect(result.resonantPeakMagnitude == nil)
    }

    @Test("Rejects invalid damping")
    func validation() {
        #expect(throws: SecondOrderFrequencyResponseError.nonPositiveDampingRatio) {
            try engine.calculate(.init(processGain: 1, naturalFrequency: 2, dampingRatio: 0, angularFrequency: 2))
        }
    }
}
