struct CatalystWeightFromRateDataEngine:
    Sendable {

    func calculate(
        _ input:
            CatalystWeightFromRateDataInput
    ) throws
        -> CatalystWeightFromRateDataResult {

        let values = [
            input.inletMolarFlowRateA,
            input.initialConversion,
            input.finalConversion,
            input.inverseRateAtInitialConversion,
            input.inverseRateAtMidpointConversion,
            input.inverseRateAtFinalConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CatalystWeightFromRateDataError
                .nonFiniteInput
        }

        guard input.inletMolarFlowRateA > 0 else {
            throw CatalystWeightFromRateDataError
                .nonPositiveFeedRate
        }

        guard
            input.initialConversion >= 0,
            input.finalConversion <= 1,
            input.finalConversion
            > input.initialConversion
        else {
            throw CatalystWeightFromRateDataError
                .invalidConversionInterval
        }

        guard
            input.inverseRateAtInitialConversion > 0,
            input.inverseRateAtMidpointConversion > 0,
            input.inverseRateAtFinalConversion > 0
        else {
            throw CatalystWeightFromRateDataError
                .nonPositiveInverseRate
        }

        let interval =
            input.finalConversion
            - input.initialConversion

        let midpoint =
            0.5
            * (
                input.initialConversion
                + input.finalConversion
            )

        let area =
            interval
            / 6
            * (
                input.inverseRateAtInitialConversion
                + 4
                * input.inverseRateAtMidpointConversion
                + input.inverseRateAtFinalConversion
            )

        let catalystWeight =
            input.inletMolarFlowRateA
            * area

        let averageInverseRate =
            area / interval

        let averageRate =
            1 / averageInverseRate

        let weightPerFeedRate =
            catalystWeight
            / input.inletMolarFlowRateA

        let results = [
            interval,
            midpoint,
            area,
            catalystWeight,
            averageInverseRate,
            averageRate,
            weightPerFeedRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            interval > 0,
            midpoint >= 0,
            midpoint <= 1,
            area > 0,
            catalystWeight > 0,
            averageInverseRate > 0,
            averageRate > 0,
            weightPerFeedRate > 0
        else {
            throw CatalystWeightFromRateDataError
                .numericalFailure
        }

        return .init(
            conversionInterval:
                interval,
            midpointConversion:
                midpoint,
            catalystLevenspielArea:
                area,
            requiredCatalystWeight:
                catalystWeight,
            averageInverseRate:
                averageInverseRate,
            averageMassSpecificRate:
                averageRate,
            catalystWeightPerFeedMolarRate:
                weightPerFeedRate,
            modelName:
                "Three-point Simpson integration of W = F_A0 ∫dX/(−r′A)",
            limitationDescription:
                "The result uses only initial, midpoint and final inverse-rate values. Strong curvature or discontinuities require additional rate data."
        )
    }
}
