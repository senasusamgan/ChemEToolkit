struct MassFractionCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            MassFractionCalculatorInput
    ) throws
        -> MassFractionCalculatorResult {

        let values = [
            input.componentMass,
            input.otherMass
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MassFractionCalculatorError
                .nonFiniteInput
        }

        guard values.allSatisfy({ $0 >= 0 }) else {
            throw MassFractionCalculatorError
                .negativeMass
        }

        let total =
            input.componentMass
            + input.otherMass

        guard total > 0 else {
            throw MassFractionCalculatorError
                .zeroTotalMass
        }

        let componentFraction =
            input.componentMass
            / total

        let otherFraction =
            input.otherMass
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
            throw MassFractionCalculatorError
                .numericalFailure
        }

        return .init(
            totalMass:
                total,
            componentMassFraction:
                componentFraction,
            otherMassFraction:
                otherFraction,
            componentMassPercent:
                percent,
            modelName:
                "Component mass divided by total mass",
            limitationDescription:
                "All entered mass values must use the same unit."
        )
    }
}
