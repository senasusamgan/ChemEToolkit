import Foundation

struct PressureProcessDynamicsEngine: Sendable {
    private let gasConstant = 8.31446261815324

    func calculate(
        _ input: PressureProcessDynamicsInput
    ) throws -> PressureProcessDynamicsResult {

        let values = [
            input.vesselVolume,
            input.gasTemperature,
            input.pressureFlowResistance,
            input.initialPressure,
            input.molarInflowStepChange,
            input.evaluationTime,
            input.maximumAllowablePressure
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PressureProcessDynamicsError.nonFiniteInput
        }

        guard
            input.vesselVolume > 0,
            input.gasTemperature > 0,
            input.pressureFlowResistance > 0
        else {
            throw PressureProcessDynamicsError.nonPositiveVesselProperty
        }

        guard
            input.initialPressure > 0,
            input.maximumAllowablePressure > input.initialPressure
        else {
            throw PressureProcessDynamicsError.invalidPressureLimit
        }

        guard input.evaluationTime >= 0 else {
            throw PressureProcessDynamicsError.negativeEvaluationTime
        }

        let capacitance =
            input.vesselVolume
            / (
                gasConstant
                * input.gasTemperature
            )

        let timeConstant =
            capacitance
            * input.pressureFlowResistance

        let finalPressureChange =
            input.pressureFlowResistance
            * input.molarInflowStepChange

        let finalPressure =
            input.initialPressure
            + finalPressureChange

        guard finalPressure > 0 else {
            throw PressureProcessDynamicsError.nonPhysicalSteadyPressure
        }

        let fraction =
            1
            - exp(
                -input.evaluationTime
                / timeConstant
            )

        let pressure =
            input.initialPressure
            + finalPressureChange
            * fraction

        let initialRate =
            input.molarInflowStepChange
            / capacitance

        let margin =
            input.maximumAllowablePressure
            - pressure

        let results = [
            capacitance,
            timeConstant,
            input.pressureFlowResistance,
            pressure,
            finalPressure,
            initialRate,
            fraction,
            margin
        ]

        guard
            results.allSatisfy(\.isFinite),
            capacitance > 0,
            timeConstant > 0,
            pressure > 0,
            fraction >= 0,
            fraction <= 1
        else {
            throw PressureProcessDynamicsError.numericalFailure
        }

        return .init(
            gasCapacitance: capacitance,
            processTimeConstant: timeConstant,
            processGain: input.pressureFlowResistance,
            pressureAtEvaluationTime: pressure,
            finalSteadyPressure: finalPressure,
            initialPressureRate: initialRate,
            fractionOfFinalChange: fraction,
            overpressureRisk:
                finalPressure
                > input.maximumAllowablePressure,
            availablePressureMargin: margin,
            modelName:
                "Isothermal ideal-gas pressure process: C_p dP/dt = Δṅ_in − ΔP/R_p",
            limitationDescription:
                "Uses a linear outlet-flow resistance and constant vessel volume and temperature. Compressibility changes, nonideal gas behavior, choked flow and relief-device action are not modeled."
        )
    }
}
