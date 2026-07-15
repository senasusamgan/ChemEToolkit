import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Fouling Analysis Engine")
struct FoulingAnalysisEngineTests {

    private let engine =
        FoulingAnalysisEngine()

    private let tolerance = 0.000001

    @Test("Calculates fouling performance loss")
    func calculatesFoulingLoss() throws {
        let result = try engine.calculate(
            input: FoulingAnalysisInput(
                hotSideHeatTransferCoefficient: 100,
                coldSideHeatTransferCoefficient: 50,
                wallThermalConductivity: 10,
                wallThickness: 0.02,
                hotSideFoulingResistance: 0.001,
                coldSideFoulingResistance: 0.002,
                heatTransferArea: 10,
                hotSideTemperature: 100,
                coldSideTemperature: 20
            )
        )

        #expect(
            abs(
                result.cleanResistancePerUnitArea
                - 0.032
            ) < tolerance
        )

        #expect(
            abs(
                result.fouledResistancePerUnitArea
                - 0.035
            ) < tolerance
        )

        #expect(
            abs(
                result.cleanOverallCoefficient
                - 31.25
            ) < tolerance
        )

        #expect(
            abs(
                result.fouledOverallCoefficient
                - 28.571428571428573
            ) < tolerance
        )

        #expect(
            abs(
                result.cleanHeatTransferRate
                - 25_000
            ) < tolerance
        )

        #expect(
            abs(
                result.fouledHeatTransferRate
                - 22_857.14285714286
            ) < tolerance
        )

        #expect(
            abs(
                result.performanceLossPercentage
                - 8.57142857142857
            ) < tolerance
        )
    }

    @Test("Returns no penalty for clean surfaces")
    func returnsNoPenaltyForCleanSurfaces()
        throws {

        let result = try engine.calculate(
            input: FoulingAnalysisInput(
                hotSideHeatTransferCoefficient: 100,
                coldSideHeatTransferCoefficient: 50,
                wallThermalConductivity: 10,
                wallThickness: 0.02,
                hotSideFoulingResistance: 0,
                coldSideFoulingResistance: 0,
                heatTransferArea: 10,
                hotSideTemperature: 100,
                coldSideTemperature: 20
            )
        )

        #expect(
            abs(
                result.cleanOverallCoefficient
                - result.fouledOverallCoefficient
            ) < tolerance
        )

        #expect(
            abs(
                result.performanceLossPercentage
            ) < tolerance
        )
    }

    @Test("Rejects invalid fouling inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                FoulingAnalysisError
                    .nonPositiveHotSideCoefficient
        ) {
            try engine.calculate(
                input: FoulingAnalysisInput(
                    hotSideHeatTransferCoefficient: 0,
                    coldSideHeatTransferCoefficient: 50,
                    wallThermalConductivity: 10,
                    wallThickness: 0.02,
                    hotSideFoulingResistance: 0,
                    coldSideFoulingResistance: 0,
                    heatTransferArea: 10,
                    hotSideTemperature: 100,
                    coldSideTemperature: 20
                )
            )
        }

        #expect(
            throws:
                FoulingAnalysisError
                    .negativeHotSideFoulingResistance
        ) {
            try engine.calculate(
                input: FoulingAnalysisInput(
                    hotSideHeatTransferCoefficient: 100,
                    coldSideHeatTransferCoefficient: 50,
                    wallThermalConductivity: 10,
                    wallThickness: 0.02,
                    hotSideFoulingResistance: -0.001,
                    coldSideFoulingResistance: 0,
                    heatTransferArea: 10,
                    hotSideTemperature: 100,
                    coldSideTemperature: 20
                )
            )
        }

        #expect(
            throws:
                FoulingAnalysisError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input: FoulingAnalysisInput(
                    hotSideHeatTransferCoefficient: 100,
                    coldSideHeatTransferCoefficient: 50,
                    wallThermalConductivity: 10,
                    wallThickness: 0.02,
                    hotSideFoulingResistance: 0,
                    coldSideFoulingResistance: 0,
                    heatTransferArea: 10,
                    hotSideTemperature: 20,
                    coldSideTemperature: 100
                )
            )
        }
    }
}
