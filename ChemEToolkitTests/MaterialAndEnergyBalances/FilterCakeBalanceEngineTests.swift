import Testing
@testable import ChemEToolkit

@Suite("Filter Cake Balance Engine")
struct FilterCakeBalanceEngineTests {
    private let engine =
        FilterCakeBalanceEngine()

    @Test("Calculates wet cake and filtrate")
    func filtration() throws {
        let result = try engine.calculate(
            .init(
                slurryFeedMassFlow: 1000,
                feedDrySolidMassFraction: 0.20,
                cakeLiquidMassFraction: 0.30
            )
        )

        let expectedCake =
            200.0 / 0.70

        #expect(result.drySolidFlow == 200)
        #expect(result.feedLiquidFlow == 800)

        #expect(
            abs(
                result.wetCakeMassFlow
                - expectedCake
            ) < 1e-10
        )

        #expect(
            abs(
                result.filtrateLiquidFlow
                - (
                    800
                    - (
                        expectedCake
                        - 200
                    )
                )
            ) < 1e-10
        )
    }

    @Test("Dry cake sends all liquid to filtrate")
    func dryCake() throws {
        let result = try engine.calculate(
            .init(
                slurryFeedMassFlow: 100,
                feedDrySolidMassFraction: 0.20,
                cakeLiquidMassFraction: 0
            )
        )

        #expect(result.wetCakeMassFlow == 20)
        #expect(result.filtrateLiquidFlow == 80)
    }

    @Test("Rejects infeasible cake moisture")
    func validation() {
        #expect(
            throws:
                FilterCakeBalanceError
                    .infeasibleCakeMoisture
        ) {
            try engine.calculate(
                .init(
                    slurryFeedMassFlow: 100,
                    feedDrySolidMassFraction: 0.90,
                    cakeLiquidMassFraction: 0.50
                )
            )
        }
    }
}
