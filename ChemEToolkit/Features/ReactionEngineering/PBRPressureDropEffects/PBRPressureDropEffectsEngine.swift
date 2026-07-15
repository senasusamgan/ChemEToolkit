import Foundation

struct PBRPressureDropEffectsEngine:
    Sendable {

    private let zeroParameterTolerance =
        1.0e-14

    func calculate(
        _ input:
            PBRPressureDropEffectsInput
    ) throws
        -> PBRPressureDropEffectsResult {

        let values = [
            input.catalystWeight,
            input.inletMolarFlowRateA,
            input.inletConcentrationA,
            input.massSpecificFirstOrderRateConstant,
            input.pressureDropParameter,
            input.inletPressure
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PBRPressureDropEffectsError
                .nonFiniteInput
        }

        guard
            input.catalystWeight > 0,
            input.inletMolarFlowRateA > 0,
            input.inletConcentrationA > 0
        else {
            throw PBRPressureDropEffectsError
                .nonPositiveCatalystOrFeed
        }

        guard
            input.massSpecificFirstOrderRateConstant
            > 0,
            input.inletPressure > 0
        else {
            throw PBRPressureDropEffectsError
                .nonPositiveRateConstantOrPressure
        }

        guard input.pressureDropParameter >= 0 else {
            throw PBRPressureDropEffectsError
                .negativePressureDropParameter
        }

        let alphaWeight =
            input.pressureDropParameter
            * input.catalystWeight

        guard alphaWeight < 1 else {
            throw PBRPressureDropEffectsError
                .pressureCollapse
        }

        let pressureRatio =
            sqrt(
                1 - alphaWeight
            )

        let effectiveExposure: Double

        if input.pressureDropParameter
            <= zeroParameterTolerance {
            effectiveExposure =
                input.catalystWeight
        } else {
            effectiveExposure =
                2
                / (
                    3
                    * input.pressureDropParameter
                )
                * (
                    1
                    - pow(
                        1 - alphaWeight,
                        1.5
                    )
                )
        }

        let kineticCoefficient =
            input.massSpecificFirstOrderRateConstant
            * input.inletConcentrationA
            / input.inletMolarFlowRateA

        let conversionWithDrop =
            1
            - exp(
                -kineticCoefficient
                * effectiveExposure
            )

        let conversionWithoutDrop =
            1
            - exp(
                -kineticCoefficient
                * input.catalystWeight
            )

        let penalty =
            max(
                0,
                conversionWithoutDrop
                - conversionWithDrop
            )

        let outletPressure =
            input.inletPressure
            * pressureRatio

        let pressureDrop =
            input.inletPressure
            - outletPressure

        let pressureDropFraction =
            pressureDrop
            / input.inletPressure

        let outletMolarFlow =
            input.inletMolarFlowRateA
            * (
                1 - conversionWithDrop
            )

        let results = [
            pressureRatio,
            outletPressure,
            pressureDrop,
            pressureDropFraction,
            effectiveExposure,
            kineticCoefficient,
            conversionWithDrop,
            conversionWithoutDrop,
            penalty,
            outletMolarFlow
        ]

        guard
            results.allSatisfy(\.isFinite),
            pressureRatio > 0,
            pressureRatio <= 1,
            outletPressure > 0,
            pressureDrop >= 0,
            pressureDropFraction >= 0,
            pressureDropFraction < 1,
            effectiveExposure > 0,
            kineticCoefficient > 0,
            conversionWithDrop > 0,
            conversionWithDrop < 1,
            conversionWithoutDrop > 0,
            conversionWithoutDrop < 1,
            penalty >= 0,
            outletMolarFlow > 0
        else {
            throw PBRPressureDropEffectsError
                .numericalFailure
        }

        return .init(
            outletPressureRatio:
                pressureRatio,
            outletPressure:
                outletPressure,
            pressureDrop:
                pressureDrop,
            pressureDropFraction:
                pressureDropFraction,
            effectiveCatalystExposure:
                effectiveExposure,
            kineticCoefficientPerCatalystMass:
                kineticCoefficient,
            conversionWithPressureDrop:
                conversionWithDrop,
            conversionWithoutPressureDrop:
                conversionWithoutDrop,
            conversionPenalty:
                penalty,
            outletMolarFlowRateA:
                outletMolarFlow,
            modelName:
                "Simplified isothermal gas-phase PBR with y = √(1 − αW) and first-order pressure-dependent rate",
            limitationDescription:
                "Assumes constant total molar flow, ideal-gas concentration proportional to pressure, no temperature change and a lumped pressure-drop parameter. It is not a substitute for coupled Ergun and mole-balance integration."
        )
    }
}
