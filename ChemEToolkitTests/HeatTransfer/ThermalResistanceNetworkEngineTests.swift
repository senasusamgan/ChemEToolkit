import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Thermal Resistance Network Engine")
struct ThermalResistanceNetworkEngineTests {

    private let engine =
        ThermalResistanceNetworkEngine()

    private let tolerance = 0.000001

    @Test("Calculates a series network")
    func calculatesSeriesNetwork() throws {
        let result = try engine.calculate(
            input:
                ThermalResistanceNetworkInput(
                    arrangement: .series,
                    hotSideTemperature: 100,
                    coldSideTemperature: 50,
                    resistances: [2, 3]
                )
        )

        #expect(
            abs(
                result.equivalentResistance
                - 5
            ) < tolerance
        )

        #expect(
            abs(
                result.totalHeatTransferRate
                - 10
            ) < tolerance
        )

        #expect(
            abs(
                result.branchResults[0]
                    .temperatureDrop
                - 20
            ) < tolerance
        )

        #expect(
            abs(
                result.branchResults[1]
                    .temperatureDrop
                - 30
            ) < tolerance
        )
    }

    @Test("Calculates a parallel network")
    func calculatesParallelNetwork() throws {
        let result = try engine.calculate(
            input:
                ThermalResistanceNetworkInput(
                    arrangement: .parallel,
                    hotSideTemperature: 80,
                    coldSideTemperature: 20,
                    resistances: [2, 3]
                )
        )

        #expect(
            abs(
                result.equivalentResistance
                - 1.2
            ) < tolerance
        )

        #expect(
            abs(
                result.totalHeatTransferRate
                - 50
            ) < tolerance
        )

        #expect(
            abs(
                result.branchResults[0]
                    .heatTransferRate
                - 30
            ) < tolerance
        )

        #expect(
            abs(
                result.branchResults[1]
                    .heatTransferRate
                - 20
            ) < tolerance
        )
    }

    @Test("Rejects invalid network inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                ThermalResistanceNetworkError
                    .noResistances
        ) {
            try engine.calculate(
                input:
                    ThermalResistanceNetworkInput(
                        arrangement: .series,
                        hotSideTemperature: 100,
                        coldSideTemperature: 20,
                        resistances: []
                    )
            )
        }

        #expect(
            throws:
                ThermalResistanceNetworkError
                    .nonPositiveResistance(
                        branchNumber: 2
                    )
        ) {
            try engine.calculate(
                input:
                    ThermalResistanceNetworkInput(
                        arrangement: .series,
                        hotSideTemperature: 100,
                        coldSideTemperature: 20,
                        resistances: [1, 0]
                    )
            )
        }

        #expect(
            throws:
                ThermalResistanceNetworkError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    ThermalResistanceNetworkInput(
                        arrangement: .parallel,
                        hotSideTemperature: 20,
                        coldSideTemperature: 100,
                        resistances: [1, 2]
                    )
            )
        }
    }
}
