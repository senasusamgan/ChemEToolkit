import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Heat Exchanger LMTD Engine")
struct HeatExchangerLMTDEngineTests {

    private let engine =
        HeatExchangerLMTDEngine()

    private let tolerance =
        0.000001

    @Test(
        "Handles equal terminal differences in counter flow"
    )
    func calculatesCounterFlowWithEqualDifferences()
        throws {

        let input =
            HeatExchangerLMTDInput(
                flowArrangement:
                    .counterFlow,
                hotInletTemperature: 100,
                hotOutletTemperature: 80,
                coldInletTemperature: 20,
                coldOutletTemperature: 40,
                overallHeatTransferCoefficient: 100,
                heatTransferArea: 2,
                correctionFactor: 1
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.terminalTemperatureDifferenceOne
                - 60
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
                - 60
            ) < tolerance
        )

        #expect(
            abs(
                result.overallConductance
                - 200
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 12_000
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - 6_000
            ) < tolerance
        )
    }

    @Test(
        "Calculates parallel-flow LMTD and heat-transfer rate"
    )
    func calculatesParallelFlowLMTD()
        throws {

        let input =
            HeatExchangerLMTDInput(
                flowArrangement:
                    .parallelFlow,
                hotInletTemperature: 100,
                hotOutletTemperature: 80,
                coldInletTemperature: 20,
                coldOutletTemperature: 40,
                overallHeatTransferCoefficient: 100,
                heatTransferArea: 2,
                correctionFactor: 1
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
                - 40
            ) < tolerance
        )

        #expect(
            abs(
                result.logMeanTemperatureDifference
                - 57.70780163555854
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 11_541.560327111707
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - 5_770.7801635558535
            ) < tolerance
        )
    }

    @Test(
        "Rejects invalid temperatures, correction factor and properties"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                HeatExchangerLMTDError
                    .invalidCorrectionFactor
        ) {
            try engine.calculate(
                input:
                    HeatExchangerLMTDInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 2,
                        correctionFactor: 1.2
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerLMTDError
                    .invalidHotStreamTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    HeatExchangerLMTDInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 80,
                        hotOutletTemperature: 100,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 2,
                        correctionFactor: 1
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerLMTDError
                    .invalidColdStreamTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    HeatExchangerLMTDInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 40,
                        coldOutletTemperature: 20,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 2,
                        correctionFactor: 1
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerLMTDError
                    .nonPositiveTerminalTemperatureDifference
        ) {
            try engine.calculate(
                input:
                    HeatExchangerLMTDInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 110,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 2,
                        correctionFactor: 1
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerLMTDError
                    .nonPositiveOverallCoefficient
        ) {
            try engine.calculate(
                input:
                    HeatExchangerLMTDInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        overallHeatTransferCoefficient: 0,
                        heatTransferArea: 2,
                        correctionFactor: 1
                    )
            )
        }
    }
}
