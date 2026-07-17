struct BinaryRelativeVolatilityVLEEngine:
    Sendable {

    func calculate(
        _ input:
            BinaryRelativeVolatilityVLEInput
    ) throws
        -> BinaryRelativeVolatilityVLEResult {

        let values = [
            input.liquidMoleFraction,
            input.relativeVolatility
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BinaryRelativeVolatilityVLEError
                .nonFiniteInput
        }

        guard
            input.liquidMoleFraction >= 0,
            input.liquidMoleFraction <= 1
        else {
            throw BinaryRelativeVolatilityVLEError
                .fractionOutsideRange
        }

        guard input.relativeVolatility > 0 else {
            throw BinaryRelativeVolatilityVLEError
                .nonPositiveRelativeVolatility
        }

        let denominator =
            1
            + (
                input.relativeVolatility - 1
            )
            * input.liquidMoleFraction

        let vaporFraction =
            input.relativeVolatility
            * input.liquidMoleFraction
            / denominator

        let enrichment =
            input.liquidMoleFraction > 0
            ? vaporFraction
                / input.liquidMoleFraction
            : input.relativeVolatility

        let separation =
            vaporFraction
            - input.liquidMoleFraction

        let outputs = [
            denominator,
            vaporFraction,
            enrichment,
            separation
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            vaporFraction >= 0,
            vaporFraction <= 1
        else {
            throw BinaryRelativeVolatilityVLEError
                .numericalFailure
        }

        return .init(
            vaporMoleFraction:
                vaporFraction,
            equilibriumDenominator:
                denominator,
            vaporLiquidEnrichment:
                enrichment,
            equilibriumSeparation:
                separation,
            heavyComponentLiquidFraction:
                1 - input.liquidMoleFraction,
            heavyComponentVaporFraction:
                1 - vaporFraction,
            modelName:
                "Constant-relative-volatility binary VLE",
            limitationDescription:
                "Uses y = αx/[1 + (α − 1)x] with constant relative volatility and no azeotrope."
        )
    }
}
