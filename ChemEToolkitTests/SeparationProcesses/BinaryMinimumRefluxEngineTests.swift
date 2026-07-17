import Testing
@testable import ChemEToolkit

@Suite("Binary Minimum Reflux Engine")
struct BinaryMinimumRefluxEngineTests {
    private let engine =
        BinaryMinimumRefluxEngine()

    @Test("Calculates saturated-liquid minimum reflux")
    func minimumReflux() throws {
        let result = try engine.calculate(
            .init(
                feedLightMoleFraction: 0.4,
                distillateLightMoleFraction: 0.9,
                relativeVolatility: 2.5
            )
        )

        let yFeed =
            2.5 * 0.4
            / (1 + 1.5 * 0.4)

        let slope =
            (0.9 - yFeed)
            / (0.9 - 0.4)

        let expected =
            slope / (1 - slope)

        #expect(
            abs(
                result.minimumRefluxRatio
                - expected
            ) < 1e-12
        )

        #expect(result.minimumRefluxRatio > 0)
    }

    @Test("Higher volatility lowers minimum reflux")
    func volatilityTrend() throws {
        let low = try engine.calculate(
            .init(
                feedLightMoleFraction: 0.4,
                distillateLightMoleFraction: 0.9,
                relativeVolatility: 2
            )
        )

        let high = try engine.calculate(
            .init(
                feedLightMoleFraction: 0.4,
                distillateLightMoleFraction: 0.9,
                relativeVolatility: 4
            )
        )

        #expect(
            high.minimumRefluxRatio
            < low.minimumRefluxRatio
        )
    }

    @Test("Rejects distillate below feed composition")
    func validation() {
        #expect(
            throws:
                BinaryMinimumRefluxError
                    .invalidCompositionOrdering
        ) {
            try engine.calculate(
                .init(
                    feedLightMoleFraction: 0.4,
                    distillateLightMoleFraction: 0.3,
                    relativeVolatility: 2.5
                )
            )
        }
    }
}
