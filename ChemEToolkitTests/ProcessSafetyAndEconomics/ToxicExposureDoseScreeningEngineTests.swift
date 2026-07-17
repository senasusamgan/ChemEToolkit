import Testing
@testable import ChemEToolkit

@Suite("Toxic Exposure Dose Screening Engine")
struct ToxicExposureDoseScreeningEngineTests {
    private let engine =
        ToxicExposureDoseScreeningEngine()

    @Test("Calculates concentration-time dose")
    func doseCalculation() throws {
        let result = try engine.calculate(
            .init(
                exposureConcentration: 500,
                exposureDuration: 30,
                concentrationExponent: 2,
                referenceDose: 10_000_000
            )
        )

        #expect(
            result.calculatedDose
            == 7500000
        )

        #expect(
            result.doseRatio
            == 0.75
        )

        #expect(
            result.maximumDurationAtCurrentConcentration
            == 40
        )

        #expect(
            abs(
                result.maximumConcentrationAtCurrentDuration
                - 577.35026918962569
            ) < 1e-12
        )

        #expect(!result.targetExceeded)
    }

    @Test("Detects dose above reference")
    func exceedsReference() throws {
        let result = try engine.calculate(
            .init(
                exposureConcentration: 1000,
                exposureDuration: 60,
                concentrationExponent: 2,
                referenceDose: 10_000_000
            )
        )

        #expect(result.targetExceeded)
        #expect(result.doseRatio == 6)
    }

    @Test("Rejects nonpositive exponent")
    func validation() {
        #expect(
            throws:
                ToxicExposureDoseScreeningError
                    .nonPositiveExponent
        ) {
            try engine.calculate(
                .init(
                    exposureConcentration: 500,
                    exposureDuration: 30,
                    concentrationExponent: 0,
                    referenceDose: 10_000_000
                )
            )
        }
    }
}
