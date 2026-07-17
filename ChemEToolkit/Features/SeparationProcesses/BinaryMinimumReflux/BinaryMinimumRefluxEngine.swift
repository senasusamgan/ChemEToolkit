struct BinaryMinimumRefluxEngine:
    Sendable {

    func calculate(
        _ input:
            BinaryMinimumRefluxInput
    ) throws
        -> BinaryMinimumRefluxResult {

        let values = [
            input.feedLightMoleFraction,
            input.distillateLightMoleFraction,
            input.relativeVolatility
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BinaryMinimumRefluxError
                .nonFiniteInput
        }

        let fractions = [
            input.feedLightMoleFraction,
            input.distillateLightMoleFraction
        ]

        guard
            fractions.allSatisfy({
                $0 > 0 && $0 < 1
            })
        else {
            throw BinaryMinimumRefluxError
                .fractionAtBoundary
        }

        guard
            input.distillateLightMoleFraction
            > input.feedLightMoleFraction
        else {
            throw BinaryMinimumRefluxError
                .invalidCompositionOrdering
        }

        guard input.relativeVolatility > 1 else {
            throw BinaryMinimumRefluxError
                .invalidRelativeVolatility
        }

        let xF =
            input.feedLightMoleFraction

        let yF =
            input.relativeVolatility
            * xF
            / (
                1
                + (
                    input.relativeVolatility - 1
                )
                * xF
            )

        let slope =
            (
                input.distillateLightMoleFraction
                - yF
            )
            / (
                input.distillateLightMoleFraction
                - xF
            )

        guard
            slope > 0,
            slope < 1
        else {
            throw BinaryMinimumRefluxError
                .infeasiblePinch
        }

        let minimumReflux =
            slope / (1 - slope)

        let enrichment =
            yF / xF

        let outputs = [
            yF,
            slope,
            minimumReflux,
            enrichment
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            minimumReflux > 0
        else {
            throw BinaryMinimumRefluxError
                .numericalFailure
        }

        return .init(
            equilibriumVaporAtFeed:
                yF,
            rectifyingLineMinimumSlope:
                slope,
            minimumRefluxRatio:
                minimumReflux,
            feedEquilibriumEnrichment:
                enrichment,
            pinchDescription:
                "Saturated-liquid feed pinch at x = zF",
            modelName:
                "Binary McCabe–Thiele minimum-reflux pinch estimate",
            limitationDescription:
                "Assumes a saturated-liquid feed, constant relative volatility, total condenser and binary equilibrium."
        )
    }
}
