import Testing
@testable import ChemEToolkit

@Suite("Membrane Gas Separation Engine")
struct MembraneGasSeparationEngineTests {
    private let engine =
        MembraneGasSeparationEngine()

    @Test(
        "Solves self-consistent permeate composition, flux and recovery"
    )
    func solvesBinaryPermeation() throws {
        let result = try engine.calculate(
            .init(
                feedMolarFlowRate: 1,
                membraneArea: 10,
                feedPressureBar: 10,
                permeatePressureBar: 1,
                feedFastComponentMoleFraction:
                    0.2,
                fastComponentPermeanceGPU:
                    100,
                slowComponentPermeanceGPU:
                    10
            )
        )

        #expect(
            abs(
                result.idealSelectivity
                - 10
            ) < 1e-12
        )
        #expect(
            abs(
                result
                    .permeateFastComponentMoleFraction
                - 0.640251199682556
            ) < 1e-10
        )
        #expect(
            abs(
                result.fastComponentFlux
                - 0.004552438983462802
            ) < 1e-12
        )
        #expect(
            abs(
                result.slowComponentFlux
                - 0.0025579561016537203
            ) < 1e-12
        )
        #expect(
            abs(
                result.stageCut
                - 0.07110395085116522
            ) < 1e-10
        )
        #expect(
            abs(
                result.fastComponentRecovery
                - 0.2276219491731401
            ) < 1e-10
        )
    }

    @Test(
        "Uses the zero-permeate-pressure analytical purity limit"
    )
    func vacuumBoundary() throws {
        let result = try engine.calculate(
            .init(
                feedMolarFlowRate: 1,
                membraneArea: 1,
                feedPressureBar: 10,
                permeatePressureBar: 0,
                feedFastComponentMoleFraction:
                    0.2,
                fastComponentPermeanceGPU:
                    100,
                slowComponentPermeanceGPU:
                    10
            )
        )

        #expect(
            abs(
                result
                    .permeateFastComponentMoleFraction
                - 0.7142857142857143
            ) < 1e-10
        )
        #expect(
            result.pressureRatio == 0
        )
    }

    @Test(
        "Rejects invalid pressure, composition, permeance ordering and high stage cut"
    )
    func validation() {
        #expect(
            throws:
                MembraneGasSeparationError
                    .invalidPressureOrdering
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlowRate: 1,
                    membraneArea: 10,
                    feedPressureBar: 1,
                    permeatePressureBar: 1,
                    feedFastComponentMoleFraction:
                        0.2,
                    fastComponentPermeanceGPU:
                        100,
                    slowComponentPermeanceGPU:
                        10
                )
            )
        }

        #expect(
            throws:
                MembraneGasSeparationError
                    .feedCompositionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlowRate: 1,
                    membraneArea: 10,
                    feedPressureBar: 10,
                    permeatePressureBar: 1,
                    feedFastComponentMoleFraction:
                        1,
                    fastComponentPermeanceGPU:
                        100,
                    slowComponentPermeanceGPU:
                        10
                )
            )
        }

        #expect(
            throws:
                MembraneGasSeparationError
                    .invalidPermeanceOrdering
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlowRate: 1,
                    membraneArea: 10,
                    feedPressureBar: 10,
                    permeatePressureBar: 1,
                    feedFastComponentMoleFraction:
                        0.2,
                    fastComponentPermeanceGPU:
                        10,
                    slowComponentPermeanceGPU:
                        100
                )
            )
        }

        #expect(
            throws:
                MembraneGasSeparationError
                    .stageCutOutsideLowStageCutApproximation
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlowRate: 1,
                    membraneArea: 100,
                    feedPressureBar: 10,
                    permeatePressureBar: 1,
                    feedFastComponentMoleFraction:
                        0.2,
                    fastComponentPermeanceGPU:
                        100,
                    slowComponentPermeanceGPU:
                        10
                )
            )
        }

        #expect(
            throws:
                MembraneGasSeparationError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlowRate: .nan,
                    membraneArea: 10,
                    feedPressureBar: 10,
                    permeatePressureBar: 1,
                    feedFastComponentMoleFraction:
                        0.2,
                    fastComponentPermeanceGPU:
                        100,
                    slowComponentPermeanceGPU:
                        10
                )
            )
        }
    }
}
