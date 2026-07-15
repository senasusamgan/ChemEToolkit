import Foundation

struct PackedBedReactorDesignEngine:
    Sendable {

    func calculate(
        _ input:
            PackedBedReactorDesignInput
    ) throws
        -> PackedBedReactorDesignResult {

        let values = [
            input.inletConcentrationA,
            input.inletVolumetricFlowRate,
            input.massSpecificFirstOrderRateConstant,
            input.targetConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PackedBedReactorDesignError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.inletVolumetricFlowRate > 0
        else {
            throw PackedBedReactorDesignError
                .nonPositiveFeed
        }

        guard
            input.massSpecificFirstOrderRateConstant
            > 0
        else {
            throw PackedBedReactorDesignError
                .nonPositiveRateConstant
        }

        guard
            input.targetConversion > 0,
            input.targetConversion < 1
        else {
            throw PackedBedReactorDesignError
                .conversionOutOfRange
        }

        let requiredWeight =
            -input.inletVolumetricFlowRate
            / input.massSpecificFirstOrderRateConstant
            * log(
                1 - input.targetConversion
            )

        let inletMolarFlow =
            input.inletConcentrationA
            * input.inletVolumetricFlowRate

        let outletMolarFlow =
            inletMolarFlow
            * (
                1 - input.targetConversion
            )

        let outletConcentration =
            input.inletConcentrationA
            * (
                1 - input.targetConversion
            )

        let catalystSpaceTime =
            requiredWeight
            / inletMolarFlow

        let exposure =
            input.massSpecificFirstOrderRateConstant
            * requiredWeight
            / input.inletVolumetricFlowRate

        let inletRate =
            input.massSpecificFirstOrderRateConstant
            * input.inletConcentrationA

        let outletRate =
            input.massSpecificFirstOrderRateConstant
            * outletConcentration

        let results = [
            requiredWeight,
            inletMolarFlow,
            outletMolarFlow,
            outletConcentration,
            catalystSpaceTime,
            exposure,
            inletRate,
            outletRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            requiredWeight > 0,
            inletMolarFlow > 0,
            outletMolarFlow > 0,
            outletConcentration > 0,
            catalystSpaceTime > 0,
            exposure > 0,
            inletRate > 0,
            outletRate > 0
        else {
            throw PackedBedReactorDesignError
                .numericalFailure
        }

        return .init(
            requiredCatalystWeight:
                requiredWeight,
            inletMolarFlowRateA:
                inletMolarFlow,
            outletMolarFlowRateA:
                outletMolarFlow,
            outletConcentrationA:
                outletConcentration,
            catalystSpaceTime:
                catalystSpaceTime,
            firstOrderExposure:
                exposure,
            inletRatePerCatalystMass:
                inletRate,
            outletRatePerCatalystMass:
                outletRate,
            modelName:
                "Isothermal constant-flow packed-bed reactor with first-order mass-specific kinetics",
            limitationDescription:
                "Assumes ideal plug flow through the catalyst bed, constant volumetric flow, no pressure drop, no diffusion limitation and a rate law −r′A = k′C_A."
        )
    }
}
