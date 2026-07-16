import Testing
@testable import ChemEToolkit

@Suite("Catalyst Regeneration Cycle Engine")
struct CatalystRegenerationCycleEngineTests {
    private let engine =
        CatalystRegenerationCycleEngine()

    @Test("Tracks repeated regeneration cycles")
    func cycles() throws {
        let result = try engine.calculate(
            .init(
                initialActivity: 1,
                deactivationRateConstant: 0.1,
                operatingTimePerCycle: 5,
                regenerationRecoveryFraction: 0.8,
                numberOfCycles: 3
            )
        )

        #expect(result.numberOfCycles == 3)
        #expect(
            abs(
                result.finalActivityBeforeRegeneration
                - 0.55301044476347472
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalActivityAfterRegeneration
                - 0.9106020889526949
            ) < 1e-12
        )
        #expect(
            abs(
                result.averageOperatingActivity
                - 0.74314979644193491
            ) < 1e-12
        )
        #expect(
            result.activityAtStartOfEachCycle.count
            == 3
        )
    }

    @Test("Full regeneration returns activity to one")
    func fullRegeneration() throws {
        let result = try engine.calculate(
            .init(
                initialActivity: 1,
                deactivationRateConstant: 0.1,
                operatingTimePerCycle: 5,
                regenerationRecoveryFraction: 1,
                numberOfCycles: 2
            )
        )

        #expect(
            abs(
                result.finalActivityAfterRegeneration
                - 1
            ) < 1e-12
        )
        #expect(
            result.activityAtStartOfEachCycle
            == [1, 1]
        )
    }

    @Test("Rejects invalid cycle definitions")
    func validation() {
        #expect(
            throws:
                CatalystRegenerationCycleError
                    .invalidCycleCount
        ) {
            try engine.calculate(
                .init(
                    initialActivity: 1,
                    deactivationRateConstant: 0.1,
                    operatingTimePerCycle: 5,
                    regenerationRecoveryFraction: 0.8,
                    numberOfCycles: 2.5
                )
            )
        }

        #expect(
            throws:
                CatalystRegenerationCycleError
                    .recoveryFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialActivity: 1,
                    deactivationRateConstant: 0.1,
                    operatingTimePerCycle: 5,
                    regenerationRecoveryFraction: 1.1,
                    numberOfCycles: 3
                )
            )
        }
    }
}
