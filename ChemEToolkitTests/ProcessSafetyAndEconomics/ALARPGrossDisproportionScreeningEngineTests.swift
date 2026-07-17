import Foundation
import Testing
@testable import ChemEToolkit

@Suite("ALARP Gross Disproportion Screening Engine")
struct ALARPGrossDisproportionScreeningEngineTests {
    private let engine =
        ALARPGrossDisproportionScreeningEngine()

    @Test("Calculates adjusted cost threshold")
    func grossDisproportion() throws {
        let result = try engine.calculate(
            .init(
                riskReductionMeasureCost: 1_500_000,
                annualizedLossReduction: 200_000,
                projectLifeYears: 10,
                discountRateFraction: 0.08,
                grossDisproportionFactor: 3
            )
        )

        let factor =
            (
                1
                - pow(1.08, -10)
            )
            / 0.08

        let benefit =
            200_000
            * factor

        #expect(
            abs(
                result.presentValueOfRiskReductionBenefit
                - benefit
            ) < 1e-8
        )

        #expect(
            abs(
                result.adjustedReasonableCostThreshold
                - 3 * benefit
            ) < 1e-8
        )

        #expect(
            !result.measureCostIsGrosslyDisproportionate
        )
    }

    @Test("Detects cost above adjusted threshold")
    func disproportionateCost() throws {
        let result = try engine.calculate(
            .init(
                riskReductionMeasureCost: 10_000,
                annualizedLossReduction: 100,
                projectLifeYears: 1,
                discountRateFraction: 0,
                grossDisproportionFactor: 2
            )
        )

        #expect(
            result.adjustedReasonableCostThreshold
            == 200
        )

        #expect(
            result.measureCostIsGrosslyDisproportionate
        )
    }

    @Test("Rejects zero risk-reduction benefit")
    func validation() {
        #expect(
            throws:
                ALARPGrossDisproportionScreeningError
                    .zeroRiskReductionBenefit
        ) {
            try engine.calculate(
                .init(
                    riskReductionMeasureCost: 10_000,
                    annualizedLossReduction: 0,
                    projectLifeYears: 1,
                    discountRateFraction: 0,
                    grossDisproportionFactor: 2
                )
            )
        }
    }
}
