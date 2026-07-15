import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Heat Exchanger Area Sizing Engine")
struct HeatExchangerAreaSizingEngineTests {

    private let engine =
        HeatExchangerAreaSizingEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates required counter-flow area"
    )
    func calculatesRequiredArea()
        throws {

        let input =
            HeatExchangerAreaSizingInput(
                flowArrangement:
                    .counterFlow,
                hotInletTemperature: 150,
                hotOutletTemperature: 90,
                coldInletTemperature: 30,
                coldOutletTemperature: 70,
                requiredHeatTransferRate:
                    500_000,
                overallHeatTransferCoefficient:
                    500,
                correctionFactor: 0.95
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.terminalTemperatureDifferenceOne
                - 80
            ) < tolerance
        )

        #expect(
            abs(
                result.terminalTemperatureDifferenceTwo
                - 60
            ) < tolerance
        )

        #expect(
            abs(
                result.logMeanTemperatureDifference
                - 69.52118985972853
            ) < tolerance
        )

        #expect(
            abs(
                result.requiredArea
                - 15.139651413
            ) < 0.000001
        )
    }

    @Test(
        "Handles equal terminal temperature differences"
    )
    func handlesEqualDifferences()
        throws {

        let input =
            HeatExchangerAreaSizingInput(
                flowArrangement:
                    .counterFlow,
                hotInletTemperature: 100,
                hotOutletTemperature: 80,
                coldInletTemperature: 20,
                coldOutletTemperature: 40,
                requiredHeatTransferRate:
                    12_000,
                overallHeatTransferCoefficient:
                    100,
                correctionFactor: 1
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.logMeanTemperatureDifference
                - 60
            ) < tolerance
        )

        #expect(
            abs(result.requiredArea - 2)
                < tolerance
        )

        #expect(
            abs(
                result.requiredOverallConductance
                - 200
            ) < tolerance
        )
    }

    @Test(
        "Rejects invalid design inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                HeatExchangerAreaSizingError
                    .nonPositiveHeatTransferRate
        ) {
            try engine.calculate(
                input:
                    HeatExchangerAreaSizingInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate: 0,
                        overallHeatTransferCoefficient: 100,
                        correctionFactor: 1
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerAreaSizingError
                    .invalidCorrectionFactor
        ) {
            try engine.calculate(
                input:
                    HeatExchangerAreaSizingInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate:
                            12_000,
                        overallHeatTransferCoefficient: 100,
                        correctionFactor: 1.1
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerAreaSizingError
                    .nonPositiveTerminalTemperatureDifference
        ) {
            try engine.calculate(
                input:
                    HeatExchangerAreaSizingInput(
                        flowArrangement:
                            .parallelFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 50,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 60,
                        requiredHeatTransferRate:
                            12_000,
                        overallHeatTransferCoefficient: 100,
                        correctionFactor: 1
                    )
            )
        }
    }
}
