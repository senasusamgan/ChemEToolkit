import Foundation

struct MultipleReactionsPFREngine:
    Sendable {

    private let equalRateTolerance =
        1.0e-10

    func calculate(
        _ input:
            MultipleReactionsPFRInput
    ) throws
        -> MultipleReactionsPFRResult {

        let values = [
            input.inletConcentrationA,
            input.volumetricFlowRate,
            input.firstRateConstant,
            input.secondRateConstant,
            input.targetConversionA
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MultipleReactionsPFRError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.volumetricFlowRate > 0
        else {
            throw MultipleReactionsPFRError
                .nonPositiveConcentrationOrFlow
        }

        guard
            input.firstRateConstant > 0,
            input.secondRateConstant > 0
        else {
            throw MultipleReactionsPFRError
                .nonPositiveRateConstant
        }

        guard
            input.targetConversionA > 0,
            input.targetConversionA < 1
        else {
            throw MultipleReactionsPFRError
                .conversionOutOfRange
        }

        let spaceTime =
            -log(
                1 - input.targetConversionA
            )
            / input.firstRateConstant

        let volume =
            input.volumetricFlowRate
            * spaceTime

        let concentrationA =
            input.inletConcentrationA
            * exp(
                -input.firstRateConstant
                * spaceTime
            )

        let concentrationB: Double

        if abs(
            input.secondRateConstant
            - input.firstRateConstant
        )
        <= equalRateTolerance
        * max(
            1,
            input.firstRateConstant,
            input.secondRateConstant
        ) {
            concentrationB =
                input.inletConcentrationA
                * input.firstRateConstant
                * spaceTime
                * exp(
                    -input.firstRateConstant
                    * spaceTime
                )
        } else {
            concentrationB =
                input.inletConcentrationA
                * input.firstRateConstant
                / (
                    input.secondRateConstant
                    - input.firstRateConstant
                )
                * (
                    exp(
                        -input.firstRateConstant
                        * spaceTime
                    )
                    - exp(
                        -input.secondRateConstant
                        * spaceTime
                    )
                )
        }

        let concentrationC =
            max(
                0,
                input.inletConcentrationA
                - concentrationA
                - concentrationB
            )

        let yieldB =
            concentrationB
            / input.inletConcentrationA

        let reactedA =
            input.inletConcentrationA
            - concentrationA

        let fractionReactedToB =
            reactedA > 0
            ? concentrationB / reactedA
            : 0

        let selectivity =
            concentrationC > 0
            ? concentrationB
                / concentrationC
            : .infinity

        let peakSpaceTime: Double?
        let peakConcentration: Double?

        if abs(
            input.secondRateConstant
            - input.firstRateConstant
        )
        <= equalRateTolerance
        * max(
            1,
            input.firstRateConstant,
            input.secondRateConstant
        ) {
            let candidate =
                1 / input.firstRateConstant

            peakSpaceTime = candidate

            peakConcentration =
                input.inletConcentrationA
                / exp(1)
        } else {
            let candidate =
                log(
                    input.secondRateConstant
                    / input.firstRateConstant
                )
                / (
                    input.secondRateConstant
                    - input.firstRateConstant
                )

            peakSpaceTime =
                candidate > 0
                ? candidate
                : nil

            if candidate > 0 {
                peakConcentration =
                    input.inletConcentrationA
                    * input.firstRateConstant
                    / (
                        input.secondRateConstant
                        - input.firstRateConstant
                    )
                    * (
                        exp(
                            -input.firstRateConstant
                            * candidate
                        )
                        - exp(
                            -input.secondRateConstant
                            * candidate
                        )
                    )
            } else {
                peakConcentration = nil
            }
        }

        let finiteResults = [
            spaceTime,
            volume,
            concentrationA,
            concentrationB,
            concentrationC,
            yieldB,
            fractionReactedToB
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
            fractionReactedToB <= 1
        else {
            throw MultipleReactionsPFRError
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
            peakIntermediateSpaceTime:
                peakSpaceTime,
            peakIntermediateConcentration:
                peakConcentration,
            modelName:
                "Constant-density PFR for consecutive first-order reactions A → B → C",
            limitationDescription:
                "Assumes irreversible elementary first-order steps, constant volumetric flow and no radial gradients. B is the desired intermediate product."
        )
    }
}
