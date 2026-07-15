struct LevenspielPlotSizingEngine:
    Sendable {

    func calculate(
        _ input:
            LevenspielPlotSizingInput
    ) throws
        -> LevenspielPlotSizingResult {

        let values = [
            input.inletMolarFlowRateA,
            input.initialConversion,
            input.finalConversion,
            input.inverseRateAtInitialConversion,
            input.inverseRateAtMidpointConversion,
            input.inverseRateAtFinalConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LevenspielPlotSizingError
                .nonFiniteInput
        }

        guard input.inletMolarFlowRateA > 0 else {
            throw LevenspielPlotSizingError
                .nonPositiveFeedRate
        }

        guard
            input.initialConversion >= 0,
            input.finalConversion <= 1,
            input.finalConversion
            > input.initialConversion
        else {
            throw LevenspielPlotSizingError
                .invalidConversionInterval
        }

        guard
            input.inverseRateAtInitialConversion > 0,
            input.inverseRateAtMidpointConversion > 0,
            input.inverseRateAtFinalConversion > 0
        else {
            throw LevenspielPlotSizingError
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

        let pfrArea =
            interval
            / 6
            * (
                input.inverseRateAtInitialConversion
                + 4
                * input.inverseRateAtMidpointConversion
                + input.inverseRateAtFinalConversion
            )

        let pfrVolume =
            input.inletMolarFlowRateA
            * pfrArea

        let cstrArea =
            interval
            * input.inverseRateAtFinalConversion

        let cstrVolume =
            input.inletMolarFlowRateA
            * cstrArea

        let ratio =
            cstrVolume / pfrVolume

        let difference =
            cstrVolume - pfrVolume

        let pfrSaving =
            100
            * (
                cstrVolume - pfrVolume
            )
            / cstrVolume

        let averageInverseRate =
            pfrArea / interval

        let comparison: String

        if cstrVolume > pfrVolume {
            comparison =
                "For the entered increasing inverse-rate profile, the PFR requires less volume than the CSTR."
        } else if cstrVolume < pfrVolume {
            comparison =
                "For the entered profile, the CSTR rectangle is smaller than the Simpson-estimated PFR area."
        } else {
            comparison =
                "The entered profile gives equal CSTR and PFR volumes over this conversion interval."
        }

        let results = [
            interval,
            midpoint,
            pfrArea,
            pfrVolume,
            cstrArea,
            cstrVolume,
            ratio,
            difference,
            pfrSaving,
            averageInverseRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            interval > 0,
            midpoint >= 0,
            midpoint <= 1,
            pfrArea > 0,
            pfrVolume > 0,
            cstrArea > 0,
            cstrVolume > 0,
            ratio > 0,
            averageInverseRate > 0
        else {
            throw LevenspielPlotSizingError
                .numericalFailure
        }

        return .init(
            conversionInterval:
                interval,
            midpointConversion:
                midpoint,
            pfrLevenspielArea:
                pfrArea,
            pfrVolume:
                pfrVolume,
            cstrLevenspielArea:
                cstrArea,
            cstrVolume:
                cstrVolume,
            cstrToPFRVolumeRatio:
                ratio,
            volumeDifference:
                difference,
            percentVolumeSavingWithPFR:
                pfrSaving,
            simpsonAverageInverseRate:
                averageInverseRate,
            comparisonDescription:
                comparison,
            modelName:
                "Three-point Simpson integration for PFR sizing and exit-rate rectangle for CSTR sizing",
            limitationDescription:
                "The PFR result uses only initial, midpoint and final inverse-rate values. Strong curvature or discontinuities require additional data and higher-resolution numerical integration."
        )
    }
}
