struct MoleFractionCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            MoleFractionCalculatorInput
    ) throws
        -> MoleFractionCalculatorResult {

        let values = [
            input.componentMoles,
            input.otherMoles
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MoleFractionCalculatorError
                .nonFiniteInput
        }

        guard values.allSatisfy({ $0 >= 0 }) else {
            throw MoleFractionCalculatorError
                .negativeMoles
        }

        let total =
            input.componentMoles
            + input.otherMoles

        guard total > 0 else {
            throw MoleFractionCalculatorError
                .zeroTotalMoles
        }

        let componentFraction =
            input.componentMoles
            / total

        let otherFraction =
            input.otherMoles
            / total

        let percent =
            componentFraction
            * 100

        let results = [
            total,
            componentFraction,
            otherFraction,
            percent
        ]

        guard
            results.allSatisfy(\.isFinite),
            componentFraction >= 0,
            componentFraction <= 1,
            otherFraction >= 0,
            otherFraction <= 1
        else {
            throw MoleFractionCalculatorError
                .numericalFailure
        }

        return .init(
            totalMoles:
                total,
            componentMoleFraction:
                componentFraction,
            otherMoleFraction:
                otherFraction,
            componentMolePercent:
                percent,
            modelName:
                "Component moles divided by total moles",
            limitationDescription:
                "The second input represents the combined amount of all remaining mixture components."
        )
    }
}
