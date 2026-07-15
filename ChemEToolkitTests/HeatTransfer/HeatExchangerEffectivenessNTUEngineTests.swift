import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Heat Exchanger Effectiveness NTU Engine")
struct HeatExchangerEffectivenessNTUEngineTests {

    private let engine =
        HeatExchangerEffectivenessNTUEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates counter-flow effectiveness and outlets"
    )
    func calculatesCounterFlowPerformance()
        throws {

        let input =
            HeatExchangerEffectivenessNTUInput(
                flowArrangement:
                    .counterFlow,
                hotInletTemperature: 100,
                coldInletTemperature: 20,
                hotMassFlowRate: 1,
                coldMassFlowRate: 2,
                hotSpecificHeatCapacity: 1_000,
                coldSpecificHeatCapacity: 1_000,
                overallHeatTransferCoefficient: 100,
                heatTransferArea: 10
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(result.hotCapacityRate - 1_000)
                < tolerance
        )

        #expect(
            abs(result.coldCapacityRate - 2_000)
                < tolerance
        )

        #expect(
            abs(
                result.capacityRateRatio
                - 0.5
            ) < tolerance
        )

        #expect(
            abs(
                result.numberOfTransferUnits
                - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.effectiveness
                - 0.5647334016064162
            ) < tolerance
        )

        #expect(
            abs(
                result.actualHeatTransferRate
                - 45_178.672128513296
            ) < tolerance
        )

        #expect(
            abs(
                result.hotOutletTemperature
                - 54.821327871486704
            ) < tolerance
        )

        #expect(
            abs(
                result.coldOutletTemperature
                - 42.58933606425665
            ) < tolerance
        )
    }

    @Test(
        "Handles equal capacity rates in counter flow"
    )
    func handlesEqualCapacityRates()
        throws {

        let input =
            HeatExchangerEffectivenessNTUInput(
                flowArrangement:
                    .counterFlow,
                hotInletTemperature: 100,
                coldInletTemperature: 20,
                hotMassFlowRate: 1,
                coldMassFlowRate: 1,
                hotSpecificHeatCapacity: 1_000,
                coldSpecificHeatCapacity: 1_000,
                overallHeatTransferCoefficient: 100,
                heatTransferArea: 10
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.capacityRateRatio
                - 1
            ) < tolerance
        )

        #expect(
            abs(result.effectiveness - 0.5)
                < tolerance
        )

        #expect(
            abs(
                result.actualHeatTransferRate
                - 40_000
            ) < tolerance
        )

        #expect(
            abs(
                result.hotOutletTemperature
                - 60
            ) < tolerance
        )

        #expect(
            abs(
                result.coldOutletTemperature
                - 60
            ) < tolerance
        )
    }

    @Test(
        "Rejects invalid NTU inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                HeatExchangerEffectivenessNTUError
                    .invalidInletTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    HeatExchangerEffectivenessNTUInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 20,
                        coldInletTemperature: 100,
                        hotMassFlowRate: 1,
                        coldMassFlowRate: 1,
                        hotSpecificHeatCapacity: 1_000,
                        coldSpecificHeatCapacity: 1_000,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 10
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerEffectivenessNTUError
                    .nonPositiveHotMassFlowRate
        ) {
            try engine.calculate(
                input:
                    HeatExchangerEffectivenessNTUInput(
                        flowArrangement:
                            .counterFlow,
                        hotInletTemperature: 100,
                        coldInletTemperature: 20,
                        hotMassFlowRate: 0,
                        coldMassFlowRate: 1,
                        hotSpecificHeatCapacity: 1_000,
                        coldSpecificHeatCapacity: 1_000,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 10
                    )
            )
        }

        #expect(
            throws:
                HeatExchangerEffectivenessNTUError
                    .nonPositiveArea
        ) {
            try engine.calculate(
                input:
                    HeatExchangerEffectivenessNTUInput(
                        flowArrangement:
                            .parallelFlow,
                        hotInletTemperature: 100,
                        coldInletTemperature: 20,
                        hotMassFlowRate: 1,
                        coldMassFlowRate: 1,
                        hotSpecificHeatCapacity: 1_000,
                        coldSpecificHeatCapacity: 1_000,
                        overallHeatTransferCoefficient: 100,
                        heatTransferArea: 0
                    )
            )
        }
    }
}
