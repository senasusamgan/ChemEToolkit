import Foundation

struct MultipleReactionsCSTREngine:
    Sendable {

    func calculate(
        _ input:
            MultipleReactionsCSTRInput
    ) throws
        -> MultipleReactionsCSTRResult {

        let values = [
            input.inletConcentrationA,
            input.volumetricFlowRate,
            input.firstRateConstant,
            input.secondRateConstant,
            input.targetConversionA
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MultipleReactionsCSTRError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.volumetricFlowRate > 0
        else {
            throw MultipleReactionsCSTRError
                .nonPositiveConcentrationOrFlow
        }

        guard
            input.firstRateConstant > 0,
            input.secondRateConstant > 0
        else {
            throw MultipleReactionsCSTRError
                .nonPositiveRateConstant
        }

        guard
            input.targetConversionA > 0,
            input.targetConversionA < 1
        else {
            throw MultipleReactionsCSTRError
                .conversionOutOfRange
        }

        let spaceTime =
            input.targetConversionA
            / (
                input.firstRateConstant
                * (
                    1 - input.targetConversionA
                )
            )

        let volume =
            input.volumetricFlowRate
            * spaceTime

        let concentrationA =
            input.inletConcentrationA
            / (
                1
                + input.firstRateConstant
                * spaceTime
            )

        let concentrationB =
            input.firstRateConstant
            * spaceTime
            * concentrationA
            / (
                1
                + input.secondRateConstant
                * spaceTime
            )

        let concentrationC =
            max(
                0,
                input.inletConcentrationA
                - concentrationA
                - concentrationB
            )

        let reactedA =
            input.inletConcentrationA
            - concentrationA

        let yieldB =
            concentrationB
            / input.inletConcentrationA

        let fractionReactedToB =
            reactedA > 0
            ? concentrationB / reactedA
            : 0

        let selectivity =
            concentrationC > 0
            ? concentrationB
                / concentrationC
            : .infinity

        let optimumSpaceTime =
            1
            / (
                input.firstRateConstant
                * input.secondRateConstant
            ).squareRoot()

        let optimumB =
            input.inletConcentrationA
            * input.firstRateConstant
            * optimumSpaceTime
            / (
                (
                    1
                    + input.firstRateConstant
                    * optimumSpaceTime
                )
                * (
                    1
                    + input.secondRateConstant
                    * optimumSpaceTime
                )
            )

        let finiteResults = [
            spaceTime,
            volume,
            concentrationA,
            concentrationB,
            concentrationC,
            yieldB,
            fractionReactedToB,
            optimumSpaceTime,
            optimumB
        ]

        guard
            finiteResults.allSatisfy(\.isFinite),
            spaceTime > 0,
            volume > 0,
            concentrationA >= 0,
            concentrationB >= 0,
            concentrationC >= 0,
            yieldB >= 0,
            yieldB <= 1,
            fractionReactedToB >= 0,
            fractionReactedToB <= 1,
            optimumSpaceTime > 0,
            optimumB >= 0
        else {
            throw MultipleReactionsCSTRError
                .numericalFailure
        }

        return .init(
            requiredSpaceTime:
                spaceTime,
            requiredReactorVolume:
                volume,
            outletConcentrationA:
                concentrationA,
            outletConcentrationB:
                concentrationB,
            outletConcentrationC:
                concentrationC,
            yieldOfB:
                yieldB,
            selectivityBToC:
                selectivity,
            fractionOfReactedAEndingAsB:
                fractionReactedToB,
            theoreticalSpaceTimeForMaximumB:
                optimumSpaceTime,
            theoreticalMaximumBConcentration:
                optimumB,
            modelName:
                "Steady CSTR for consecutive first-order reactions A → B → C",
            limitationDescription:
                "Assumes perfect mixing, constant density, one ideal CSTR and irreversible first-order steps. B is the desired intermediate product."
        )
    }
}
