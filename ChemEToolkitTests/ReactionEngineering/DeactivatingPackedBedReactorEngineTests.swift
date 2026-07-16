import Testing
@testable import ChemEToolkit

@Suite("Deactivating Packed-Bed Reactor Engine")
struct DeactivatingPackedBedReactorEngineTests {
    private let engine =
        DeactivatingPackedBedReactorEngine()

    @Test("Calculates activity-adjusted conversion")
    func deactivatingBed() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 2,
                volumetricFlowRate: 1,
                catalystWeight: 10,
                freshCatalystRateCoefficient: 0.4,
                deactivationRateConstant: 0.1,
                timeOnStream: 5,
                targetConversion: 0.9
            )
        )

        #expect(
            abs(
                result.catalystActivity
                - 0.60653065971263342
            ) < 1e-12
        )
        #expect(
            abs(
                result.freshDamkohlerNumber
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.currentDamkohlerNumber
                - 2.4261226388505337
            ) < 1e-12
        )
        #expect(
            abs(
                result.currentConversion
                - 0.91162115419734746
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationA
                - 0.17675769160530508
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredCatalystWeightForTarget
                - 9.4908025510407903
            ) < 1e-12
        )
    }

    @Test("Fresh-time boundary matches fresh conversion")
    func freshBoundary() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 2,
                volumetricFlowRate: 1,
                catalystWeight: 10,
                freshCatalystRateCoefficient: 0.4,
                deactivationRateConstant: 0.1,
                timeOnStream: 0,
                targetConversion: 0.9
            )
        )

        #expect(result.catalystActivity == 1)
        #expect(
            abs(
                result.currentConversion
                - result.freshConversion
            ) < 1e-12
        )
        #expect(
            abs(result.conversionLoss)
            < 1e-12
        )
    }

    @Test("Rejects invalid packed-bed inputs")
    func validation() {
        #expect(
            throws:
                DeactivatingPackedBedReactorError
                    .nonPositiveCatalystCondition
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 2,
                    volumetricFlowRate: 1,
                    catalystWeight: 0,
                    freshCatalystRateCoefficient: 0.4,
                    deactivationRateConstant: 0.1,
                    timeOnStream: 5,
                    targetConversion: 0.9
                )
            )
        }

        #expect(
            throws:
                DeactivatingPackedBedReactorError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 2,
                    volumetricFlowRate: 1,
                    catalystWeight: 10,
                    freshCatalystRateCoefficient: 0.4,
                    deactivationRateConstant: 0.1,
                    timeOnStream: 5,
                    targetConversion: 1
                )
            )
        }
    }
}
