import Foundation

struct GasLeakRateScreeningEngine:
    Sendable {

    private let universalGasConstant =
        8_314.46261815324

    func calculate(
        _ input:
            GasLeakRateScreeningInput
    ) throws
        -> GasLeakRateScreeningResult {

        let values = [
            input.upstreamAbsolutePressure,
            input.downstreamAbsolutePressure,
            input.gasTemperature,
            input.molecularWeight,
            input.heatCapacityRatio,
            input.dischargeCoefficient,
            input.orificeDiameter
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GasLeakRateScreeningError
                .nonFiniteInput
        }

        guard
            input.upstreamAbsolutePressure > 0,
            input.downstreamAbsolutePressure > 0,
            input.upstreamAbsolutePressure
                > input.downstreamAbsolutePressure
        else {
            throw GasLeakRateScreeningError
                .invalidPressure
        }

        guard input.gasTemperature > 0 else {
            throw GasLeakRateScreeningError
                .nonPositiveTemperature
        }

        guard input.molecularWeight > 0 else {
            throw GasLeakRateScreeningError
                .nonPositiveMolecularWeight
        }

        guard input.heatCapacityRatio > 1 else {
            throw GasLeakRateScreeningError
                .invalidHeatCapacityRatio
        }

        guard
            input.dischargeCoefficient > 0,
            input.dischargeCoefficient <= 1
        else {
            throw GasLeakRateScreeningError
                .invalidDischargeCoefficient
        }

        guard input.orificeDiameter > 0 else {
            throw GasLeakRateScreeningError
                .nonPositiveOrificeDiameter
        }

        let area =
            Double.pi
            * input.orificeDiameter
            * input.orificeDiameter
            / 4

        let specificGasConstant =
            universalGasConstant
            / input.molecularWeight

        let upstreamDensity =
            input.upstreamAbsolutePressure
            / (
                specificGasConstant
                * input.gasTemperature
            )

        let gamma =
            input.heatCapacityRatio

        let pressureRatio =
            input.downstreamAbsolutePressure
            / input.upstreamAbsolutePressure

        let criticalRatio =
            pow(
                2 / (gamma + 1),
                gamma / (gamma - 1)
            )

        let isChoked =
            pressureRatio
            <= criticalRatio

        let massFlux:
            Double

        if isChoked {
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
                        * input.gasTemperature
                    )
                )
                * criticalTerm
        } else {
            let bracket =
                pow(
                    pressureRatio,
                    2 / gamma
                )
                - pow(
                    pressureRatio,
                    (gamma + 1) / gamma
                )

            guard bracket > 0 else {
                throw GasLeakRateScreeningError
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
                        * input.gasTemperature
                        * (gamma - 1)
                    )
                    * bracket
                )
        }

        let massRate =
            massFlux
            * area

        let volumetricRate =
            massRate
            / upstreamDensity

        let description =
            isChoked
            ? "Choked gas release: the ideal-gas mass flux is controlled by upstream conditions."
            : "Subcritical gas release: both upstream and downstream pressures affect mass flux."

        let results = [
            area,
            specificGasConstant,
            upstreamDensity,
            pressureRatio,
            criticalRatio,
            massFlux,
            massRate,
            volumetricRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            area > 0,
            specificGasConstant > 0,
            upstreamDensity > 0,
            massFlux > 0,
            massRate > 0,
            volumetricRate > 0
        else {
            throw GasLeakRateScreeningError
                .numericalFailure
        }

        return .init(
            orificeArea:
                area,
            specificGasConstant:
                specificGasConstant,
            upstreamGasDensity:
                upstreamDensity,
            pressureRatio:
                pressureRatio,
            criticalPressureRatio:
                criticalRatio,
            flowIsChoked:
                isChoked,
            massFlux:
                massFlux,
            massReleaseRate:
                massRate,
            upstreamVolumetricReleaseRate:
                volumetricRate,
            flowRegimeDescription:
                description,
            modelName:
                "Ideal-gas isentropic leak-through-orifice screening",
            limitationDescription:
                "Assumes steady ideal-gas flow through a sharp effective orifice. Inventory depressurization, real-gas behavior, flashing, two-phase flow, heat transfer and piping resistance are excluded."
        )
    }
}
