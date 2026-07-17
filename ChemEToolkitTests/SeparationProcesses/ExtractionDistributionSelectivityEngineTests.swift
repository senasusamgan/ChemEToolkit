import Testing
@testable import ChemEToolkit

@Suite("Extraction Distribution Selectivity Engine")
struct ExtractionDistributionSelectivityEngineTests {
    private let engine =
        ExtractionDistributionSelectivityEngine()

    @Test("Calculates distribution and extraction selectivity")
    func selectivity() throws {
        let result =
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    solventCarrierFlow: 50,
                    targetDistributionCoefficient: 4,
                    impurityDistributionCoefficient: 0.5
                )
            )

        #expect(
            abs(
                result.solventToFeedRatio
                - 0.5
            ) < 1e-12
        )

        #expect(
            abs(
                result.distributionSelectivity
                - 8
            ) < 1e-12
        )

        #expect(
            abs(
                result.targetExtractedFraction
                - (2.0 / 3.0)
            ) < 1e-12
        )

        #expect(
            abs(
                result.impurityExtractedFraction
                - 0.2
            ) < 1e-12
        )
    }

    @Test("More selective coefficient improves target preference")
    func selectivityTrend() throws {
        let low =
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    solventCarrierFlow: 50,
                    targetDistributionCoefficient: 2,
                    impurityDistributionCoefficient: 1
                )
            )

        let high =
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    solventCarrierFlow: 50,
                    targetDistributionCoefficient: 6,
                    impurityDistributionCoefficient: 0.5
                )
            )

        #expect(
            high.distributionSelectivity
            > low.distributionSelectivity
        )

        #expect(
            high.extractedFractionSelectivity
            > low.extractedFractionSelectivity
        )
    }

    @Test("Rejects zero impurity coefficient")
    func validation() {
        #expect(
            throws:
                ExtractionDistributionSelectivityError
                    .nonPositiveDistributionCoefficient
        ) {
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    solventCarrierFlow: 50,
                    targetDistributionCoefficient: 4,
                    impurityDistributionCoefficient: 0
                )
            )
        }
    }
}
