struct ExpectedMonetaryValueDecisionEngine:
    Sendable {

    func calculate(
        _ input:
            ExpectedMonetaryValueDecisionInput
    ) throws
        -> ExpectedMonetaryValueDecisionResult {

        let values = [
            input.optionAInitialCost,
            input.optionASuccessProbability,
            input.optionASuccessValue,
            input.optionAFailureValue,
            input.optionBInitialCost,
            input.optionBSuccessProbability,
            input.optionBSuccessValue,
            input.optionBFailureValue
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ExpectedMonetaryValueDecisionError
                .nonFiniteInput
        }

        guard
            input.optionAInitialCost >= 0,
            input.optionBInitialCost >= 0
        else {
            throw ExpectedMonetaryValueDecisionError
                .negativeInitialCost
        }

        guard
            input.optionASuccessProbability >= 0,
            input.optionASuccessProbability <= 1,
            input.optionBSuccessProbability >= 0,
            input.optionBSuccessProbability <= 1
        else {
            throw ExpectedMonetaryValueDecisionError
                .probabilityOutsideRange
        }

        let expectedA =
            input.optionASuccessProbability
            * input.optionASuccessValue
            + (
                1
                - input.optionASuccessProbability
            )
            * input.optionAFailureValue

        let expectedB =
            input.optionBSuccessProbability
            * input.optionBSuccessValue
            + (
                1
                - input.optionBSuccessProbability
            )
            * input.optionBFailureValue

        let netA =
            expectedA
            - input.optionAInitialCost

        let netB =
            expectedB
            - input.optionBInitialCost

        let difference =
            netA - netB

        let scale =
            max(
                1,
                abs(netA),
                abs(netB)
            )

        let tolerance =
            scale * 1e-12

        let indifferent =
            abs(difference)
            <= tolerance

        let preferred: String
        let description: String

        if indifferent {
            preferred = "Economically Indifferent"
            description =
                "The two net expected values are equal within numerical tolerance."
        } else if difference > 0 {
            preferred = "Option A"
            description =
                "Option A has the higher net expected monetary value."
        } else {
            preferred = "Option B"
            description =
                "Option B has the higher net expected monetary value."
        }

        let outputs = [
            expectedA,
            expectedB,
            netA,
            netB,
            difference
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw ExpectedMonetaryValueDecisionError
                .numericalFailure
        }

        return .init(
            optionAExpectedOutcome:
                expectedA,
            optionBExpectedOutcome:
                expectedB,
            optionANetExpectedValue:
                netA,
            optionBNetExpectedValue:
                netB,
            expectedValueDifference:
                difference,
            preferredOption:
                preferred,
            indifferenceThresholdMet:
                indifferent,
            decisionDescription:
                description,
            modelName:
                "Two-option expected monetary value decision model",
            limitationDescription:
                "Expected value does not capture risk aversion, catastrophic-tail constraints, strategic flexibility, learning, time value or nonfinancial safety and environmental obligations."
        )
    }
}
