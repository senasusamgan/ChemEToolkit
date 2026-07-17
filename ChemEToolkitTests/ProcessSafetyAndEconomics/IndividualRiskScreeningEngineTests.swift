import Testing
@testable import ChemEToolkit

@Suite("Individual Risk Screening Engine")
struct IndividualRiskScreeningEngineTests {
    private let engine =
        IndividualRiskScreeningEngine()

    @Test("Calculates annual individual risk")
    func annualRisk() throws {
        let result = try engine.calculate(
            .init(
                scenarioFrequencyPerYear: 0.001,
                fatalityProbabilityGivenExposure: 0.1,
                occupancyFraction: 0.25,
                presenceProbability: 0.5
            )
        )

        #expect(
            abs(
                result.combinedExposureProbability
                - 0.0125
            ) < 1e-12
        )

        #expect(
            abs(
                result.annualIndividualRisk
                - 0.0000125
            ) < 1e-15
        )

        #expect(
            abs(
                result.annualIndividualRiskPerMillion
                - 12.5
            ) < 1e-12
        )

        #expect(
            abs(
                result.returnPeriodYears
                - 80_000
            ) < 1e-8
        )
    }

    @Test("Zero frequency produces infinite return period")
    func zeroFrequency() throws {
        let result = try engine.calculate(
            .init(
                scenarioFrequencyPerYear: 0,
                fatalityProbabilityGivenExposure: 0.1,
                occupancyFraction: 0.25,
                presenceProbability: 0.5
            )
        )

        #expect(result.annualIndividualRisk == 0)
        #expect(result.returnPeriodYears == .infinity)
    }

    @Test("Rejects occupancy above one")
    func validation() {
        #expect(
            throws:
                IndividualRiskScreeningError
                    .probabilityOutsideRange
        ) {
            try engine.calculate(
                .init(
                    scenarioFrequencyPerYear: 0.001,
                    fatalityProbabilityGivenExposure: 0.1,
                    occupancyFraction: 1.2,
                    presenceProbability: 0.5
                )
            )
        }
    }
}
