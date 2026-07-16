import Testing
@testable import ChemEToolkit

@Suite("Reactive Distillation Basics Engine")
struct ReactiveDistillationBasicsEngineTests {
    private let engine =
        ReactiveDistillationBasicsEngine()

    @Test("Stagewise product removal enhances conversion")
    func conversionEnhancement() throws {
        let result = try engine.calculate(
            .init(
                initialMolesA: 1,
                initialMolesB: 0,
                equilibriumConstant: 2,
                productRemovalFractionPerStage: 0.5,
                numberOfStages: 4
            )
        )

        #expect(
            abs(
                result.finalMolesA
                - 0.098765432098765468
            ) < 1e-12
        )
        #expect(
            abs(
                result.retainedMolesB
                - 0.098765432098765454
            ) < 1e-12
        )
        #expect(
            abs(
                result.removedMolesB
                - 0.80246913580246915
            ) < 1e-12
        )
        #expect(
            result.conversionOfInitialA
            > result.equilibriumOnlyConversion
        )
        #expect(
            abs(
                result.massBalanceClosure
                - 1
            ) < 1e-12
        )
    }

    @Test("No removal stays at equilibrium")
    func noRemoval() throws {
        let result = try engine.calculate(
            .init(
                initialMolesA: 1,
                initialMolesB: 0,
                equilibriumConstant: 2,
                productRemovalFractionPerStage: 0,
                numberOfStages: 5
            )
        )

        #expect(
            abs(
                result.conversionOfInitialA
                - 0.66666666666666674
            ) < 1e-12
        )
        #expect(result.removedMolesB == 0)
    }

    @Test("Rejects fractional stage count")
    func validation() {
        #expect(
            throws:
                ReactiveDistillationBasicsError
                    .invalidStageCount
        ) {
            try engine.calculate(
                .init(
                    initialMolesA: 1,
                    initialMolesB: 0,
                    equilibriumConstant: 2,
                    productRemovalFractionPerStage: 0.5,
                    numberOfStages: 2.5
                )
            )
        }
    }
}
