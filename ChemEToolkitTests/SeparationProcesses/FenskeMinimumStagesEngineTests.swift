import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Fenske Minimum Stages Engine")
struct FenskeMinimumStagesEngineTests {
    private let engine =
        FenskeMinimumStagesEngine()

    @Test("Calculates total-reflux minimum stages")
    func fenske() throws {
        let result = try engine.calculate(
            .init(
                distillateLightMoleFraction: 0.95,
                bottomsLightMoleFraction: 0.05,
                averageRelativeVolatility: 2.5
            )
        )

        let expected =
            log(
                (0.95 / 0.05)
                / (0.05 / 0.95)
            )
            / log(2.5)

        #expect(
            abs(
                result.minimumTheoreticalStages
                - expected
            ) < 1e-12
        )

        #expect(result.minimumTheoreticalStages > 0)
    }

    @Test("Greater volatility reduces minimum stages")
    func volatilityTrend() throws {
        let low = try engine.calculate(
            .init(
                distillateLightMoleFraction: 0.95,
                bottomsLightMoleFraction: 0.05,
                averageRelativeVolatility: 2
            )
        )

        let high = try engine.calculate(
            .init(
                distillateLightMoleFraction: 0.95,
                bottomsLightMoleFraction: 0.05,
                averageRelativeVolatility: 4
            )
        )

        #expect(
            high.minimumTheoreticalStages
            < low.minimumTheoreticalStages
        )
    }

    @Test("Rejects relative volatility of one")
    func validation() {
        #expect(
            throws:
                FenskeMinimumStagesError
                    .invalidRelativeVolatility
        ) {
            try engine.calculate(
                .init(
                    distillateLightMoleFraction: 0.95,
                    bottomsLightMoleFraction: 0.05,
                    averageRelativeVolatility: 1
                )
            )
        }
    }
}
