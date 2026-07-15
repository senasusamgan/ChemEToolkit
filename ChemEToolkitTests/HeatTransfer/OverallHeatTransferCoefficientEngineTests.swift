import Testing
@testable import ChemEToolkit

@Suite("Overall Heat Transfer Coefficient Engine")
struct OverallHeatTransferCoefficientEngineTests {

    private let engine =
        OverallHeatTransferCoefficientEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates the overall coefficient and resistance breakdown"
    )
    func calculatesOverallCoefficient()
        throws {

        let input =
            OverallHeatTransferCoefficientInput(
                hotSideHeatTransferCoefficient: 100,
                coldSideHeatTransferCoefficient: 50,
                wallThermalConductivity: 10,
                wallThickness: 0.02,
                hotSideFoulingResistance: 0.001,
                coldSideFoulingResistance: 0.002
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.hotSideConvectionResistance
                - 0.01
            ) < tolerance
        )

        #expect(
            abs(
                result.wallConductionResistance
                - 0.002
            ) < tolerance
        )

        #expect(
            abs(
                result.coldSideConvectionResistance
                - 0.02
            ) < tolerance
        )

        #expect(
            abs(
                result.totalResistancePerUnitArea
                - 0.035
            ) < tolerance
        )

        #expect(
            abs(
                result.overallHeatTransferCoefficient
                - 28.57142857142857
            ) < tolerance
        )
    }

    @Test(
        "Allows clean surfaces with zero fouling resistance"
    )
    func allowsZeroFoulingResistance()
        throws {

        let input =
            OverallHeatTransferCoefficientInput(
                hotSideHeatTransferCoefficient: 200,
                coldSideHeatTransferCoefficient: 200,
                wallThermalConductivity: 20,
                wallThickness: 0.1,
                hotSideFoulingResistance: 0,
                coldSideFoulingResistance: 0
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.totalResistancePerUnitArea
                - 0.015
            ) < tolerance
        )

        #expect(
            abs(
                result.overallHeatTransferCoefficient
                - 66.66666666666667
            ) < tolerance
        )

        #expect(
            abs(result.hotSideFoulingResistance)
                < tolerance
        )

        #expect(
            abs(result.coldSideFoulingResistance)
                < tolerance
        )
    }

    @Test(
        "Rejects invalid coefficients, wall properties and fouling"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                OverallHeatTransferCoefficientError
                    .nonPositiveHotSideCoefficient
        ) {
            try engine.calculate(
                input:
                    OverallHeatTransferCoefficientInput(
                        hotSideHeatTransferCoefficient: 0,
                        coldSideHeatTransferCoefficient: 50,
                        wallThermalConductivity: 10,
                        wallThickness: 0.02,
                        hotSideFoulingResistance: 0,
                        coldSideFoulingResistance: 0
                    )
            )
        }

        #expect(
            throws:
                OverallHeatTransferCoefficientError
                    .nonPositiveWallConductivity
        ) {
            try engine.calculate(
                input:
                    OverallHeatTransferCoefficientInput(
                        hotSideHeatTransferCoefficient: 100,
                        coldSideHeatTransferCoefficient: 50,
                        wallThermalConductivity: 0,
                        wallThickness: 0.02,
                        hotSideFoulingResistance: 0,
                        coldSideFoulingResistance: 0
                    )
            )
        }

        #expect(
            throws:
                OverallHeatTransferCoefficientError
                    .nonPositiveWallThickness
        ) {
            try engine.calculate(
                input:
                    OverallHeatTransferCoefficientInput(
                        hotSideHeatTransferCoefficient: 100,
                        coldSideHeatTransferCoefficient: 50,
                        wallThermalConductivity: 10,
                        wallThickness: 0,
                        hotSideFoulingResistance: 0,
                        coldSideFoulingResistance: 0
                    )
            )
        }

        #expect(
            throws:
                OverallHeatTransferCoefficientError
                    .negativeHotSideFoulingResistance
        ) {
            try engine.calculate(
                input:
                    OverallHeatTransferCoefficientInput(
                        hotSideHeatTransferCoefficient: 100,
                        coldSideHeatTransferCoefficient: 50,
                        wallThermalConductivity: 10,
                        wallThickness: 0.02,
                        hotSideFoulingResistance: -0.001,
                        coldSideFoulingResistance: 0
                    )
            )
        }

        #expect(
            throws:
                OverallHeatTransferCoefficientError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                input:
                    OverallHeatTransferCoefficientInput(
                        hotSideHeatTransferCoefficient:
                            .infinity,
                        coldSideHeatTransferCoefficient: 50,
                        wallThermalConductivity: 10,
                        wallThickness: 0.02,
                        hotSideFoulingResistance: 0,
                        coldSideFoulingResistance: 0
                    )
            )
        }
    }
}
