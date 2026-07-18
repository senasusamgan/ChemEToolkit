struct DryerThermalDutyEngine:
    Sendable {

    func calculate(
        _ input:
            DryerThermalDutyInput
    ) throws
        -> DryerThermalDutyResult {

        let values = [
            input.drySolidMassFlow,
            input.inletMoistureDryBasis,
            input.outletMoistureDryBasis,
            input.latentHeatOfVaporization,
            input.sensibleHeatDuty,
            input.thermalEfficiency
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DryerThermalDutyError
                .nonFiniteInput
        }

        guard input.drySolidMassFlow > 0 else {
            throw DryerThermalDutyError
                .nonPositiveDrySolidFlow
        }

        guard
            input.inletMoistureDryBasis
                > input.outletMoistureDryBasis,
            input.outletMoistureDryBasis >= 0
        else {
            throw DryerThermalDutyError
                .invalidMoistureOrdering
        }

        guard
            input.latentHeatOfVaporization > 0,
            input.sensibleHeatDuty >= 0
        else {
            throw DryerThermalDutyError
                .invalidHeatInput
        }

        guard
            input.thermalEfficiency > 0,
            input.thermalEfficiency <= 1
        else {
            throw DryerThermalDutyError
                .invalidEfficiency
        }

        let evaporatedWater =
            input.drySolidMassFlow
            * (
                input.inletMoistureDryBasis
                - input.outletMoistureDryBasis
            )

        let latentDuty =
            evaporatedWater
            * input.latentHeatOfVaporization

        let usefulDuty =
            latentDuty
            + input.sensibleHeatDuty

        let requiredInput =
            usefulDuty
            / input.thermalEfficiency

        let heatLoss =
            requiredInput
            - usefulDuty

        let outputs = [
            evaporatedWater,
            latentDuty,
            usefulDuty,
            requiredInput,
            heatLoss
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            requiredInput > 0,
            heatLoss >= 0
        else {
            throw DryerThermalDutyError
                .numericalFailure
        }

        return .init(
            evaporatedWaterFlow:
                evaporatedWater,
            latentHeatDuty:
                latentDuty,
            usefulHeatDuty:
                usefulDuty,
            requiredHeatInput:
                requiredInput,
            heatLoss:
                heatLoss,
            modelName:
                "Steady dryer thermal-duty estimate",
            limitationDescription:
                "Combines latent evaporation duty with an entered sensible duty and applies an overall thermal efficiency."
        )
    }
}
