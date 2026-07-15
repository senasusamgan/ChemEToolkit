import Testing
@testable import ChemEToolkit

@Suite("McCabe–Thiele Method Engine")
struct McCabeThieleMethodEngineTests {
    private let engine = McCabeThieleMethodEngine()

    @Test("Steps the column and calculates the feed stage")
    func numericalAccuracy() throws {
        let result = try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 1))
        #expect(abs(result.continuousTheoreticalStageCount - 9.37557178499915) < 1e-10)
        #expect(result.requiredWholeStageCount == 10)
        #expect(result.feedStageNumber == 5)
        #expect(abs(result.minimumRefluxRatio - 1.1) < 1e-10)
    }

    @Test("Produces a physical fractional final stage")
    func specialCase() throws {
        let result = try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 1))
        #expect(result.stageLiquidCompositions.count == 10)
        #expect(result.finalStageFraction > 0)
        #expect(result.finalStageFraction < 1)
        #expect(result.stageLiquidCompositions.last! < 0.05)
    }

    @Test("Rejects invalid volatility, insufficient reflux, invalid q and nonfinite input")
    func validation() {
        #expect(throws: McCabeThieleMethodError.relativeVolatilityNotGreaterThanOne) {
            try engine.calculate(.init(relativeVolatility: 1, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 1))
        }
        #expect(throws: McCabeThieleMethodError.refluxAtOrBelowMinimum) {
            try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 1.1, feedQuality: 1))
        }
        #expect(throws: McCabeThieleMethodError.feedQualityOutOfRange) {
            try engine.calculate(.init(relativeVolatility: 2.5, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 3))
        }
        #expect(throws: McCabeThieleMethodError.nonFiniteInput) {
            try engine.calculate(.init(relativeVolatility: .nan, distillateLightMoleFraction: 0.95, bottomsLightMoleFraction: 0.05, feedLightMoleFraction: 0.5, refluxRatio: 2.5, feedQuality: 1))
        }
    }
}
