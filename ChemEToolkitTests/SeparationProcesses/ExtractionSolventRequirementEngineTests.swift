import Testing
@testable import ChemEToolkit

@Suite("Extraction Solvent Requirement Engine")
struct ExtractionSolventRequirementEngineTests {
    private let engine =
        ExtractionSolventRequirementEngine()

    @Test("Calculates solvent for target removal")
    func requirement() throws {
        let result = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                feedSoluteFraction: 0.10,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.80
            )
        )

        #expect(
            abs(
                result.extractionFactor
                - 4
            ) < 1e-12
        )

        #expect(
            abs(
                result.solventToFeedRatio
                - 2
            ) < 1e-12
        )

        #expect(
            abs(
                result.requiredSolventFlow
                - 200
            ) < 1e-12
        )

        #expect(
            abs(
                result.soluteExtractedFlow
                - 8
            ) < 1e-12
        )
    }

    @Test("Higher distribution coefficient lowers solvent demand")
    func coefficientTrend() throws {
        let low = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                feedSoluteFraction: 0.10,
                distributionCoefficient: 1,
                targetRemovalFraction: 0.80
            )
        )

        let high = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                feedSoluteFraction: 0.10,
                distributionCoefficient: 4,
                targetRemovalFraction: 0.80
            )
        )

        #expect(
            high.requiredSolventFlow
            < low.requiredSolventFlow
        )
    }

    @Test("Rejects complete-removal target")
    func validation() {
        #expect(
            throws:
                ExtractionSolventRequirementError
                    .invalidRemovalFraction
        ) {
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    feedSoluteFraction: 0.10,
                    distributionCoefficient: 2,
                    targetRemovalFraction: 1
                )
            )
        }
    }
}
