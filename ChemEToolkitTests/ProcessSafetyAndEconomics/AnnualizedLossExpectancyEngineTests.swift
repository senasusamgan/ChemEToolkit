import Testing
@testable import ChemEToolkit

@Suite("Annualized Loss Expectancy Engine")
struct AnnualizedLossExpectancyEngineTests {
    private let engine =
        AnnualizedLossExpectancyEngine()

    @Test("Calculates annualized retained loss")
    func annualizedLoss() throws {
        let result = try engine.calculate(
            .init(
                eventFrequencyPerYear: 0.02,
                assetDamageCost: 5_000_000,
                businessInterruptionCost: 3_000_000,
                environmentalRemediationCost: 1_000_000,
                injuryAndLiabilityCost: 2_000_000,
                insuranceRecoveryFraction: 0.4
            )
        )

        #expect(result.grossSingleEventLoss == 11_000_000)
        #expect(result.insuranceRecovery == 4_400_000)
        #expect(result.retainedSingleEventLoss == 6_600_000)
        #expect(result.annualizedGrossLoss == 220_000)
        #expect(result.annualizedRetainedLoss == 132_000)

        #expect(
            abs(
                result.retainedLossFraction
                - 0.6
            ) < 1e-12
        )

        #expect(
            result.dominantLossCategory
            == "Asset damage"
        )
    }

    @Test("Zero event frequency produces zero annual loss")
    func zeroFrequency() throws {
        let result = try engine.calculate(
            .init(
                eventFrequencyPerYear: 0,
                assetDamageCost: 100,
                businessInterruptionCost: 0,
                environmentalRemediationCost: 0,
                injuryAndLiabilityCost: 0,
                insuranceRecoveryFraction: 0
            )
        )

        #expect(result.annualizedGrossLoss == 0)
        #expect(result.annualizedRetainedLoss == 0)
    }

    @Test("Rejects insurance fraction above one")
    func validation() {
        #expect(
            throws:
                AnnualizedLossExpectancyError
                    .insuranceFractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    eventFrequencyPerYear: 0.02,
                    assetDamageCost: 100,
                    businessInterruptionCost: 0,
                    environmentalRemediationCost: 0,
                    injuryAndLiabilityCost: 0,
                    insuranceRecoveryFraction: 1.2
                )
            )
        }
    }
}
