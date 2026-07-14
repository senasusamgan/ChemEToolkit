import Foundation

struct ConvectionHeatTransferEngine {

    func calculate(
        input: ConvectionHeatTransferInput
    ) throws -> ConvectionHeatTransferResult {

        try validate(input)

        let temperatureDifference =
            input.surfaceTemperature
            - input.fluidTemperature

        let thermalResistance =
            1
            / (
                input.heatTransferCoefficient
                * input.area
            )

        let heatTransferRate =
            temperatureDifference
            / thermalResistance

        let heatFlux =
            heatTransferRate
            / input.area

        let direction =
            heatFlowDirection(
                for: temperatureDifference
            )

        return ConvectionHeatTransferResult(
            heatTransferRate: heatTransferRate,
            heatTransferRateMagnitude:
                abs(heatTransferRate),
            heatFlux: heatFlux,
            thermalResistance: thermalResistance,
            temperatureDifference: temperatureDifference,
            direction: direction
        )
    }

    private func validate(
        _ input: ConvectionHeatTransferInput
    ) throws {

        let values = [
            input.heatTransferCoefficient,
            input.area,
            input.surfaceTemperature,
            input.fluidTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ConvectionHeatTransferError
                .nonFiniteInput
        }

        guard input.heatTransferCoefficient > 0 else {
            throw ConvectionHeatTransferError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.area > 0 else {
            throw ConvectionHeatTransferError
                .nonPositiveArea
        }
    }

    private func heatFlowDirection(
        for temperatureDifference: Double
    ) -> ConvectionHeatFlowDirection {

        if temperatureDifference > 0 {
            return .surfaceToFluid
        }

        if temperatureDifference < 0 {
            return .fluidToSurface
        }

        return .equilibrium
    }
}
