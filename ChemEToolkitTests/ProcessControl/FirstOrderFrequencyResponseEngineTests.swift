import Testing
@testable import ChemEToolkit

@Suite("First-Order Frequency Response Engine")
struct FirstOrderFrequencyResponseEngineTests {
    private let engine = FirstOrderFrequencyResponseEngine()

    @Test("Calculates cutoff-frequency response")
    func cutoffResponse() throws {
        let result = try engine.calculate(.init(processGain: 2, timeConstant: 4, angularFrequency: 0.25))
        #expect(result.normalizedFrequency == 1)
        #expect(abs(result.magnitude - 2 / 2.0.squareRoot()) < 1e-12)
        #expect(abs(result.phaseDegrees + 45) < 1e-12)
        #expect(abs(result.cutoffAngularFrequency - 0.25) < 1e-12)
    }

    @Test("Negative gain includes phase inversion")
    func negativeGain() throws {
        let result = try engine.calculate(.init(processGain: -2, timeConstant: 4, angularFrequency: 0))
        #expect(result.realPart == -2)
        #expect(result.imaginaryPart == 0)
        #expect(abs(abs(result.phaseDegrees) - 180) < 1e-12)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: FirstOrderFrequencyResponseError.nonPositiveTimeConstant) {
            try engine.calculate(.init(processGain: 2, timeConstant: 0, angularFrequency: 1))
        }
        #expect(throws: FirstOrderFrequencyResponseError.negativeAngularFrequency) {
            try engine.calculate(.init(processGain: 2, timeConstant: 4, angularFrequency: -1))
        }
    }
}
