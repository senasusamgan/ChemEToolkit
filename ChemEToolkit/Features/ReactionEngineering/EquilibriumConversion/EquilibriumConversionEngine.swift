struct EquilibriumConversionEngine:
    Sendable {

    private let directionTolerance =
        1.0e-12

    func calculate(
        _ input:
            EquilibriumConversionInput
    ) throws
        -> EquilibriumConversionResult {

        let values = [
            input.initialConcentrationA,
            input.initialConcentrationB,
            input.equilibriumConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EquilibriumConversionError
                .nonFiniteInput
        }

        guard
            input.initialConcentrationA >= 0,
            input.initialConcentrationB >= 0
        else {
            throw EquilibriumConversionError
                .negativeInitialConcentration
        }

        let totalConcentration =
            input.initialConcentrationA
            + input.initialConcentrationB

        guard totalConcentration > 0 else {
            throw EquilibriumConversionError
                .zeroTotalConcentration
        }

        guard input.equilibriumConstant > 0 else {
            throw EquilibriumConversionError
                .nonPositiveEquilibriumConstant
        }

        let equilibriumA =
            totalConcentration
            / (
                1
                + input.equilibriumConstant
            )

        let equilibriumB =
            totalConcentration
            - equilibriumA

        let signedExtent =
            equilibriumB
            - input.initialConcentrationB

        let signedExtentFraction =
            signedExtent
            / totalConcentration

        let forwardConversion =
            signedExtent > 0
            && input.initialConcentrationA > 0
            ? signedExtent
                / input.initialConcentrationA
            : 0

        let reverseConversion =
            signedExtent < 0
            && input.initialConcentrationB > 0
            ? -signedExtent
                / input.initialConcentrationB
            : 0

        let initialQuotient =
            input.initialConcentrationA > 0
            ? input.initialConcentrationB
                / input.initialConcentrationA
            : .infinity

        let equilibriumQuotient =
            equilibriumB / equilibriumA

        let tolerance =
            directionTolerance
            * max(
                1,
                totalConcentration
            )

        let direction: String

        if abs(signedExtent) <= tolerance {
            direction =
                "The initial composition is already at equilibrium."
        } else if signedExtent > 0 {
            direction =
                "Net reaction proceeds from A toward B."
        } else {
            direction =
                "Net reaction proceeds from B toward A."
        }

        let finiteResults = [
            totalConcentration,
            equilibriumA,
            equilibriumB,
            signedExtent,
            signedExtentFraction,
            forwardConversion,
            reverseConversion,
            equilibriumQuotient
        ]

        guard
            finiteResults.allSatisfy(\.isFinite),
            totalConcentration > 0,
            equilibriumA > 0,
            equilibriumB > 0,
            forwardConversion >= 0,
            forwardConversion <= 1,
            reverseConversion >= 0,
            reverseConversion <= 1,
            equilibriumQuotient > 0
        else {
            throw EquilibriumConversionError
                .numericalFailure
        }

        return .init(
            totalConcentration:
                totalConcentration,
            equilibriumConcentrationA:
                equilibriumA,
            equilibriumConcentrationB:
                equilibriumB,
            signedExtentConcentration:
                signedExtent,
            signedExtentFractionOfTotal:
                signedExtentFraction,
            forwardConversionOfInitialA:
                forwardConversion,
            reverseConversionOfInitialB:
                reverseConversion,
            initialReactionQuotient:
                initialQuotient,
            equilibriumReactionQuotient:
                equilibriumQuotient,
            directionDescription:
                direction,
            modelName:
                "Constant-volume 1:1 equilibrium for A ⇌ B with K_c = C_B/C_A",
            limitationDescription:
                "Assumes ideal behavior, one independent 1:1 reaction, constant volume and an equilibrium constant defined on the concentration ratio C_B/C_A."
        )
    }
}
