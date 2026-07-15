import Testing
@testable import ChemEToolkit

@Suite("Relative Volatility and Binary VLE Engine")
struct RelativeVolatilityBinaryVLEEngineTests {
    private let engine = RelativeVolatilityBinaryVLEEngine()

    @Test("Converts and inverts binary equilibrium compositions")
    func numericalAccuracy() throws {
        let forward = try engine.calculate(.init(mode: .liquidToVapor, relativeVolatility: 2.5, specifiedMoleFraction: 0.4))
        #expect(abs(forward.vaporMoleFraction - 0.625) < 1e-12)
        #expect(abs(forward.vaporEnrichmentFactor - 1.5625) < 1e-12)

        let inverse = try engine.calculate(.init(mode: .vaporToLiquid, relativeVolatility: 2.5, specifiedMoleFraction: 0.625))
        #expect(abs(inverse.liquidMoleFraction - 0.4) < 1e-12)
    }

    @Test("Handles a pure-component boundary")
    func boundary() throws {
        let result = try engine.calculate(.init(mode: .liquidToVapor, relativeVolatility: 2.5, specifiedMoleFraction: 0))
        #expect(result.vaporMoleFraction == 0)
        #expect(result.vaporEnrichmentFactor == 2.5)
    }

    @Test("Rejects invalid volatility, composition and nonfinite input")
    func validation() {
        #expect(throws: RelativeVolatilityBinaryVLEError.relativeVolatilityNotGreaterThanOne) {
            try engine.calculate(.init(mode: .liquidToVapor, relativeVolatility: 1, specifiedMoleFraction: 0.4))
        }
        #expect(throws: RelativeVolatilityBinaryVLEError.moleFractionOutOfRange) {
            try engine.calculate(.init(mode: .liquidToVapor, relativeVolatility: 2, specifiedMoleFraction: 1.1))
        }
        #expect(throws: RelativeVolatilityBinaryVLEError.nonFiniteInput) {
            try engine.calculate(.init(mode: .vaporToLiquid, relativeVolatility: .nan, specifiedMoleFraction: 0.5))
        }
    }
}
