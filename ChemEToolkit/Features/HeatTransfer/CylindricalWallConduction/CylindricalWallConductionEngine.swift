import Foundation

struct CylindricalWallConductionEngine {

    func calculate(
        input: CylindricalWallConductionInput
    ) throws -> CylindricalWallConductionResult {

        try validate(input)

        let temperatureDifference =
            input.innerSurfaceTemperature
            - input.outerSurfaceTemperature

        let radiusRatio =
            input.outerRadius
            / input.innerRadius

        let thermalResistance =
            log(radiusRatio)
            / (
                2
                * Double.pi
                * input.thermalConductivity
                * input.cylinderLength
            )

        let heatTransferRate =
            temperatureDifference
            / thermalResistance

        let innerSurfaceArea =
            2
            * Double.pi
            * input.innerRadius
            * input.cylinderLength

        let outerSurfaceArea =
            2
            * Double.pi
            * input.outerRadius
            * input.cylinderLength

        let innerSurfaceHeatFlux =
            heatTransferRate
            / innerSurfaceArea

        let outerSurfaceHeatFlux =
            heatTransferRate
            / outerSurfaceArea

        return CylindricalWallConductionResult(
            heatTransferRate:
                heatTransferRate,
            thermalResistance:
                thermalResistance,
            temperatureDifference:
                temperatureDifference,
            innerSurfaceHeatFlux:
                innerSurfaceHeatFlux,
            outerSurfaceHeatFlux:
                outerSurfaceHeatFlux,
            innerSurfaceArea:
                innerSurfaceArea,
            outerSurfaceArea:
                outerSurfaceArea
        )
    }

    private func validate(
        _ input: CylindricalWallConductionInput
    ) throws {

        let values = [
            input.thermalConductivity,
            input.innerRadius,
            input.outerRadius,
            input.cylinderLength,
            input.innerSurfaceTemperature,
            input.outerSurfaceTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CylindricalWallConductionError
                .nonFiniteInput
        }

        guard input.thermalConductivity > 0 else {
            throw CylindricalWallConductionError
                .nonPositiveThermalConductivity
        }

        guard input.innerRadius > 0 else {
            throw CylindricalWallConductionError
                .nonPositiveInnerRadius
        }

        guard
            input.outerRadius
                > input.innerRadius
        else {
            throw CylindricalWallConductionError
                .invalidOuterRadius
        }

        guard input.cylinderLength > 0 else {
            throw CylindricalWallConductionError
                .nonPositiveCylinderLength
        }

        guard
            input.innerSurfaceTemperature
                >= input.outerSurfaceTemperature
        else {
            throw CylindricalWallConductionError
                .invalidTemperatureOrder
        }
    }
}
