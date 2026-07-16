import Foundation

struct DeactivatingPackedBedReactorEngine:
    Sendable {

    func calculate(
        _ input:
            DeactivatingPackedBedReactorInput
    ) throws
        -> DeactivatingPackedBedReactorResult {

        let values = [
            input.inletConcentrationA,
            input.volumetricFlowRate,
            input.catalystWeight,
            input.freshCatalystRateCoefficient,
            input.deactivationRateConstant,
            input.timeOnStream,
            input.targetConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DeactivatingPackedBedReactorError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.volumetricFlowRate > 0
        else {
            throw DeactivatingPackedBedReactorError
                .nonPositiveFeedCondition
        }

        guard
            input.catalystWeight > 0,
            input.freshCatalystRateCoefficient > 0
        else {
            throw DeactivatingPackedBedReactorError
                .nonPositiveCatalystCondition
        }

        guard
            input.deactivationRateConstant > 0
        else {
            throw DeactivatingPackedBedReactorError
                .nonPositiveDeactivationRate
        }

        guard input.timeOnStream >= 0 else {
            throw DeactivatingPackedBedReactorError
                .negativeTimeOnStream
        }

        guard
            input.targetConversion > 0,
            input.targetConversion < 1
        else {
            throw DeactivatingPackedBedReactorError
                .conversionOutOfRange
        }

        let activity =
            exp(
                -input.deactivationRateConstant
                * input.timeOnStream
            )

        guard activity > 0 else {
            throw DeactivatingPackedBedReactorError
                .activityUnderflow
        }

        let freshDamkohler =
            input.freshCatalystRateCoefficient
            * input.catalystWeight
            / input.volumetricFlowRate

        let currentDamkohler =
            activity
            * freshDamkohler

        let freshConversion =
            1 - exp(-freshDamkohler)

        let currentConversion =
            1 - exp(-currentDamkohler)

        let outletConcentration =
            input.inletConcentrationA
            * (
                1 - currentConversion
            )

        let targetDamkohler =
            -log(
                1 - input.targetConversion
            )

        let requiredWeight =
            targetDamkohler
            * input.volumetricFlowRate
            / (
                input.freshCatalystRateCoefficient
                * activity
            )

        let weightMultiplier =
            requiredWeight
            / input.catalystWeight

        let conversionLoss =
            freshConversion
            - currentConversion

        let results = [
            activity,
            freshDamkohler,
            currentDamkohler,
            freshConversion,
            currentConversion,
            outletConcentration,
            requiredWeight,
            weightMultiplier,
            conversionLoss
        ]

        guard
            results.allSatisfy(\.isFinite),
            activity > 0,
            activity <= 1,
            freshDamkohler > 0,
            currentDamkohler > 0,
            freshConversion >= 0,
            freshConversion <= 1,
            currentConversion >= 0,
            currentConversion <= 1,
            outletConcentration >= 0,
            requiredWeight > 0,
            weightMultiplier > 0,
            conversionLoss >= 0
        else {
            throw DeactivatingPackedBedReactorError
                .numericalFailure
        }

        return .init(
            catalystActivity:
                activity,
            freshDamkohlerNumber:
                freshDamkohler,
            currentDamkohlerNumber:
                currentDamkohler,
            freshConversion:
                freshConversion,
            currentConversion:
                currentConversion,
            outletConcentrationA:
                outletConcentration,
            conversionLoss:
                conversionLoss,
            requiredCatalystWeightForTarget:
                requiredWeight,
            requiredWeightMultiplier:
                weightMultiplier,
            modelName:
                "Isothermal first-order packed-bed reactor with uniform first-order catalyst deactivation",
            limitationDescription:
                "Uses X = 1−exp[−a(t)k′W/Q] with a(t)=exp(−k_d t). It assumes uniform activity throughout the bed, constant density, no pressure drop and no transport limitations."
        )
    }
}
