struct SaturatedMixturePropertyEngine:
    Sendable {

    func calculate(
        _ input:
            SaturatedMixturePropertyInput
    ) throws
        -> SaturatedMixturePropertyResult {

        let values = [
            input.saturatedLiquidProperty,
            input.saturatedVaporProperty,
            input.vaporQuality
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SaturatedMixturePropertyError
                .nonFiniteInput
        }

        guard
            input.vaporQuality >= 0,
            input.vaporQuality <= 1
        else {
            throw SaturatedMixturePropertyError
                .fractionOutsideRange
        }

        let liquidFraction =
            1 - input.vaporQuality

        let liquidContribution =
            liquidFraction
            * input.saturatedLiquidProperty

        let vaporContribution =
            input.vaporQuality
            * input.saturatedVaporProperty

        let mixtureProperty =
            liquidContribution
            + vaporContribution

        let difference =
            input.saturatedVaporProperty
            - input.saturatedLiquidProperty

        let outputs = [
            liquidFraction,
            liquidContribution,
            vaporContribution,
            mixtureProperty,
            difference
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw SaturatedMixturePropertyError
                .numericalFailure
        }

        return .init(
            propertyDifference:
                difference,
            mixtureProperty:
                mixtureProperty,
            liquidContribution:
                liquidContribution,
            vaporContribution:
                vaporContribution,
            liquidMassFraction:
                liquidFraction,
            vaporMassFraction:
                input.vaporQuality,
            modelName:
                "Saturated-mixture linear property rule",
            limitationDescription:
                "Uses y = (1 − x)yf + xyg for a specific extensive property such as v, u, h or s at one saturation state."
        )
    }
}
