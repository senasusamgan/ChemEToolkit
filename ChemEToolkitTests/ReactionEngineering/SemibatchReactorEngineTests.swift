import Testing
@testable import ChemEToolkit

@Suite("Semibatch Reactor Engine")
struct SemibatchReactorEngineTests {
    private let engine =
        SemibatchReactorEngine()

    @Test("Integrates variable-volume semibatch reactor")
    func integratesSemibatch() throws {
        let result = try engine.calculate(
            .init(
                initialLiquidVolume: 1,
                initialMolesB: 1,
                feedConcentrationA: 2,
                feedVolumetricFlowRate: 0.1,
                secondOrderRateConstant: 1,
                operationTime: 5
            )
        )

        #expect(
            abs(
                result.finalLiquidVolume
                - 1.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.totalMolesAFed
                - 1
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalMolesA
                - 0.41309095265273055
            ) < 1e-8
        )
        #expect(
            abs(
                result.finalMolesB
                - 0.41309095265272422
            ) < 1e-8
        )
        #expect(
            abs(
                result.productMoles
                - 0.58690904734727034
            ) < 1e-8
        )
        #expect(
            abs(
                result.conversionOfFedA
                - 0.58690904734726945
            ) < 1e-8
        )
    }

    @Test("Semibatch mole balances close")
    func materialBalance() throws {
        let result = try engine.calculate(
            .init(
                initialLiquidVolume: 1,
                initialMolesB: 1,
                feedConcentrationA: 2,
                feedVolumetricFlowRate: 0.1,
                secondOrderRateConstant: 1,
                operationTime: 5
            )
        )

        #expect(
            abs(
                result.finalMolesA
                + result.productMoles
                - result.totalMolesAFed
            ) < 1e-8
        )

        #expect(
            abs(
                result.finalMolesB
                + result.productMoles
                - 1
            ) < 1e-8
        )
    }

    @Test("Rejects invalid semibatch inputs")
    func validation() {
        #expect(
            throws:
                SemibatchReactorError
                    .nonPositiveFeedCondition
        ) {
            try engine.calculate(
                .init(
                    initialLiquidVolume: 1,
                    initialMolesB: 1,
                    feedConcentrationA: 2,
                    feedVolumetricFlowRate: 0,
                    secondOrderRateConstant: 1,
                    operationTime: 5
                )
            )
        }

        #expect(
            throws:
                SemibatchReactorError
                    .nonPositiveOperationTime
        ) {
            try engine.calculate(
                .init(
                    initialLiquidVolume: 1,
                    initialMolesB: 1,
                    feedConcentrationA: 2,
                    feedVolumetricFlowRate: 0.1,
                    secondOrderRateConstant: 1,
                    operationTime: 0
                )
            )
        }
    }
}
