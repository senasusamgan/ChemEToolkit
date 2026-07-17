import Testing
@testable import ChemEToolkit

@Suite("Chemical Process Risk Matrix Engine")
struct ChemicalProcessRiskMatrixEngineTests {
    private let engine =
        ChemicalProcessRiskMatrixEngine()

    @Test("Calculates inherent and residual risk")
    func riskScores() throws {
        let result = try engine.calculate(
            .init(
                likelihoodRating: 4,
                severityRating: 5,
                existingSafeguardCredit: 3
            )
        )

        #expect(result.inherentRiskScore == 20)
        #expect(result.inherentRiskBand == "Critical")
        #expect(result.residualRiskScore == 17)
        #expect(result.residualRiskBand == "Critical")

        #expect(
            abs(
                result.riskReductionFraction
                - 0.15
            ) < 1e-12
        )
    }

    @Test("Risk score cannot fall below one")
    func minimumResidualRisk() throws {
        let result = try engine.calculate(
            .init(
                likelihoodRating: 1,
                severityRating: 1,
                existingSafeguardCredit: 4
            )
        )

        #expect(result.inherentRiskScore == 1)
        #expect(result.residualRiskScore == 1)
        #expect(result.residualRiskBand == "Low")
    }

    @Test("Rejects fractional likelihood rating")
    func validation() {
        #expect(
            throws:
                ChemicalProcessRiskMatrixError
                    .invalidLikelihoodRating
        ) {
            try engine.calculate(
                .init(
                    likelihoodRating: 2.5,
                    severityRating: 4,
                    existingSafeguardCredit: 1
                )
            )
        }
    }
}
