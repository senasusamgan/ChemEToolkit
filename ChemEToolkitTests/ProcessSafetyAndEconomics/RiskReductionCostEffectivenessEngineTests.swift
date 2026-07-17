import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Risk Reduction Cost Effectiveness Engine")
struct RiskReductionCostEffectivenessEngineTests {
    private let engine =
        RiskReductionCostEffectivenessEngine()

    @Test("Calculates discounted avoided-loss economics")
    func costEffectiveness() throws {
        let result = try engine.calculate(
            .init(
                currentAnnualizedLoss: 400_000,
                residualAnnualizedLoss: 100_000,
                initialRiskReductionInvestment: 1_000_000,
                annualMaintenanceCost: 25_000,
                projectLifeYears: 10,
                discountRateFraction: 0.08
            )
        )

        let factor =
            (
                1
                - Foundation.pow(1.08, Double(-10))
            )
            / 0.08

        #expect(result.annualLossReduction == 300_000)

        #expect(
            abs(
                result.presentValueOfLossReduction
                - 300_000 * factor
            ) < 1e-8
        )

        #expect(
            abs(
                result.presentValueOfMaintenanceCost
                - 25_000 * factor
            ) < 1e-8
        )

        #expect(result.netPresentValueOfRiskReduction > 0)
        #expect(result.benefitCostRatio > 1)
        #expect(result.economicallyFavorable)
    }

    @Test("No annual net benefit produces no payback")
    func noPayback() throws {
        let result = try engine.calculate(
            .init(
                currentAnnualizedLoss: 100,
                residualAnnualizedLoss: 90,
                initialRiskReductionInvestment: 1000,
                annualMaintenanceCost: 20,
                projectLifeYears: 5,
                discountRateFraction: 0.1
            )
        )

        #expect(result.simplePaybackYears == nil)
    }

    @Test("Rejects residual loss above current loss")
    func validation() {
        #expect(
            throws:
                RiskReductionCostEffectivenessError
                    .residualExceedsCurrentLoss
        ) {
            try engine.calculate(
                .init(
                    currentAnnualizedLoss: 100,
                    residualAnnualizedLoss: 120,
                    initialRiskReductionInvestment: 1000,
                    annualMaintenanceCost: 20,
                    projectLifeYears: 5,
                    discountRateFraction: 0.1
                )
            )
        }
    }
}
