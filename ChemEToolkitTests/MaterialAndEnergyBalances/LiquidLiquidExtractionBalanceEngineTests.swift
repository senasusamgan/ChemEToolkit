import Testing
@testable import ChemEToolkit

@Suite("Liquid-Liquid Extraction Balance Engine")
struct LiquidLiquidExtractionBalanceEngineTests {
    private let engine =
        LiquidLiquidExtractionBalanceEngine()

    @Test("Calculates single-stage extraction")
    func extraction() throws {
        let result = try engine.calculate(
            .init(
                feedSolutionMass: 100,
                feedSoluteMassFraction: 0.10,
                pureSolventMass: 50,
                distributionCoefficient: 2
            )
        )

        let expectedRaffinateRatio =
            10.0 / (90 + 2 * 50)

        let expectedRaffinateSolute =
            expectedRaffinateRatio * 90

        let expectedExtractSolute =
            10 - expectedRaffinateSolute

        #expect(result.feedCarrierMass == 90)
        #expect(result.initialSoluteMass == 10)

        #expect(
            abs(
                result.raffinateSoluteMass
                - expectedRaffinateSolute
            ) < 1e-12
        )

        #expect(
            abs(
                result.extractSoluteMass
                - expectedExtractSolute
            ) < 1e-12
        )
    }

    @Test("Zero solvent gives zero extraction")
    func noSolvent() throws {
        let result = try engine.calculate(
            .init(
                feedSolutionMass: 100,
                feedSoluteMassFraction: 0.10,
                pureSolventMass: 0,
                distributionCoefficient: 2
            )
        )

        #expect(result.extractSoluteMass == 0)
        #expect(result.extractionFraction == 0)
    }

    @Test("Rejects negative distribution coefficient")
    func validation() {
        #expect(
            throws:
                LiquidLiquidExtractionBalanceError
                    .negativeDistributionCoefficient
        ) {
            try engine.calculate(
                .init(
                    feedSolutionMass: 100,
                    feedSoluteMassFraction: 0.10,
                    pureSolventMass: 50,
                    distributionCoefficient: -1
                )
            )
        }
    }
}
