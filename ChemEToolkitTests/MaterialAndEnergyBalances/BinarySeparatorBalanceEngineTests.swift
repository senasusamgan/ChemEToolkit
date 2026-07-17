import Testing
@testable import ChemEToolkit

@Suite("Binary Separator Balance Engine")
struct BinarySeparatorBalanceEngineTests {
    private let engine =
        BinarySeparatorBalanceEngine()

    @Test("Solves second product composition")
    func separator() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                feedComponentMassFraction: 0.4,
                product1MassFlow: 30,
                product1ComponentMassFraction: 0.8
            )
        )

        #expect(result.product2MassFlow == 70)
        #expect(result.feedComponentFlow == 40)
        #expect(result.product1ComponentFlow == 24)
        #expect(result.product2ComponentFlow == 16)

        #expect(
            abs(
                result.product2ComponentMassFraction
                - 16.0 / 70.0
            ) < 1e-12
        )

        #expect(
            abs(
                result.componentRecoveryToProduct1
                - 0.6
            ) < 1e-12
        )
    }

    @Test("Zero component feed gives zero recoveries")
    func zeroComponent() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                feedComponentMassFraction: 0,
                product1MassFlow: 30,
                product1ComponentMassFraction: 0
            )
        )

        #expect(result.product2ComponentFlow == 0)
        #expect(result.componentRecoveryToProduct1 == 0)
    }

    @Test("Rejects infeasible product composition")
    func validation() {
        #expect(
            throws:
                BinarySeparatorBalanceError
                    .infeasibleComponentBalance
        ) {
            try engine.calculate(
                .init(
                    feedMassFlow: 100,
                    feedComponentMassFraction: 0.1,
                    product1MassFlow: 50,
                    product1ComponentMassFraction: 0.8
                )
            )
        }
    }
}
