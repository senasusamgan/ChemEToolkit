import Testing
@testable import ChemEToolkit

@Suite("Phase-Change Energy Balance Engine")
struct PhaseChangeEnergyBalanceEngineTests {
    private let engine =
        PhaseChangeEnergyBalanceEngine()

    @Test("Calculates latent duty")
    func latentDuty() throws {
        let result = try engine.calculate(
            .init(
                massFlowRate: 1.5,
                latentHeat: 2257,
                phaseChangeFraction: 0.8
            )
        )

        #expect(
            abs(
                result.transformedMassFlow
                - 1.2
            ) < 1e-12
        )

        #expect(
            abs(
                result.heatDuty
                - 2708.4
            ) < 1e-9
        )

        #expect(
            abs(
                result.specificDutyOnFeedBasis
                - 1805.6
            ) < 1e-9
        )
    }

    @Test("Zero phase-change fraction gives zero duty")
    func noPhaseChange() throws {
        let result = try engine.calculate(
            .init(
                massFlowRate: 1.5,
                latentHeat: 2257,
                phaseChangeFraction: 0
            )
        )

        #expect(result.heatDuty == 0)
        #expect(result.transformedMassFlow == 0)
    }

    @Test("Rejects fraction above one")
    func validation() {
        #expect(
            throws:
                PhaseChangeEnergyBalanceError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    massFlowRate: 1,
                    latentHeat: 1000,
                    phaseChangeFraction: 1.1
                )
            )
        }
    }
}
