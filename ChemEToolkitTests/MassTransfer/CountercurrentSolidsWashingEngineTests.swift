import Testing
@testable import ChemEToolkit

@Suite(
    "Countercurrent Solids Washing Engine"
)
struct CountercurrentSolidsWashingEngineTests {
    private let engine =
        CountercurrentSolidsWashingEngine()

    @Test(
        "Solves the coupled countercurrent stage balances"
    )
    func solvesCountercurrentWashing()
        throws {

        let result = try engine.calculate(
            .init(
                insolubleSolidFlowRate: 100,
                retainedSolventPerInsolubleSolid:
                    0.5,
                freshWashSolventFlowRate:
                    100,
                feedUnderflowSoluteRatio:
                    0.2,
                freshWashSoluteRatio: 0,
                numberOfIdealStages: 3
            )
        )

        #expect(
            result.numberOfIdealStages == 3
        )
        #expect(
            abs(
                result.washingFactor - 2
            ) < 1e-12
        )
        #expect(
            abs(
                result.productOverflowSoluteRatio
                - 0.09333333333333334
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalUnderflowSoluteRatio
                - 0.013333333333333334
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRemovalFraction
                - 0.9333333333333333
            ) < 1e-12
        )
        #expect(
            abs(result.soluteBalanceResidual)
            < 1e-12
        )
    }

    @Test(
        "Reduces to one ideal mixing-settling stage"
    )
    func oneStageBoundary() throws {
        let result = try engine.calculate(
            .init(
                insolubleSolidFlowRate: 100,
                retainedSolventPerInsolubleSolid:
                    0.5,
                freshWashSolventFlowRate:
                    100,
                feedUnderflowSoluteRatio:
                    0.2,
                freshWashSoluteRatio: 0,
                numberOfIdealStages: 1
            )
        )

        #expect(
            abs(
                result.finalUnderflowSoluteRatio
                - 0.06666666666666667
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRemovalFraction
                - 0.6666666666666666
            ) < 1e-12
        )
    }

    @Test(
        "Rejects invalid stages, absent driving force and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                CountercurrentSolidsWashingError
                    .invalidStageCount
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        100,
                    retainedSolventPerInsolubleSolid:
                        0.5,
                    freshWashSolventFlowRate:
                        100,
                    feedUnderflowSoluteRatio:
                        0.2,
                    freshWashSoluteRatio:
                        0,
                    numberOfIdealStages:
                        2.5
                )
            )
        }

        #expect(
            throws:
                CountercurrentSolidsWashingError
                    .noInitialWashingDrivingForce
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        100,
                    retainedSolventPerInsolubleSolid:
                        0.5,
                    freshWashSolventFlowRate:
                        100,
                    feedUnderflowSoluteRatio:
                        0.2,
                    freshWashSoluteRatio:
                        0.2,
                    numberOfIdealStages:
                        3
                )
            )
        }

        #expect(
            throws:
                CountercurrentSolidsWashingError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        100,
                    retainedSolventPerInsolubleSolid:
                        0.5,
                    freshWashSolventFlowRate:
                        0,
                    feedUnderflowSoluteRatio:
                        0.2,
                    freshWashSoluteRatio:
                        0,
                    numberOfIdealStages:
                        3
                )
            )
        }

        #expect(
            throws:
                CountercurrentSolidsWashingError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        .nan,
                    retainedSolventPerInsolubleSolid:
                        0.5,
                    freshWashSolventFlowRate:
                        100,
                    feedUnderflowSoluteRatio:
                        0.2,
                    freshWashSoluteRatio:
                        0,
                    numberOfIdealStages:
                        3
                )
            )
        }
    }
}
