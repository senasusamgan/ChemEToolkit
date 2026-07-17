struct AbsorptionStrippingFactorsEngine:
    Sendable {

    func calculate(
        _ input:
            AbsorptionStrippingFactorsInput
    ) throws
        -> AbsorptionStrippingFactorsResult {

        let values = [
            input.liquidMolarFlow,
            input.gasMolarFlow,
            input.equilibriumSlope
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AbsorptionStrippingFactorsError
                .nonFiniteInput
        }

        guard
            input.liquidMolarFlow > 0,
            input.gasMolarFlow > 0
        else {
            throw AbsorptionStrippingFactorsError
                .nonPositiveFlow
        }

        guard input.equilibriumSlope > 0 else {
            throw AbsorptionStrippingFactorsError
                .nonPositiveEquilibriumSlope
        }

        let weightedGasFlow =
            input.equilibriumSlope
            * input.gasMolarFlow

        let absorptionFactor =
            input.liquidMolarFlow
            / weightedGasFlow

        let strippingFactor =
            1 / absorptionFactor

        let liquidGasRatio =
            input.liquidMolarFlow
            / input.gasMolarFlow

        let description: String

        if absorptionFactor > 1 {
            description =
                "Absorption-favorable operating ratio"
        } else if absorptionFactor < 1 {
            description =
                "Stripping-favorable operating ratio"
        } else {
            description =
                "Absorption factor equals unity"
        }

        let outputs = [
            weightedGasFlow,
            absorptionFactor,
            strippingFactor,
            liquidGasRatio
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            absorptionFactor > 0,
            strippingFactor > 0
        else {
            throw AbsorptionStrippingFactorsError
                .numericalFailure
        }

        return .init(
            absorptionFactor:
                absorptionFactor,
            strippingFactor:
                strippingFactor,
            liquidToGasRatio:
                liquidGasRatio,
            equilibriumWeightedGasFlow:
                weightedGasFlow,
            operationDescription:
                description,
            modelName:
                "Linear-equilibrium absorption and stripping factors",
            limitationDescription:
                "Uses A = L/(mG) and S = mG/L with constant molar phase flow rates."
        )
    }
}
