struct LimitingReactantExcessEngine:
    Sendable {

    func calculate(
        _ input:
            LimitingReactantExcessInput
    ) throws
        -> LimitingReactantExcessResult {

        let values = [
            input.amountA,
            input.stoichiometricCoefficientA,
            input.amountB,
            input.stoichiometricCoefficientB
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LimitingReactantExcessError
                .nonFiniteInput
        }

        guard
            input.amountA >= 0,
            input.amountB >= 0
        else {
            throw LimitingReactantExcessError
                .negativeReactantAmount
        }

        guard
            input.stoichiometricCoefficientA > 0,
            input.stoichiometricCoefficientB > 0
        else {
            throw LimitingReactantExcessError
                .nonPositiveStoichiometricCoefficient
        }

        guard
            input.amountA > 0
            || input.amountB > 0
        else {
            throw LimitingReactantExcessError
                .zeroTotalReactant
        }

        let extentA =
            input.amountA
            / input.stoichiometricCoefficientA

        let extentB =
            input.amountB
            / input.stoichiometricCoefficientB

        let extent =
            min(
                extentA,
                extentB
            )

        let consumedA =
            extent
            * input.stoichiometricCoefficientA

        let consumedB =
            extent
            * input.stoichiometricCoefficientB

        let remainingA =
            max(
                0,
                input.amountA
                - consumedA
            )

        let remainingB =
            max(
                0,
                input.amountB
                - consumedB
            )

        let tolerance = 1e-12

        let limiting: String
        let excess: String
        let percentExcess: Double

        if abs(extentA - extentB) < tolerance {
            limiting = "Stoichiometric feed"
            excess = "None"
            percentExcess = 0
        } else if extentA < extentB {
            limiting = "Reactant A"
            excess = "Reactant B"

            let requiredB =
                input.amountA
                * input.stoichiometricCoefficientB
                / input.stoichiometricCoefficientA

            percentExcess =
                requiredB > 0
                ? (
                    input.amountB
                    - requiredB
                )
                / requiredB
                * 100
                : 0
        } else {
            limiting = "Reactant B"
            excess = "Reactant A"

            let requiredA =
                input.amountB
                * input.stoichiometricCoefficientA
                / input.stoichiometricCoefficientB

            percentExcess =
                requiredA > 0
                ? (
                    input.amountA
                    - requiredA
                )
                / requiredA
                * 100
                : 0
        }

        let outputs = [
            extent,
            consumedA,
            consumedB,
            remainingA,
            remainingB,
            percentExcess
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            extent >= 0,
            consumedA >= 0,
            consumedB >= 0,
            remainingA >= 0,
            remainingB >= 0,
            percentExcess >= 0
        else {
            throw LimitingReactantExcessError
                .numericalFailure
        }

        return .init(
            limitingReactant:
                limiting,
            maximumReactionExtent:
                extent,
            amountAConsumed:
                consumedA,
            amountBConsumed:
                consumedB,
            amountARemaining:
                remainingA,
            amountBRemaining:
                remainingB,
            excessReactant:
                excess,
            percentExcess:
                percentExcess,
            modelName:
                "Two-reactant stoichiometric limiting-reactant analysis",
            limitationDescription:
                "Assumes one irreversible reaction and complete consumption of the limiting reactant at maximum extent."
        )
    }
}
