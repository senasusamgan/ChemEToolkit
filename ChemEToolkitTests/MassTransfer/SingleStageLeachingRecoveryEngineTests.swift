import Testing
@testable import ChemEToolkit

@Suite(
    "Single-Stage Leaching and Recovery Engine"
)
struct SingleStageLeachingRecoveryEngineTests {
    private let engine =
        SingleStageLeachingRecoveryEngine()

    @Test(
        "Calculates ideal overflow recovery and underflow loss"
    )
    func calculatesRecovery() throws {
        let result = try engine.calculate(
            .init(
                insolubleSolidFlowRate: 100,
                solubleSoluteFlowRate: 20,
                pureSolventFlowRate: 100,
                retainedSolventPerInsolubleSolid:
                    0.4
            )
        )

        #expect(
            abs(
                result.equilibriumSoluteRatio
                - 0.2
            ) < 1e-12
        )
        #expect(
            abs(
                result.retainedSolventFlowRate
                - 40
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRecoveredInOverflow
                - 12
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRetainedWithUnderflow
                - 8
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRecoveryFraction
                - 0.6
            ) < 1e-12
        )
        #expect(
            abs(result.soluteBalanceResidual)
            < 1e-12
        )
    }

    @Test(
        "Handles a solute-free solid feed"
    )
    func zeroSoluteBoundary() throws {
        let result = try engine.calculate(
            .init(
                insolubleSolidFlowRate: 100,
                solubleSoluteFlowRate: 0,
                pureSolventFlowRate: 100,
                retainedSolventPerInsolubleSolid:
                    0.4
            )
        )

        #expect(
            result.equilibriumSoluteRatio
            == 0
        )
        #expect(
            result.soluteRecoveredInOverflow
            == 0
        )
        #expect(
            result.soluteRecoveryFraction
            == 0
        )
    }

    @Test(
        "Rejects invalid properties, no-overflow operation and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                SingleStageLeachingRecoveryError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        100,
                    solubleSoluteFlowRate:
                        20,
                    pureSolventFlowRate: 0,
                    retainedSolventPerInsolubleSolid:
                        0.4
                )
            )
        }

        #expect(
            throws:
                SingleStageLeachingRecoveryError
                    .noOverflowSolution
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        100,
                    solubleSoluteFlowRate:
                        20,
                    pureSolventFlowRate:
                        40,
                    retainedSolventPerInsolubleSolid:
                        0.4
                )
            )
        }

        #expect(
            throws:
                SingleStageLeachingRecoveryError
                    .negativeSoluteFlow
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        100,
                    solubleSoluteFlowRate:
                        -1,
                    pureSolventFlowRate:
                        100,
                    retainedSolventPerInsolubleSolid:
                        0.4
                )
            )
        }

        #expect(
            throws:
                SingleStageLeachingRecoveryError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    insolubleSolidFlowRate:
                        .nan,
                    solubleSoluteFlowRate:
                        20,
                    pureSolventFlowRate:
                        100,
                    retainedSolventPerInsolubleSolid:
                        0.4
                )
            )
        }
    }
}
