struct SensibleHeatBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            SensibleHeatBalanceInput
    ) throws
        -> SensibleHeatBalanceResult {

        let values = [
            input.massFlowRate,
            input.specificHeatCapacity,
            input.inletTemperature,
            input.outletTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SensibleHeatBalanceError
                .nonFiniteInput
        }

        guard input.massFlowRate >= 0 else {
            throw SensibleHeatBalanceError
                .negativeMassFlow
        }

        guard input.specificHeatCapacity > 0 else {
            throw SensibleHeatBalanceError
                .nonPositiveHeatCapacity
        }

        let temperatureChange =
            input.outletTemperature
            - input.inletTemperature

        let specificDuty =
            input.specificHeatCapacity
            * temperatureChange

        let duty =
            input.massFlowRate
            * specificDuty

        let direction: String

        if duty > 0 {
            direction = "Heating"
        } else if duty < 0 {
            direction = "Cooling"
        } else {
            direction = "No sensible heat change"
        }

        let outputs = [
            temperatureChange,
            specificDuty,
            duty,
            abs(duty)
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw SensibleHeatBalanceError
                .numericalFailure
        }

        return .init(
            temperatureChange:
                temperatureChange,
            signedHeatDuty:
                duty,
            absoluteHeatDuty:
                abs(duty),
            heatDutyPerUnitMass:
                specificDuty,
            processDirection:
                direction,
            modelName:
                "Constant-heat-capacity sensible energy balance",
            limitationDescription:
                "Uses Q̇ = ṁCpΔT with constant Cp and no phase change, reaction, kinetic-energy or potential-energy contribution."
        )
    }
}
