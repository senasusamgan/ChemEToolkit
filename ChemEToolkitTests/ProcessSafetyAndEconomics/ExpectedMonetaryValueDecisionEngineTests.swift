import Testing
@testable import ChemEToolkit

@Suite("Expected Monetary Value Decision Engine")
struct ExpectedMonetaryValueDecisionEngineTests {
    private let engine =
        ExpectedMonetaryValueDecisionEngine()

    @Test("Selects the higher net expected value")
    func preferredOption() throws {
        let result = try engine.calculate(
            .init(
                optionAInitialCost: 500_000,
                optionASuccessProbability: 0.7,
                optionASuccessValue: 1_500_000,
                optionAFailureValue: -200_000,
                optionBInitialCost: 300_000,
                optionBSuccessProbability: 0.5,
                optionBSuccessValue: 1_200_000,
                optionBFailureValue: 100_000
            )
        )

        #expect(result.optionAExpectedOutcome == 990_000)
        #expect(result.optionBExpectedOutcome == 650_000)
        #expect(result.optionANetExpectedValue == 490_000)
        #expect(result.optionBNetExpectedValue == 350_000)
        #expect(result.expectedValueDifference == 140_000)
        #expect(result.preferredOption == "Option A")
        #expect(!result.indifferenceThresholdMet)
    }

    @Test("Detects economically equal options")
    func equalOptions() throws {
        let result = try engine.calculate(
            .init(
                optionAInitialCost: 100,
                optionASuccessProbability: 0.5,
                optionASuccessValue: 300,
                optionAFailureValue: 100,
                optionBInitialCost: 100,
                optionBSuccessProbability: 0.5,
                optionBSuccessValue: 300,
                optionBFailureValue: 100
            )
        )

        #expect(
            result.preferredOption
            == "Economically Indifferent"
        )

        #expect(result.indifferenceThresholdMet)
    }

    @Test("Rejects invalid success probability")
    func validation() {
        #expect(
            throws:
                ExpectedMonetaryValueDecisionError
                    .probabilityOutsideRange
        ) {
            try engine.calculate(
                .init(
                    optionAInitialCost: 100,
                    optionASuccessProbability: 1.1,
                    optionASuccessValue: 300,
                    optionAFailureValue: 100,
                    optionBInitialCost: 100,
                    optionBSuccessProbability: 0.5,
                    optionBSuccessValue: 300,
                    optionBFailureValue: 100
                )
            )
        }
    }
}
