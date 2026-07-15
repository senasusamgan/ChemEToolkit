import Testing
@testable import ChemEToolkit

@Suite(
    "Distribution Coefficient and Selectivity Engine"
)
struct DistributionCoefficientSelectivityEngineTests {
    private let engine =
        DistributionCoefficientSelectivityEngine()

    @Test(
        "Calculates distribution coefficients and separation factor"
    )
    func calculatesSelectivity() throws {
        let result = try engine.calculate(
            .init(
                raffinateSoluteConcentration:
                    0.1,
                extractSoluteConcentration:
                    0.4,
                raffinateImpurityConcentration:
                    0.2,
                extractImpurityConcentration:
                    0.1
            )
        )

        #expect(
            result.soluteDistributionCoefficient
            == 4
        )
        #expect(
            result.impurityDistributionCoefficient
            == 0.5
        )
        #expect(
            result.separationFactor == 8
        )
    }

    @Test(
        "Identifies the unity-selectivity boundary"
    )
    func unitySelectivity() throws {
        let result = try engine.calculate(
            .init(
                raffinateSoluteConcentration:
                    0.2,
                extractSoluteConcentration:
                    0.4,
                raffinateImpurityConcentration:
                    0.1,
                extractImpurityConcentration:
                    0.2
            )
        )

        #expect(
            result.separationFactor == 1
        )
        #expect(
            result.selectivityDescription
                .contains("does not")
        )
    }

    @Test(
        "Rejects zero, negative and nonfinite concentrations"
    )
    func validation() {
        #expect(
            throws:
                DistributionCoefficientSelectivityError
                    .nonPositiveConcentration
        ) {
            try engine.calculate(
                .init(
                    raffinateSoluteConcentration:
                        0,
                    extractSoluteConcentration:
                        0.4,
                    raffinateImpurityConcentration:
                        0.2,
                    extractImpurityConcentration:
                        0.1
                )
            )
        }

        #expect(
            throws:
                DistributionCoefficientSelectivityError
                    .nonPositiveConcentration
        ) {
            try engine.calculate(
                .init(
                    raffinateSoluteConcentration:
                        0.1,
                    extractSoluteConcentration:
                        -0.4,
                    raffinateImpurityConcentration:
                        0.2,
                    extractImpurityConcentration:
                        0.1
                )
            )
        }

        #expect(
            throws:
                DistributionCoefficientSelectivityError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    raffinateSoluteConcentration:
                        .nan,
                    extractSoluteConcentration:
                        0.4,
                    raffinateImpurityConcentration:
                        0.2,
                    extractImpurityConcentration:
                        0.1
                )
            )
        }
    }
}
