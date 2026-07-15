import Foundation

struct SphericalWallConductionEngine {

    func calculate(
        input: SphericalWallConductionInput
    ) throws -> SphericalWallConductionResult {

        try validate(input)

        let thermalResistance =
            (
                1 / input.innerRadius
                - 1 / input.outerRadius
            )
            / (
                4
                * Double.pi
                * input.thermalConductivity
            )

        let temperatureDifference =
            input.innerSurfaceTemperature
            - input.outerSurfaceTemperature

        let heatTransferRate =
            temperatureDifference
            / thermalResistance

        let innerSurfaceArea =
            4
            * Double.pi
            * pow(input.innerRadius, 2)

        let outerSurfaceArea =
            4
            * Double.pi
            * pow(input.outerRadius, 2)

        return SphericalWallConductionResult(
            thermalResistance:
                thermalResistance,
            heatTransferRate:
                heatTransferRate,
            temperatureDifference:
                temperatureDifference,
            innerSurfaceArea:
                innerSurfaceArea,
            outerSurfaceArea:
                outerSurfaceArea,
            innerSurfaceHeatFlux:
                heatTransferRate
                / innerSurfaceArea,
            outerSurfaceHeatFlux:
                heatTransferRate
                / outerSurfaceArea
        )
    }

    private func validate(
        _ input: SphericalWallConductionInput
    ) throws {

        let values = [
            input.thermalConductivity,
            input.innerRadius,
            input.outerRadius,
            input.innerSurfaceTemperature,
            input.outerSurfaceTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SphericalWallConductionError
                .nonFiniteInput
        }

        guard input.thermalConductivity > 0 else {
            throw SphericalWallConductionError
                .nonPositiveThermalConductivity
        }

        guard input.innerRadius > 0 else {
            throw SphericalWallConductionError
                .nonPositiveInnerRadius
        }

        guard input.outerRadius > input.innerRadius else {
            throw SphericalWallConductionError
                .invalidOuterRadius
        }

        guard
            input.innerSurfaceTemperature
                >= input.outerSurfaceTemperature
        else {
            throw SphericalWallConductionError
                .invalidTemperatureOrder
        }
    }
}
