import Foundation

struct TemperatureProcessDynamicsEngine:
    Sendable {

    func calculate(
        _ input:
            TemperatureProcessDynamicsInput
    ) throws
        -> TemperatureProcessDynamicsResult {

        let values = [
            input.liquidVolume,
            input.liquidDensity,
            input.specificHeatCapacity,
            input.volumetricFlowRate,
            input.overallHeatTransferConductance,
            input.inletTemperature,
            input.environmentTemperature,
            input.initialTemperature,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw TemperatureProcessDynamicsError
                .nonFiniteInput
        }

        guard
            input.liquidVolume > 0,
            input.liquidDensity > 0,
            input.specificHeatCapacity > 0
        else {
            throw TemperatureProcessDynamicsError
                .nonPositiveThermalProperty
        }

        guard
            input.volumetricFlowRate >= 0,
            input.overallHeatTransferConductance >= 0,
            input.volumetricFlowRate > 0
            || input.overallHeatTransferConductance > 0
        else {
            throw TemperatureProcessDynamicsError
                .invalidTransportParameter
        }

        guard
            input.inletTemperature > 0,
            input.environmentTemperature > 0,
            input.initialTemperature > 0
        else {
            throw TemperatureProcessDynamicsError
                .nonPhysicalTemperature
        }

        guard input.evaluationTime >= 0 else {
            throw TemperatureProcessDynamicsError
                .negativeEvaluationTime
        }

        let capacitance =
            input.liquidDensity
            * input.liquidVolume
            * input.specificHeatCapacity

        let flowCapacityRate =
            input.liquidDensity
            * input.volumetricFlowRate
            * input.specificHeatCapacity

        let conductance =
            input.overallHeatTransferConductance

        let totalConductance =
            flowCapacityRate
            + conductance

        let timeConstant =
            capacitance
            / totalConductance

        let finalTemperature =
            (
                flowCapacityRate
                * input.inletTemperature
                + conductance
                * input.environmentTemperature
            )
            / totalConductance

        let decay =
            exp(
                -input.evaluationTime
                / timeConstant
            )

        let temperature =
            finalTemperature
            + (
                input.initialTemperature
                - finalTemperature
            )
            * decay

        let flowHeatRate =
            flowCapacityRate
            * (
                input.inletTemperature
                - temperature
            )

        let environmentHeatRate =
            conductance
            * (
                input.environmentTemperature
                - temperature
            )

        let netHeatRate =
            flowHeatRate
            + environmentHeatRate

        let completed =
            1 - decay

        let results = [
            capacitance,
            flowCapacityRate,
            conductance,
            timeConstant,
            finalTemperature,
            temperature,
            flowHeatRate,
            environmentHeatRate,
            netHeatRate,
            completed
        ]

        guard
            results.allSatisfy(\.isFinite),
            capacitance > 0,
            totalConductance > 0,
            timeConstant > 0,
            finalTemperature > 0,
            temperature > 0,
            completed >= 0,
            completed <= 1
        else {
            throw TemperatureProcessDynamicsError
                .numericalFailure
        }

        return .init(
            thermalCapacitance:
                capacitance,
            flowHeatCapacityRate:
                flowCapacityRate,
            heatTransferConductance:
                conductance,
            processTimeConstant:
                timeConstant,
            finalSteadyTemperature:
                finalTemperature,
            temperatureAtEvaluationTime:
                temperature,
            flowHeatRateAtEvaluation:
                flowHeatRate,
            environmentHeatRateAtEvaluation:
                environmentHeatRate,
            netHeatRateAtEvaluation:
                netHeatRate,
            fractionOfFinalChange:
                completed,
            modelName:
                "Well-mixed first-order thermal process with inlet flow and environmental heat exchange",
            limitationDescription:
                "Assumes constant density, heat capacity, volume, flow and UA; perfect mixing; no phase change; and no reaction heat generation."
        )
    }
}
