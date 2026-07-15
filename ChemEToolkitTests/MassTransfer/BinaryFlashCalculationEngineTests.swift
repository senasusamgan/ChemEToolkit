import Testing
@testable import ChemEToolkit

@Suite("Binary Flash Calculation Engine")
struct BinaryFlashCalculationEngineTests {
    private let engine = BinaryFlashCalculationEngine()

    @Test("Solves a two-phase binary flash")
    func numericalAccuracy() throws {
        let result = try engine.calculate(.init(feedFlowRate: 100, feedLightMoleFraction: 0.5, lightComponentKValue: 2, heavyComponentKValue: 0.5))
        #expect(result.phaseState == .twoPhase)
        #expect(abs(result.vaporFraction - 0.5) < 1e-12)
        #expect(abs(result.liquidLightMoleFraction - 1.0 / 3.0) < 1e-12)
        #expect(abs(result.vaporLightMoleFraction - 2.0 / 3.0) < 1e-12)
        #expect(abs(result.vaporFlowRate - 50) < 1e-12)
    }

    @Test("Identifies bubble and dew boundaries")
    func boundaries() throws {
        let bubble = try engine.calculate(.init(feedFlowRate: 1, feedLightMoleFraction: 1.0 / 3.0, lightComponentKValue: 2, heavyComponentKValue: 0.5))
        #expect(bubble.phaseState == .bubblePoint)
        #expect(bubble.vaporFraction == 0)

        let dew = try engine.calculate(.init(feedFlowRate: 1, feedLightMoleFraction: 2.0 / 3.0, lightComponentKValue: 2, heavyComponentKValue: 0.5))
        #expect(dew.phaseState == .dewPoint)
        #expect(dew.vaporFraction == 1)
    }

    @Test("Rejects invalid flow, composition, K-values and nonfinite input")
    func validation() {
        #expect(throws: BinaryFlashCalculationError.nonPositiveFeedFlow) {
            try engine.calculate(.init(feedFlowRate: 0, feedLightMoleFraction: 0.5, lightComponentKValue: 2, heavyComponentKValue: 0.5))
        }
        #expect(throws: BinaryFlashCalculationError.feedCompositionOutOfRange) {
            try engine.calculate(.init(feedFlowRate: 1, feedLightMoleFraction: 1.1, lightComponentKValue: 2, heavyComponentKValue: 0.5))
        }
        #expect(throws: BinaryFlashCalculationError.invalidKValueOrdering) {
            try engine.calculate(.init(feedFlowRate: 1, feedLightMoleFraction: 0.5, lightComponentKValue: 0.5, heavyComponentKValue: 2))
        }
        #expect(throws: BinaryFlashCalculationError.nonFiniteInput) {
            try engine.calculate(.init(feedFlowRate: .nan, feedLightMoleFraction: 0.5, lightComponentKValue: 2, heavyComponentKValue: 0.5))
        }
    }
}
