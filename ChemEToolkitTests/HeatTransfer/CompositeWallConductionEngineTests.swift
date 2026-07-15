import Testing
@testable import ChemEToolkit

@Suite("Composite Wall Conduction Engine")
struct CompositeWallConductionEngineTests {

    private let engine =
        CompositeWallConductionEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates heat transfer and interface temperatures"
    )
    func calculatesCompositeWallConduction()
        throws {

        let input =
            CompositeWallConductionInput(
                area: 2,
                hotSideTemperature: 100,
                coldSideTemperature: 40,
                layers: [
                    CompositeWallLayer(
                        name: "Layer 1",
                        thermalConductivity: 0.5,
                        thickness: 0.1
                    ),
                    CompositeWallLayer(
                        name: "Layer 2",
                        thermalConductivity: 1,
                        thickness: 0.2
                    )
                ]
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.temperatureDifference
                - 60
            ) < tolerance
        )

        #expect(
            abs(
                result.totalThermalResistance
                - 0.2
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 300
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - 150
            ) < tolerance
        )

        #expect(
            result.layerResults.count == 2
        )

        let firstLayer =
            result.layerResults[0]

        #expect(
            abs(
                firstLayer.thermalResistance
                - 0.1
            ) < tolerance
        )

        #expect(
            abs(
                firstLayer.temperatureDrop
                - 30
            ) < tolerance
        )

        #expect(
            abs(
                firstLayer.hotSideTemperature
                - 100
            ) < tolerance
        )

        #expect(
            abs(
                firstLayer.coldSideTemperature
                - 70
            ) < tolerance
        )

        let secondLayer =
            result.layerResults[1]

        #expect(
            abs(
                secondLayer.hotSideTemperature
                - 70
            ) < tolerance
        )

        #expect(
            abs(
                secondLayer.coldSideTemperature
                - 40
            ) < tolerance
        )
    }

    @Test(
        "Returns zero heat transfer at equal boundary temperatures"
    )
    func returnsZeroAtEqualTemperatures()
        throws {

        let input =
            CompositeWallConductionInput(
                area: 5,
                hotSideTemperature: 25,
                coldSideTemperature: 25,
                layers: [
                    CompositeWallLayer(
                        name: "Insulation",
                        thermalConductivity: 0.04,
                        thickness: 0.1
                    )
                ]
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(result.temperatureDifference)
                < tolerance
        )

        #expect(
            abs(result.heatTransferRate)
                < tolerance
        )

        #expect(
            abs(result.heatFlux)
                < tolerance
        )

        #expect(
            abs(
                result.layerResults[0]
                    .temperatureDrop
            ) < tolerance
        )

        #expect(
            abs(
                result.layerResults[0]
                    .coldSideTemperature
                - 25
            ) < tolerance
        )
    }

    @Test(
        "Rejects missing layers and invalid layer properties"
    )
    func rejectsInvalidCompositeWallInputs() {

        #expect(
            throws:
                CompositeWallConductionError
                    .noLayers
        ) {
            try engine.calculate(
                input:
                    CompositeWallConductionInput(
                        area: 2,
                        hotSideTemperature: 100,
                        coldSideTemperature: 20,
                        layers: []
                    )
            )
        }

        #expect(
            throws:
                CompositeWallConductionError
                    .nonPositiveThermalConductivity(
                        layerNumber: 2
                    )
        ) {
            try engine.calculate(
                input:
                    CompositeWallConductionInput(
                        area: 2,
                        hotSideTemperature: 100,
                        coldSideTemperature: 20,
                        layers: [
                            CompositeWallLayer(
                                name: "Layer 1",
                                thermalConductivity: 1,
                                thickness: 0.1
                            ),
                            CompositeWallLayer(
                                name: "Layer 2",
                                thermalConductivity: 0,
                                thickness: 0.2
                            )
                        ]
                    )
            )
        }

        #expect(
            throws:
                CompositeWallConductionError
                    .nonPositiveThickness(
                        layerNumber: 1
                    )
        ) {
            try engine.calculate(
                input:
                    CompositeWallConductionInput(
                        area: 2,
                        hotSideTemperature: 100,
                        coldSideTemperature: 20,
                        layers: [
                            CompositeWallLayer(
                                name: "Layer 1",
                                thermalConductivity: 0.5,
                                thickness: -0.1
                            )
                        ]
                    )
            )
        }

        #expect(
            throws:
                CompositeWallConductionError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    CompositeWallConductionInput(
                        area: 2,
                        hotSideTemperature: 20,
                        coldSideTemperature: 100,
                        layers: [
                            CompositeWallLayer(
                                name: "Layer 1",
                                thermalConductivity: 0.5,
                                thickness: 0.1
                            )
                        ]
                    )
            )
        }
    }
}
