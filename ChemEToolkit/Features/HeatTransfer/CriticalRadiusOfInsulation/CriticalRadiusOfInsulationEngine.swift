import Foundation

struct CriticalRadiusOfInsulationEngine {

    func calculate(
        input: CriticalRadiusOfInsulationInput
    ) throws -> CriticalRadiusOfInsulationResult {

        try validate(input)

        let criticalRadius =
            input.insulationThermalConductivity
            / input.externalHeatTransferCoefficient

        let conductionResistance =
            cylindricalConductionResistance(
                innerRadius: input.innerRadius,
                outerRadius: input.outerRadius,
                thermalConductivity:
                    input.insulationThermalConductivity,
                length: input.cylinderLength
            )

        let convectionResistance =
            cylindricalConvectionResistance(
                radius: input.outerRadius,
                heatTransferCoefficient:
                    input.externalHeatTransferCoefficient,
                length: input.cylinderLength
            )

        let totalThermalResistance =
            conductionResistance
            + convectionResistance

        let temperatureDifference =
            input.innerSurfaceTemperature
            - input.ambientTemperature

        let currentHeatTransferRate =
            temperatureDifference
            / totalThermalResistance

        let maximumHeatTransferRadius =
            max(
                input.innerRadius,
                criticalRadius
            )

        let maximumConductionResistance: Double

        if maximumHeatTransferRadius
            > input.innerRadius {

            maximumConductionResistance =
                cylindricalConductionResistance(
                    innerRadius:
                        input.innerRadius,
                    outerRadius:
                        maximumHeatTransferRadius,
                    thermalConductivity:
                        input.insulationThermalConductivity,
                    length:
                        input.cylinderLength
                )
        } else {
            maximumConductionResistance = 0
        }

        let maximumConvectionResistance =
            cylindricalConvectionResistance(
                radius:
                    maximumHeatTransferRadius,
                heatTransferCoefficient:
                    input.externalHeatTransferCoefficient,
                length:
                    input.cylinderLength
            )

        let maximumHeatTransferRate =
            temperatureDifference
            / (
                maximumConductionResistance
                + maximumConvectionResistance
            )

        return CriticalRadiusOfInsulationResult(
            criticalRadius:
                criticalRadius,
            conductionResistance:
                conductionResistance,
            convectionResistance:
                convectionResistance,
            totalThermalResistance:
                totalThermalResistance,
            currentHeatTransferRate:
                currentHeatTransferRate,
            maximumHeatTransferRadius:
                maximumHeatTransferRadius,
            maximumHeatTransferRate:
                maximumHeatTransferRate,
            temperatureDifference:
                temperatureDifference,
            regime:
                determineRegime(
                    innerRadius:
                        input.innerRadius,
                    outerRadius:
                        input.outerRadius,
                    criticalRadius:
                        criticalRadius
                )
        )
    }

    private func cylindricalConductionResistance(
        innerRadius: Double,
        outerRadius: Double,
        thermalConductivity: Double,
        length: Double
    ) -> Double {

        log(
            outerRadius
            / innerRadius
        ) / (
            2
            * Double.pi
            * thermalConductivity
            * length
        )
    }

    private func cylindricalConvectionResistance(
        radius: Double,
        heatTransferCoefficient: Double,
        length: Double
    ) -> Double {

        1 / (
            heatTransferCoefficient
            * 2
            * Double.pi
            * radius
            * length
        )
    }

    private func determineRegime(
        innerRadius: Double,
        outerRadius: Double,
        criticalRadius: Double
    ) -> CriticalRadiusRegime {

        if criticalRadius <= innerRadius {
            return .criticalRadiusInsideOriginalSurface
        }

        let scale =
            max(
                max(
                    abs(outerRadius),
                    abs(criticalRadius)
                ),
                1e-12
            )

        if abs(
            outerRadius
            - criticalRadius
        ) <= 1e-9 * scale {
            return .atCriticalRadius
        }

        if outerRadius < criticalRadius {
            return .belowCriticalRadius
        }

        return .aboveCriticalRadius
    }

    private func validate(
        _ input: CriticalRadiusOfInsulationInput
    ) throws {

        let values = [
            input.insulationThermalConductivity,
            input.externalHeatTransferCoefficient,
            input.innerRadius,
            input.outerRadius,
            input.cylinderLength,
            input.innerSurfaceTemperature,
            input.ambientTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CriticalRadiusOfInsulationError
                .nonFiniteInput
        }

        guard
            input.insulationThermalConductivity > 0
        else {
            throw CriticalRadiusOfInsulationError
                .nonPositiveThermalConductivity
        }

        guard
            input.externalHeatTransferCoefficient > 0
        else {
            throw CriticalRadiusOfInsulationError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.innerRadius > 0 else {
            throw CriticalRadiusOfInsulationError
                .nonPositiveInnerRadius
        }

        guard input.outerRadius > input.innerRadius else {
            throw CriticalRadiusOfInsulationError
                .invalidOuterRadius
        }

        guard input.cylinderLength > 0 else {
            throw CriticalRadiusOfInsulationError
                .nonPositiveCylinderLength
        }

        guard
            input.innerSurfaceTemperature
                >= input.ambientTemperature
        else {
            throw CriticalRadiusOfInsulationError
                .invalidTemperatureOrder
        }
    }
}
