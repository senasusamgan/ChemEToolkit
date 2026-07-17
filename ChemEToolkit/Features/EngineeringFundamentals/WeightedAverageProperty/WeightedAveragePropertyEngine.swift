struct WeightedAveragePropertyEngine:
    Sendable {

    func calculate(
        _ input:
            WeightedAveragePropertyInput
    ) throws
        -> WeightedAveragePropertyResult {

        let values = [
            input.fraction1,
            input.property1,
            input.fraction2,
            input.property2,
            input.fraction3,
            input.property3
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw WeightedAveragePropertyError
                .nonFiniteInput
        }

        let fractions = [
            input.fraction1,
            input.fraction2,
            input.fraction3
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0
            })
        else {
            throw WeightedAveragePropertyError
                .negativeFraction
        }

        let sum =
            fractions.reduce(0, +)

        guard sum > 0 else {
            throw WeightedAveragePropertyError
                .zeroFractionSum
        }

        let x1 =
            input.fraction1
            / sum

        let x2 =
            input.fraction2
            / sum

        let x3 =
            input.fraction3
            / sum

        let average =
            x1 * input.property1
            + x2 * input.property2
            + x3 * input.property3

        let properties = [
            input.property1,
            input.property2,
            input.property3
        ]

        guard
            let minimum =
                properties.min(),
            let maximum =
                properties.max()
        else {
            throw WeightedAveragePropertyError
                .numericalFailure
        }

        let results = [
            sum,
            x1,
            x2,
            x3,
            average,
            minimum,
            maximum
        ]

        guard results.allSatisfy(\.isFinite) else {
            throw WeightedAveragePropertyError
                .numericalFailure
        }

        return .init(
            enteredFractionSum:
                sum,
            normalizedFraction1:
                x1,
            normalizedFraction2:
                x2,
            normalizedFraction3:
                x3,
            weightedAverageProperty:
                average,
            minimumComponentProperty:
                minimum,
            maximumComponentProperty:
                maximum,
            modelName:
                "Normalized three-component weighted average",
            limitationDescription:
                "A linear weighted average is appropriate only when the selected property and composition basis support linear mixing."
        )
    }
}
