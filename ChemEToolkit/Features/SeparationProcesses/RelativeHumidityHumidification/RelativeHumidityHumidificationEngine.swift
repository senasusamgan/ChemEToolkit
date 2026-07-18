import Foundation

struct RelativeHumidityHumidificationEngine:
    Sendable {

    func calculate(
        _ input:
            RelativeHumidityHumidificationInput
    ) throws
        -> RelativeHumidityHumidificationResult {

        let values = [
            input.dryAirMassFlow,
            input.dryBulbTemperatureC,
            input.totalPressureKPa,
            input.inletRelativeHumidityPercent,
            input.outletRelativeHumidityPercent
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RelativeHumidityHumidificationError
                .nonFiniteInput
        }

        guard
            input.dryAirMassFlow > 0,
            input.totalPressureKPa > 0
        else {
            throw RelativeHumidityHumidificationError
                .nonPositiveFlowOrPressure
        }

        guard
            input.inletRelativeHumidityPercent > 0,
            input.inletRelativeHumidityPercent < 100,
            input.outletRelativeHumidityPercent > 0,
            input.outletRelativeHumidityPercent < 100
        else {
            throw RelativeHumidityHumidificationError
                .invalidRelativeHumidity
        }

        guard
            input.outletRelativeHumidityPercent
            > input.inletRelativeHumidityPercent
        else {
            throw RelativeHumidityHumidificationError
                .outletBelowInlet
        }

        let saturationPressure =
            0.61094
            * Foundation.exp(
                17.625
                * input.dryBulbTemperatureC
                / (
                    input.dryBulbTemperatureC
                    + 243.04
                )
            )

        let inletVaporPressure =
            saturationPressure
            * input.inletRelativeHumidityPercent
            / 100

        let outletVaporPressure =
            saturationPressure
            * input.outletRelativeHumidityPercent
            / 100

        guard
            inletVaporPressure
                < input.totalPressureKPa,
            outletVaporPressure
                < input.totalPressureKPa
        else {
            throw RelativeHumidityHumidificationError
                .vaporPressureNotBelowTotal
        }

        func humidityRatio(
            vaporPressure: Double
        ) -> Double {
            0.62198
            * vaporPressure
            / (
                input.totalPressureKPa
                - vaporPressure
            )
        }

        let inletHumidity =
            humidityRatio(
                vaporPressure:
                    inletVaporPressure
            )

        let outletHumidity =
            humidityRatio(
                vaporPressure:
                    outletVaporPressure
            )

        let increase =
            outletHumidity
            - inletHumidity

        let waterFlow =
            input.dryAirMassFlow
            * increase

        let outputs = [
            saturationPressure,
            inletHumidity,
            outletHumidity,
            increase,
            waterFlow
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            increase > 0,
            waterFlow > 0
        else {
            throw RelativeHumidityHumidificationError
                .numericalFailure
        }

        return .init(
            saturationPressureKPa:
                saturationPressure,
            inletHumidityRatio:
                inletHumidity,
            outletHumidityRatio:
                outletHumidity,
            requiredWaterFlow:
                waterFlow,
            humidityRatioIncrease:
                increase,
            modelName:
                "Isothermal ideal-air humidification",
            limitationDescription:
                "Assumes constant dry-bulb temperature and pressure while relative humidity increases."
        )
    }
}
