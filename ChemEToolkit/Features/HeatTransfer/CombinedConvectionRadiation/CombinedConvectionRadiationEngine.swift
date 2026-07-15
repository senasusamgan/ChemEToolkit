import Foundation

struct CombinedConvectionRadiationEngine {

    private let stefanBoltzmannConstant =
        5.670374419e-8

    func calculate(
        input:
            CombinedConvectionRadiationInput
    ) throws
        -> CombinedConvectionRadiationResult {

        try validate(input)

        let convectionTemperatureDifference =
            input.surfaceTemperature
            - input.fluidTemperature

        let radiationTemperatureDifference =
            input.surfaceTemperature
            - input.surroundingsTemperature

        let convectionHeatFlux =
            input.heatTransferCoefficient
            * convectionTemperatureDifference

        let surfaceTemperatureKelvin =
            input.surfaceTemperature + 273.15

        let surroundingsTemperatureKelvin =
            input.surroundingsTemperature + 273.15

        let radiationHeatFlux =
            input.emissivity
            * stefanBoltzmannConstant
            * (
                fourthPower(
                    surfaceTemperatureKelvin
                )
                - fourthPower(
                    surroundingsTemperatureKelvin
                )
            )

        let convectionHeatTransferRate =
            convectionHeatFlux
            * input.area

        let radiationHeatTransferRate =
            radiationHeatFlux
            * input.area

        let totalHeatTransferRate =
            convectionHeatTransferRate
            + radiationHeatTransferRate

        let totalHeatFlux =
            convectionHeatFlux
            + radiationHeatFlux

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

        return CombinedConvectionRadiationResult(
            convectionHeatTransferRate:
                convectionHeatTransferRate,
            radiationHeatTransferRate:
                radiationHeatTransferRate,
            totalHeatTransferRate:
                totalHeatTransferRate,
            totalHeatTransferMagnitude:
                abs(totalHeatTransferRate),
            convectionHeatFlux:
                convectionHeatFlux,
            radiationHeatFlux:
                radiationHeatFlux,
            totalHeatFlux:
                totalHeatFlux,
            convectionTemperatureDifference:
                convectionTemperatureDifference,
            radiationTemperatureDifference:
                radiationTemperatureDifference,
            effectiveRadiationCoefficient:
                effectiveRadiationCoefficient,
            direction:
                heatFlowDirection(
                    for: totalHeatTransferRate
                ),
            dominantMode:
                dominantMode(
                    convectionRate:
                        convectionHeatTransferRate,
                    radiationRate:
                        radiationHeatTransferRate
                ),
            modesOppose:
                convectionHeatTransferRate
                * radiationHeatTransferRate < 0
        )
    }

    private func fourthPower(
        _ value: Double
    ) -> Double {

        let squared = value * value
        return squared * squared
    }

    private func heatFlowDirection(
        for totalRate: Double
    ) -> CombinedHeatFlowDirection {

        if totalRate > 0 {
            return .surfaceToEnvironment
        }

        if totalRate < 0 {
            return .environmentToSurface
        }

        return .equilibrium
    }

    private func dominantMode(
        convectionRate: Double,
        radiationRate: Double
    ) -> CombinedHeatTransferDominantMode {

        let convectionMagnitude =
            abs(convectionRate)

        let radiationMagnitude =
            abs(radiationRate)

        let scale =
            max(
                max(
                    convectionMagnitude,
                    radiationMagnitude
                ),
                1
            )

        if abs(
            convectionMagnitude
            - radiationMagnitude
        ) <= 1e-12 * scale {
            return .equal
        }

        if convectionMagnitude
            > radiationMagnitude {
            return .convection
        }

        return .radiation
    }

    private func validate(
        _ input:
            CombinedConvectionRadiationInput
    ) throws {

        let values = [
            input.heatTransferCoefficient,
            input.emissivity,
            input.area,
            input.surfaceTemperature,
            input.fluidTemperature,
            input.surroundingsTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CombinedConvectionRadiationError
                .nonFiniteInput
        }

        guard
            input.heatTransferCoefficient > 0
        else {
            throw CombinedConvectionRadiationError
                .nonPositiveHeatTransferCoefficient
        }

        guard
            input.emissivity >= 0,
            input.emissivity <= 1
        else {
            throw CombinedConvectionRadiationError
                .invalidEmissivity
        }

        guard input.area > 0 else {
            throw CombinedConvectionRadiationError
                .nonPositiveArea
        }

        guard input.surfaceTemperature >= -273.15 else {
            throw CombinedConvectionRadiationError
                .surfaceTemperatureBelowAbsoluteZero
        }

        guard input.fluidTemperature >= -273.15 else {
            throw CombinedConvectionRadiationError
                .fluidTemperatureBelowAbsoluteZero
        }

        guard input.surroundingsTemperature >= -273.15 else {
            throw CombinedConvectionRadiationError
                .surroundingsTemperatureBelowAbsoluteZero
        }
    }
}
