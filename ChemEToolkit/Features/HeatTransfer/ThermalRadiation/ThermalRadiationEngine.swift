import Foundation

struct ThermalRadiationEngine {

    private let stefanBoltzmannConstant =
        5.670374419e-8

    func calculate(
        input: ThermalRadiationInput
    ) throws -> ThermalRadiationResult {

        try validate(input)

        let surfaceTemperatureKelvin =
            input.surfaceTemperature + 273.15

        let surroundingsTemperatureKelvin =
            input.surroundingsTemperature + 273.15

        let surfaceTemperatureFourthPower =
            fourthPower(
                surfaceTemperatureKelvin
            )

        let surroundingsTemperatureFourthPower =
            fourthPower(
                surroundingsTemperatureKelvin
            )

        let heatFlux =
            input.emissivity
            * stefanBoltzmannConstant
            * (
                surfaceTemperatureFourthPower
                - surroundingsTemperatureFourthPower
            )

        let heatTransferRate =
            heatFlux * input.area

        let effectiveRadiationCoefficient =
            input.emissivity
            * stefanBoltzmannConstant
            * (
                surfaceTemperatureKelvin
                + surroundingsTemperatureKelvin
            )
            * (
                surfaceTemperatureKelvin
                    * surfaceTemperatureKelvin
                + surroundingsTemperatureKelvin
                    * surroundingsTemperatureKelvin
            )

        return ThermalRadiationResult(
            surfaceTemperatureKelvin:
                surfaceTemperatureKelvin,
            surroundingsTemperatureKelvin:
                surroundingsTemperatureKelvin,
            temperatureDifference:
                input.surfaceTemperature
                - input.surroundingsTemperature,
            heatTransferRate:
                heatTransferRate,
            heatTransferRateMagnitude:
                abs(heatTransferRate),
            heatFlux:
                heatFlux,
            effectiveRadiationCoefficient:
                effectiveRadiationCoefficient,
            direction:
                heatFlowDirection(
                    for: heatTransferRate
                )
        )
    }

    private func fourthPower(
        _ value: Double
    ) -> Double {

        let squared = value * value
        return squared * squared
    }

    private func heatFlowDirection(
        for heatTransferRate: Double
    ) -> RadiationHeatFlowDirection {

        if heatTransferRate > 0 {
            return .surfaceToSurroundings
        }

        if heatTransferRate < 0 {
            return .surroundingsToSurface
        }

        return .equilibrium
    }

    private func validate(
        _ input: ThermalRadiationInput
    ) throws {

        let values = [
            input.emissivity,
            input.area,
            input.surfaceTemperature,
            input.surroundingsTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ThermalRadiationError
                .nonFiniteInput
        }

        guard
            input.emissivity >= 0,
            input.emissivity <= 1
        else {
            throw ThermalRadiationError
                .invalidEmissivity
        }

        guard input.area > 0 else {
            throw ThermalRadiationError
                .nonPositiveArea
        }

        guard input.surfaceTemperature >= -273.15 else {
            throw ThermalRadiationError
                .surfaceTemperatureBelowAbsoluteZero
        }

        guard input.surroundingsTemperature >= -273.15 else {
            throw ThermalRadiationError
                .surroundingsTemperatureBelowAbsoluteZero
        }
    }
}
