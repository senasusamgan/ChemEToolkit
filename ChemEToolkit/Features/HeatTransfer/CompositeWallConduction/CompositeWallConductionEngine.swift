import Foundation

struct CompositeWallConductionEngine {

    func calculate(
        input: CompositeWallConductionInput
    ) throws -> CompositeWallConductionResult {

        try validate(input)

        let temperatureDifference =
            input.hotSideTemperature
            - input.coldSideTemperature

        let layerResistances =
            input.layers.map { layer in
                layer.thickness
                / (
                    layer.thermalConductivity
                    * input.area
                )
            }

        let totalThermalResistance =
            layerResistances.reduce(
                0,
                +
            )

        let heatTransferRate =
            temperatureDifference
            / totalThermalResistance

        let heatFlux =
            heatTransferRate
            / input.area

        var currentTemperature =
            input.hotSideTemperature

        var layerResults:
            [CompositeWallLayerResult] = []

        for (
            index,
            layer
        ) in input.layers.enumerated() {

            let thermalResistance =
                layerResistances[index]

            let temperatureDrop =
                heatTransferRate
                * thermalResistance

            let nextTemperature =
                currentTemperature
                - temperatureDrop

            layerResults.append(
                CompositeWallLayerResult(
                    name: layer.name,
                    thermalResistance:
                        thermalResistance,
                    temperatureDrop:
                        temperatureDrop,
                    hotSideTemperature:
                        currentTemperature,
                    coldSideTemperature:
                        nextTemperature
                )
            )

            currentTemperature =
                nextTemperature
        }

        return CompositeWallConductionResult(
            heatTransferRate:
                heatTransferRate,
            heatFlux:
                heatFlux,
            totalThermalResistance:
                totalThermalResistance,
            temperatureDifference:
                temperatureDifference,
            layerResults:
                layerResults
        )
    }

    private func validate(
        _ input: CompositeWallConductionInput
    ) throws {

        guard input.area.isFinite,
              input.hotSideTemperature.isFinite,
              input.coldSideTemperature.isFinite
        else {
            throw CompositeWallConductionError
                .nonFiniteInput
        }

        guard !input.layers.isEmpty else {
            throw CompositeWallConductionError
                .noLayers
        }

        guard input.area > 0 else {
            throw CompositeWallConductionError
                .nonPositiveArea
        }

        guard
            input.hotSideTemperature
                >= input.coldSideTemperature
        else {
            throw CompositeWallConductionError
                .invalidTemperatureOrder
        }

        for (
            index,
            layer
        ) in input.layers.enumerated() {

            let layerNumber =
                index + 1

            guard
                layer.thermalConductivity.isFinite,
                layer.thickness.isFinite
            else {
                throw CompositeWallConductionError
                    .nonFiniteInput
            }

            guard
                layer.thermalConductivity > 0
            else {
                throw CompositeWallConductionError
                    .nonPositiveThermalConductivity(
                        layerNumber:
                            layerNumber
                    )
            }

            guard layer.thickness > 0 else {
                throw CompositeWallConductionError
                    .nonPositiveThickness(
                        layerNumber:
                            layerNumber
                    )
            }
        }
    }
}
