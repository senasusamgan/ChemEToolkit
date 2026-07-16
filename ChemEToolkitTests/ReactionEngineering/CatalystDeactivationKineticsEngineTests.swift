import Testing
@testable import ChemEToolkit

@Suite("Catalyst Deactivation Kinetics Engine")
struct CatalystDeactivationKineticsEngineTests {
    private let engine =
        CatalystDeactivationKineticsEngine()

    @Test("Calculates first-order activity decay")
    func firstOrder() throws {
        let result = try engine.calculate(
            .init(
                initialActivity: 1,
                deactivationRateConstant: 0.1,
                deactivationOrder: 1,
                elapsedTime: 5,
                targetActivity: 0.5
            )
        )

        #expect(
            abs(
                result.currentActivity
                - 0.60653065971263342
            ) < 1e-12
        )
        #expect(
            abs(
                result.timeToTargetActivity
                - 6.9314718055994522
            ) < 1e-12
        )
        #expect(
            result.finiteExtinctionTime
            == nil
        )
    }

    @Test("Handles zero and second-order models")
    func otherOrders() throws {
        let zero = try engine.calculate(
            .init(
                initialActivity: 1,
                deactivationRateConstant: 0.1,
                deactivationOrder: 0,
                elapsedTime: 5,
                targetActivity: 0.5
            )
        )

        #expect(
            abs(
                zero.currentActivity
                - 0.5
            ) < 1e-12
        )
        #expect(
            abs(
                zero.finiteExtinctionTime!
                - 10
            ) < 1e-12
        )

        let second = try engine.calculate(
            .init(
                initialActivity: 1,
                deactivationRateConstant: 0.1,
                deactivationOrder: 2,
                elapsedTime: 5,
                targetActivity: 0.5
            )
        )

        #expect(
            abs(
                second.currentActivity
                - 2.0 / 3.0
            ) < 1e-12
        )
    }

    @Test("Rejects invalid deactivation inputs")
    func validation() {
        #expect(
            throws:
                CatalystDeactivationKineticsError
                    .deactivationOrderOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialActivity: 1,
                    deactivationRateConstant: 0.1,
                    deactivationOrder: 3,
                    elapsedTime: 5,
                    targetActivity: 0.5
                )
            )
        }

        #expect(
            throws:
                CatalystDeactivationKineticsError
                    .targetActivityOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialActivity: 1,
                    deactivationRateConstant: 0.1,
                    deactivationOrder: 1,
                    elapsedTime: 5,
                    targetActivity: 1
                )
            )
        }
    }
}
