import Foundation

struct HumidificationPsychrometricsEngine:
    Sendable {

    private let dryAirHeatCapacity =
        1.005

    private let waterVaporHeatCapacity =
        1.88

    private let referenceLatentHeat =
        2500.0

    private let waterToDryAirMolarMassRatio =
        0.62198

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input:
            HumidificationPsychrometricsInput
    ) throws
        -> HumidificationPsychrometricsResult {

        let values = [
            input.dryAirMassFlowRate,
            input.dryBulbTemperatureCelsius,
            input.totalPressureKPa,
            input.inletRelativeHumidity,
            input.outletRelativeHumidity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                HumidificationPsychrometricsError
                    .nonFiniteInput
        }

        guard input.dryAirMassFlowRate > 0 else {
            throw
                HumidificationPsychrometricsError
                    .nonPositiveDryAirFlow
        }

        guard
            (-40...60).contains(
                input.dryBulbTemperatureCelsius
            )
        else {
            throw
                HumidificationPsychrometricsError
                    .temperatureOutsideCorrelationRange
        }

        guard input.totalPressureKPa > 0 else {
            throw
                HumidificationPsychrometricsError
                    .nonPositivePressure
        }

        guard
            (0...1).contains(
                input.inletRelativeHumidity
            ),
            (0...1).contains(
                input.outletRelativeHumidity
            )
        else {
            throw
                HumidificationPsychrometricsError
                    .relativeHumidityOutOfRange
        }

        let saturationPressure =
            saturationVaporPressure(
                temperatureCelsius:
                    input.dryBulbTemperatureCelsius
            )

        guard
            input.totalPressureKPa
            > saturationPressure
            + zeroTolerance
        else {
            throw
                HumidificationPsychrometricsError
                    .pressureAtOrBelowSaturation
        }

        let inletVaporPressure =
            input.inletRelativeHumidity
            * saturationPressure

        let outletVaporPressure =
            input.outletRelativeHumidity
            * saturationPressure

        let inletHumidityRatio =
            humidityRatio(
                vaporPressureKPa:
                    inletVaporPressure,
                totalPressureKPa:
                    input.totalPressureKPa
            )

        let outletHumidityRatio =
            humidityRatio(
                vaporPressureKPa:
                    outletVaporPressure,
                totalPressureKPa:
                    input.totalPressureKPa
            )

        let saturationHumidityRatio =
            humidityRatio(
                vaporPressureKPa:
                    saturationPressure,
                totalPressureKPa:
                    input.totalPressureKPa
            )

        let signedWaterTransferRate =
            input.dryAirMassFlowRate
            * (
                outletHumidityRatio
                - inletHumidityRatio
            )

        let inletEnthalpy =
            humidEnthalpy(
                temperatureCelsius:
                    input.dryBulbTemperatureCelsius,
                humidityRatio:
                    inletHumidityRatio
            )

        let outletEnthalpy =
            humidEnthalpy(
                temperatureCelsius:
                    input.dryBulbTemperatureCelsius,
                humidityRatio:
                    outletHumidityRatio
            )

        let signedHeatDuty =
            input.dryAirMassFlowRate
            * (
                outletEnthalpy
                - inletEnthalpy
            )

        let inletDewPoint =
            dewPointCelsius(
                vaporPressureKPa:
                    inletVaporPressure
            )

        let outletDewPoint =
            dewPointCelsius(
                vaporPressureKPa:
                    outletVaporPressure
            )

        let results = [
            saturationPressure,
            inletVaporPressure,
            outletVaporPressure,
            inletHumidityRatio,
            outletHumidityRatio,
            saturationHumidityRatio,
            signedWaterTransferRate,
            inletEnthalpy,
            outletEnthalpy,
            signedHeatDuty
        ]

        guard
            results.allSatisfy(\.isFinite),
            saturationPressure > 0,
            inletHumidityRatio >= 0,
            outletHumidityRatio >= 0,
            saturationHumidityRatio > 0
        else {
            throw
                HumidificationPsychrometricsError
                    .numericalFailure
        }

        let directionDescription: String

        if abs(signedWaterTransferRate)
            <= zeroTolerance {

            directionDescription =
                "Inlet and outlet humidity states are identical; no net water transfer is required."
        } else if signedWaterTransferRate > 0 {
            directionDescription =
                "Water must be added to the dry-air stream for isothermal humidification."
        } else {
            directionDescription =
                "Water must be removed from the dry-air stream for isothermal dehumidification."
        }

        return
            HumidificationPsychrometricsResult(
                saturationVaporPressureKPa:
                    saturationPressure,
                inletVaporPressureKPa:
                    inletVaporPressure,
                outletVaporPressureKPa:
                    outletVaporPressure,
                inletHumidityRatio:
                    inletHumidityRatio,
                outletHumidityRatio:
                    outletHumidityRatio,
                saturationHumidityRatio:
                    saturationHumidityRatio,
                signedWaterTransferRate:
                    signedWaterTransferRate,
                waterTransferMagnitude:
                    abs(signedWaterTransferRate),
                inletDewPointCelsius:
                    inletDewPoint,
                outletDewPointCelsius:
                    outletDewPoint,
                inletHumidEnthalpy:
                    inletEnthalpy,
                outletHumidEnthalpy:
                    outletEnthalpy,
                signedIsothermalHeatDuty:
                    signedHeatDuty,
                directionDescription:
                    directionDescription,
                modelName:
                    "Magnus water-vapor pressure with ideal moist-air psychrometric relations"
            )
    }

    private func saturationVaporPressure(
        temperatureCelsius: Double
    ) -> Double {
        0.61094
        * exp(
            17.625
            * temperatureCelsius
            / (
                temperatureCelsius
                + 243.04
            )
        )
    }

    private func humidityRatio(
        vaporPressureKPa: Double,
        totalPressureKPa: Double
    ) -> Double {
        waterToDryAirMolarMassRatio
        * vaporPressureKPa
        / (
            totalPressureKPa
            - vaporPressureKPa
        )
    }

    private func humidEnthalpy(
        temperatureCelsius: Double,
        humidityRatio: Double
    ) -> Double {
        dryAirHeatCapacity
        * temperatureCelsius
        + humidityRatio
        * (
            referenceLatentHeat
            + waterVaporHeatCapacity
            * temperatureCelsius
        )
    }

    private func dewPointCelsius(
        vaporPressureKPa: Double
    ) -> Double? {
        guard vaporPressureKPa > 0 else {
            return nil
        }

        let logarithm =
            log(
                vaporPressureKPa
                / 0.61094
            )

        return
            243.04
            * logarithm
            / (
                17.625
                - logarithm
            )
    }
}
