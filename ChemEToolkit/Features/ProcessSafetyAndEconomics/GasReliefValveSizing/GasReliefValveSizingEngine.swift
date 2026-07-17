import Foundation

struct GasReliefValveSizingEngine:
    Sendable {

    private let universalGasConstant =
        8_314.46261815324

    func calculate(
        _ input:
            GasReliefValveSizingInput
    ) throws
        -> GasReliefValveSizingResult {

        let values = [
            input.requiredMassFlowRate,
            input.upstreamAbsolutePressure,
            input.backAbsolutePressure,
            input.relievingTemperature,
            input.molecularWeight,
            input.heatCapacityRatio,
            input.dischargeCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GasReliefValveSizingError
                .nonFiniteInput
        }

        guard input.requiredMassFlowRate > 0 else {
            throw GasReliefValveSizingError
                .nonPositiveFlowRate
        }

        guard
            input.upstreamAbsolutePressure > 0,
            input.backAbsolutePressure > 0,
            input.upstreamAbsolutePressure
                > input.backAbsolutePressure
        else {
            throw GasReliefValveSizingError
                .invalidPressure
        }

        guard input.relievingTemperature > 0 else {
            throw GasReliefValveSizingError
                .nonPositiveTemperature
        }

        guard input.molecularWeight > 0 else {
            throw GasReliefValveSizingError
                .nonPositiveMolecularWeight
        }

        guard input.heatCapacityRatio > 1 else {
            throw GasReliefValveSizingError
                .invalidHeatCapacityRatio
        }

        guard
            input.dischargeCoefficient > 0,
            input.dischargeCoefficient <= 1
        else {
            throw GasReliefValveSizingError
                .invalidDischargeCoefficient
        }

        let specificGasConstant =
            universalGasConstant
            / input.molecularWeight

        let gamma =
            input.heatCapacityRatio

        let pressureRatio =
            input.backAbsolutePressure
            / input.upstreamAbsolutePressure

        let criticalRatio =
            pow(
                2 / (gamma + 1),
                gamma / (gamma - 1)
            )

        let choked =
            pressureRatio
            <= criticalRatio

        let massFlux:
            Double

        if choked {
            let criticalTerm =
                pow(
                    2 / (gamma + 1),
                    (gamma + 1)
                    / (
                        2
                        * (gamma - 1)
                    )
                )

            massFlux =
                input.dischargeCoefficient
                * input.upstreamAbsolutePressure
                * sqrt(
                    gamma
                    / (
                        specificGasConstant
                        * input.relievingTemperature
                    )
                )
                * criticalTerm
        } else {
            let firstTerm =
                pow(
                    pressureRatio,
                    2 / gamma
                )

            let secondTerm =
                pow(
                    pressureRatio,
                    (gamma + 1) / gamma
                )

            let bracket =
                firstTerm
                - secondTerm

            guard bracket > 0 else {
                throw GasReliefValveSizingError
                    .numericalFailure
            }

            massFlux =
                input.dischargeCoefficient
                * input.upstreamAbsolutePressure
                * sqrt(
                    (
                        2
                        * gamma
                    )
                    / (
                        specificGasConstant
                        * input.relievingTemperature
                        * (gamma - 1)
                    )
                    * bracket
                )
        }

        let requiredArea =
            input.requiredMassFlowRate
            / massFlux

        let equivalentDiameter =
            sqrt(
                4
                * requiredArea
                / Double.pi
            )

        let description =
            choked
            ? "Choked flow: downstream pressure is at or below the ideal-gas critical pressure ratio."
            : "Subcritical flow: mass flux depends on both upstream and downstream pressure."

        let results = [
            specificGasConstant,
            pressureRatio,
            criticalRatio,
            massFlux,
            requiredArea,
            equivalentDiameter
        ]

        guard
            results.allSatisfy(\.isFinite),
            specificGasConstant > 0,
            pressureRatio > 0,
            criticalRatio > 0,
            criticalRatio < 1,
            massFlux > 0,
            requiredArea > 0,
            equivalentDiameter > 0
        else {
            throw GasReliefValveSizingError
                .numericalFailure
        }

        return .init(
            specificGasConstant:
                specificGasConstant,
            pressureRatio:
                pressureRatio,
            criticalPressureRatio:
                criticalRatio,
            flowIsChoked:
                choked,
            massFlux:
                massFlux,
            requiredFlowArea:
                requiredArea,
            equivalentOrificeDiameter:
                equivalentDiameter,
            flowRegimeDescription:
                description,
            modelName:
                "Ideal-gas isentropic relief-orifice screening model",
            limitationDescription:
                "This is not an API 520 certification calculation. Compressibility, two-phase flow, viscosity, piping pressure loss, backpressure corrections, certified discharge coefficients and standard orifice selection require a full code-compliant design."
        )
    }
}
