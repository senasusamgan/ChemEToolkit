import Foundation

struct AutocatalyticBatchReactorEngine:
    Sendable {

    func calculate(
        _ input:
            AutocatalyticBatchReactorInput
    ) throws
        -> AutocatalyticBatchReactorResult {

        let values = [
            input.initialConcentrationA,
            input.initialConcentrationB,
            input.rateConstant,
            input.targetConversionA
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AutocatalyticBatchReactorError
                .nonFiniteInput
        }

        guard
            input.initialConcentrationA > 0,
            input.initialConcentrationB > 0
        else {
            throw AutocatalyticBatchReactorError
                .nonPositiveInitialConcentration
        }

        guard input.rateConstant > 0 else {
            throw AutocatalyticBatchReactorError
                .nonPositiveRateConstant
        }

        guard
            input.targetConversionA > 0,
            input.targetConversionA < 1
        else {
            throw AutocatalyticBatchReactorError
                .conversionOutOfRange
        }

        let totalReactiveConcentration =
            input.initialConcentrationA
            + input.initialConcentrationB

        let finalA =
            input.initialConcentrationA
            * (
                1 - input.targetConversionA
            )

        let finalB =
            input.initialConcentrationB
            + input.initialConcentrationA
            * input.targetConversionA

        let logarithmArgument =
            finalB
            / (
                input.initialConcentrationB
                * (
                    1 - input.targetConversionA
                )
            )

        let time =
            log(logarithmArgument)
            / (
                input.rateConstant
                * totalReactiveConcentration
            )

        let initialRate =
            input.rateConstant
            * input.initialConcentrationA
            * input.initialConcentrationB

        let finalRate =
            input.rateConstant
            * finalA
            * finalB

        let unconstrainedMaximumConversion =
            (
                input.initialConcentrationA
                - input.initialConcentrationB
            )
            / (
                2
                * input.initialConcentrationA
            )

        let maximumRateConversion =
            min(
                1,
                max(
                    0,
                    unconstrainedMaximumConversion
                )
            )

        let maximumRateA =
            input.initialConcentrationA
            * (
                1 - maximumRateConversion
            )

        let maximumRateB =
            input.initialConcentrationB
            + input.initialConcentrationA
            * maximumRateConversion

        let maximumRate =
            input.rateConstant
            * maximumRateA
            * maximumRateB

        let results = [
            time,
            finalA,
            finalB,
            initialRate,
            finalRate,
            maximumRateConversion,
            maximumRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            time > 0,
            finalA > 0,
            finalB > 0,
            initialRate > 0,
            finalRate > 0,
            maximumRateConversion >= 0,
            maximumRateConversion <= 1,
            maximumRate > 0
        else {
            throw AutocatalyticBatchReactorError
                .numericalFailure
        }

        return .init(
            timeToTargetConversion:
                time,
            finalConcentrationA:
                finalA,
            finalConcentrationB:
                finalB,
            initialReactionRate:
                initialRate,
            finalReactionRate:
                finalRate,
            conversionAtMaximumRate:
                maximumRateConversion,
            maximumReactionRate:
                maximumRate,
            targetOccursAfterRateMaximum:
                input.targetConversionA
                > maximumRateConversion,
            modelName:
                "Constant-volume autocatalytic batch reaction A + B → 2B with r = kC_A C_B",
            limitationDescription:
                "Assumes ideal mixing, constant volume and temperature, no reverse reaction and a positive initial seed concentration of autocatalyst B."
        )
    }
}
