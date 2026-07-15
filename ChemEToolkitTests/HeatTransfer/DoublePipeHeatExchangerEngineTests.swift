import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Double-Pipe Heat Exchanger Engine")
struct DoublePipeHeatExchangerEngineTests {

    private let engine =
        DoublePipeHeatExchangerEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates required counter-flow tube length"
    )
    func calculatesCounterFlowLength()
        throws {

        let input =
            DoublePipeHeatExchangerInput(
                flowArrangement: .counterFlow,
                hotInletTemperature: 100,
                hotOutletTemperature: 80,
                coldInletTemperature: 20,
                coldOutletTemperature: 40,
                requiredHeatTransferRate: 12_000,
                overallHeatTransferCoefficient: 100,
                tubeOuterDiameter: 0.05,
                numberOfParallelTubes: 2,
                correctionFactor: 1
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.logMeanTemperatureDifference
                - 60
            ) < tolerance
        )

        #expect(
            abs(
                result.requiredHeatTransferArea
                - 2
            ) < tolerance
        )

        #expect(
            abs(
                result.requiredLengthPerTube
                - 6.366197723675814
            ) < tolerance
        )

        #expect(
            abs(
                result.totalTubeLength
                - 12.732395447351628
            ) < tolerance
        )

        #expect(
            abs(
                result.designHeatFlux
                - 6_000
            ) < tolerance
        )
    }

    @Test(
        "Calculates parallel-flow geometry"
    )
    func calculatesParallelFlowGeometry()
        throws {

        let input =
            DoublePipeHeatExchangerInput(
                flowArrangement: .parallelFlow,
                hotInletTemperature: 100,
                hotOutletTemperature: 80,
                coldInletTemperature: 20,
                coldOutletTemperature: 40,
                requiredHeatTransferRate: 12_000,
                overallHeatTransferCoefficient: 100,
                tubeOuterDiameter: 0.05,
                numberOfParallelTubes: 1,
                correctionFactor: 1
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.logMeanTemperatureDifference
                - 57.70780163555854
            ) < tolerance
        )

        #expect(
            abs(
                result.requiredHeatTransferArea
                - 2.079441541679836
            ) < tolerance
        )

        #expect(
            abs(
                result.requiredLengthPerTube
                - 13.238136009159097
            ) < tolerance
        )
    }

    @Test(
        "Rejects invalid geometry and design inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                DoublePipeHeatExchangerError
                    .nonPositiveTubeDiameter
        ) {
            try engine.calculate(
                input:
                    DoublePipeHeatExchangerInput(
                        flowArrangement: .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate: 12_000,
                        overallHeatTransferCoefficient: 100,
                        tubeOuterDiameter: 0,
                        numberOfParallelTubes: 1,
                        correctionFactor: 1
                    )
            )
        }

        #expect(
            throws:
                DoublePipeHeatExchangerError
                    .nonPositiveParallelTubeCount
        ) {
            try engine.calculate(
                input:
                    DoublePipeHeatExchangerInput(
                        flowArrangement: .counterFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 80,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 40,
                        requiredHeatTransferRate: 12_000,
                        overallHeatTransferCoefficient: 100,
                        tubeOuterDiameter: 0.05,
                        numberOfParallelTubes: 0,
                        correctionFactor: 1
                    )
            )
        }

        #expect(
            throws:
                DoublePipeHeatExchangerError
                    .nonPositiveTerminalTemperatureDifference
        ) {
            try engine.calculate(
                input:
                    DoublePipeHeatExchangerInput(
                        flowArrangement: .parallelFlow,
                        hotInletTemperature: 100,
                        hotOutletTemperature: 50,
                        coldInletTemperature: 20,
                        coldOutletTemperature: 60,
                        requiredHeatTransferRate: 12_000,
                        overallHeatTransferCoefficient: 100,
                        tubeOuterDiameter: 0.05,
                        numberOfParallelTubes: 1,
                        correctionFactor: 1
                    )
            )
        }
    }
}
