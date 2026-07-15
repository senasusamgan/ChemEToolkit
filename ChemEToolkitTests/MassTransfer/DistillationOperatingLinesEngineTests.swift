import Testing
@testable import ChemEToolkit

@Suite("Distillation Operating Lines Engine")
struct DistillationOperatingLinesEngineTests {
    private let engine = DistillationOperatingLinesEngine()

    @Test("Calculates saturated-liquid operating lines and minimum reflux")
    func numericalAccuracy() throws {
        let result = try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 1))
        #expect(abs(result.rectifyingSlope - 0.7142857142857143) < 1e-12)
        #expect(abs(result.feedIntersectionVaporMoleFraction - 0.6285714285714286) < 1e-12)
        #expect(abs(result.strippingSlope - 1.2857142857142856) < 1e-12)
        #expect(abs(result.minimumRefluxRatio - 1.1) < 1e-10)
    }

    @Test("Handles the saturated-vapor horizontal q-line")
    func specialCase() throws {
        let result = try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 0))
        #expect(abs(result.feedIntersectionLiquidMoleFraction - 0.32) < 1e-12)
        #expect(abs(result.feedIntersectionVaporMoleFraction - 0.5) < 1e-12)
        #expect(result.feedLineSlope == 0)
    }

    @Test("Rejects invalid specifications and insufficient reflux")
    func validation() {
        #expect(throws: DistillationOperatingLinesError.invalidCompositionOrdering) {
            try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.5, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.7, refluxRatio: 2.5, feedQuality: 1))
        }
        #expect(throws: DistillationOperatingLinesError.refluxAtOrBelowMinimum) {
            try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 1.1, feedQuality: 1))
        }
        #expect(throws: DistillationOperatingLinesError.feedQualityOutOfRange) {
            try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 3))
        }
        #expect(throws: DistillationOperatingLinesError.nonFiniteInput) {
            try engine.calculate(.init(relativeVolatility: .nan, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 1))
        }
    }
}
