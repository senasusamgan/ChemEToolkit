import Foundation

struct PlaneWallConductionEngine {

    func calculate(
        input: PlaneWallConductionInput
    ) throws -> PlaneWallConductionResult {

        try validate(input)

        let temperatureDifference =
            input.hotSideTemperature
            - input.coldSideTemperature

        let thermalResistance =
            input.wallThickness
            / (
                input.thermalConductivity
                * input.area
            )

        let heatTransferRate =
            temperatureDifference
            / thermalResistance

        let heatFlux =
            heatTransferRate
            / input.area

        return PlaneWallConductionResult(
            heatTransferRate: heatTransferRate,
            heatFlux: heatFlux,
            thermalResistance: thermalResistance,
            temperatureDifference: temperatureDifference
        )
    }

    private func validate(
        _ input: PlaneWallConductionInput
    ) throws {

        let values = [
            input.thermalConductivity,
            input.area,
            input.wallThickness,
            input.hotSideTemperature,
            input.coldSideTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PlaneWallConductionError.nonFiniteInput
        }

        guard input.thermalConductivity > 0 else {
            throw PlaneWallConductionError
                .nonPositiveThermalConductivity
        }

        guard input.area > 0 else {
            throw PlaneWallConductionError.nonPositiveArea
        }

        guard input.wallThickness > 0 else {
            throw PlaneWallConductionError
                .nonPositiveWallThickness
        }

        guard
            input.hotSideTemperature
                >= input.coldSideTemperature
        else {
            throw PlaneWallConductionError
                .invalidTemperatureOrder
        }
    }
}
