import Foundation

struct ReversibleReactionsEngine:
    Sendable {

    private let equilibriumTolerance =
        1.0e-12

    func calculate(
        _ input:
            ReversibleReactionsInput
    ) throws
        -> ReversibleReactionsResult {

        let values = [
            input.initialConcentrationA,
            input.initialConcentrationB,
            input.forwardFirstOrderRateConstant,
            input.reverseFirstOrderRateConstant,
            input.reactionTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReversibleReactionsError
                .nonFiniteInput
        }

        guard
            input.initialConcentrationA >= 0,
            input.initialConcentrationB >= 0
        else {
            throw ReversibleReactionsError
                .negativeInitialConcentration
        }

        let totalConcentration =
            input.initialConcentrationA
            + input.initialConcentrationB

        guard totalConcentration > 0 else {
            throw ReversibleReactionsError
                .zeroTotalConcentration
        }

        guard
            input.forwardFirstOrderRateConstant
            > 0,
            input.reverseFirstOrderRateConstant
            > 0
        else {
            throw ReversibleReactionsError
                .nonPositiveRateConstant
        }

        guard input.reactionTime >= 0 else {
            throw ReversibleReactionsError
                .negativeReactionTime
        }

        let rateSum =
            input.forwardFirstOrderRateConstant
            + input.reverseFirstOrderRateConstant

        let equilibriumConstant =
            input.forwardFirstOrderRateConstant
            / input.reverseFirstOrderRateConstant

        let equilibriumA =
            totalConcentration
            * input.reverseFirstOrderRateConstant
            / rateSum

        let equilibriumB =
            totalConcentration
            * input.forwardFirstOrderRateConstant
            / rateSum

        let relaxationFactor =
            exp(
                -rateSum
                * input.reactionTime
            )

        let finalA =
            equilibriumA
            + (
                input.initialConcentrationA
                - equilibriumA
            )
            * relaxationFactor

        let finalB =
            totalConcentration
            - finalA

        let signedExtent =
            finalB
            - input.initialConcentrationB

        let signedConversion =
            input.initialConcentrationA > 0
            ? signedExtent
                / input.initialConcentrationA
            : 0

        let forwardRate =
            input.forwardFirstOrderRateConstant
            * finalA

        let reverseRate =
            input.reverseFirstOrderRateConstant
            * finalB

        let netRate =
            forwardRate
            - reverseRate

        let initialDeviation =
            abs(
                input.initialConcentrationA
                - equilibriumA
            )

        let approach: Double

        if initialDeviation
            <= equilibriumTolerance
            * max(
                1,
                totalConcentration
            ) {
            approach = 1
        } else {
            approach =
                1 - relaxationFactor
        }

        let direction: String

        if abs(signedExtent)
            <= equilibriumTolerance
            * max(
                1,
                totalConcentration
            ) {
            direction =
                "The initial composition is at equilibrium or the selected time is zero."
        } else if signedExtent > 0 {
            direction =
                "Net reaction proceeds from A toward B."
        } else {
            direction =
                "Net reaction proceeds from B toward A."
        }

        let results = [
            equilibriumConstant,
            equilibriumA,
            equilibriumB,
            finalA,
            finalB,
            signedExtent,
            signedConversion,
            forwardRate,
            reverseRate,
            netRate,
            relaxationFactor,
            approach
        ]

        guard
            results.allSatisfy(\.isFinite),
            equilibriumConstant > 0,
            equilibriumA > 0,
            equilibriumB > 0,
            finalA >= 0,
            finalB >= 0,
            forwardRate >= 0,
            reverseRate >= 0,
            relaxationFactor > 0,
            relaxationFactor <= 1,
            approach >= 0,
            approach <= 1
        else {
            throw ReversibleReactionsError
                .numericalFailure
        }

        return .init(
            equilibriumConstant:
                equilibriumConstant,
            equilibriumConcentrationA:
                equilibriumA,
            equilibriumConcentrationB:
                equilibriumB,
            finalConcentrationA:
                finalA,
            finalConcentrationB:
                finalB,
            signedExtentConcentration:
                signedExtent,
            signedConversionOfInitialA:
                signedConversion,
            finalForwardRate:
                forwardRate,
            finalReverseRate:
                reverseRate,
            finalNetRate:
                netRate,
            relaxationFactor:
                relaxationFactor,
            approachToEquilibriumFraction:
                approach,
            directionDescription:
                direction,
            modelName:
                "Constant-volume first-order reversible batch reaction A ⇌ B",
            limitationDescription:
                "Assumes isothermal ideal behavior, constant volume and first-order forward and reverse kinetics."
        )
    }
}
