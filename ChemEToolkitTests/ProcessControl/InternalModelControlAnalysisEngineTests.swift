import Testing
@testable import ChemEToolkit

@Suite("Internal Model Control Analysis Engine")
struct InternalModelControlAnalysisEngineTests {
    private let engine =
        InternalModelControlAnalysisEngine()

    @Test("Calculates IMC controller and nominal response")
    func analysis() throws {
        let result = try engine.calculate(
            .init(
                actualProcessGain: 2,
                actualTimeConstant: 10,
                modelProcessGain: 1.9,
                modelTimeConstant: 9.5,
                modelDeadTime: 2,
                filterTimeConstant: 4,
                angularFrequency: 0.1
            )
        )

        #expect(
            abs(
                result.equivalentPIControllerGain
                - 0.83333333333333348
            ) < 1e-12
        )

        #expect(
            result.equivalentPIIntegralTime
            == 9.5
        )

        #expect(
            abs(
                result.imcControllerMagnitude
                - 0.67403079220137252
            ) < 1e-12
        )

        #expect(
            abs(
                result.imcControllerPhaseDegrees
                - 21.729789799262367
            ) < 1e-12
        )

        #expect(
            abs(
                result.nominalClosedLoopMagnitude
                - 0.92847669088525919
            ) < 1e-12
        )

        #expect(
            abs(
                result.nominalClosedLoopPhaseDegrees
                - -33.260565388968274
            ) < 1e-12
        )
    }

    @Test("Larger filter reduces nominal bandwidth")
    func filterTradeoff() throws {
        let fast = try engine.calculate(
            .init(
                actualProcessGain: 2,
                actualTimeConstant: 10,
                modelProcessGain: 2,
                modelTimeConstant: 10,
                modelDeadTime: 2,
                filterTimeConstant: 2,
                angularFrequency: 0.5
            )
        )

        let robust = try engine.calculate(
            .init(
                actualProcessGain: 2,
                actualTimeConstant: 10,
                modelProcessGain: 2,
                modelTimeConstant: 10,
                modelDeadTime: 2,
                filterTimeConstant: 8,
                angularFrequency: 0.5
            )
        )

        #expect(
            robust.nominalClosedLoopMagnitude
            < fast.nominalClosedLoopMagnitude
        )
    }

    @Test("Rejects invalid IMC parameters")
    func validation() {
        #expect(
            throws:
                InternalModelControlAnalysisError
                    .zeroProcessGain
        ) {
            try engine.calculate(
                .init(
                    actualProcessGain: 2,
                    actualTimeConstant: 10,
                    modelProcessGain: 0,
                    modelTimeConstant: 9.5,
                    modelDeadTime: 2,
                    filterTimeConstant: 4,
                    angularFrequency: 0.1
                )
            )
        }
    }
}
