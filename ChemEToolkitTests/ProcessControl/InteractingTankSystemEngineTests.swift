import Testing
@testable import ChemEToolkit

@Suite("Interacting Tank System Engine")
struct InteractingTankSystemEngineTests {
    private let engine =
        InteractingTankSystemEngine()

    @Test("Calculates coupled tank response")
    func coupledResponse() throws {
        let result = try engine.calculate(
            .init(
                firstTankArea: 2,
                secondTankArea: 1,
                interTankResistance: 3,
                outletResistance: 4,
                inletFlowStepChange: 0.5,
                evaluationTime: 5
            )
        )

        #expect(result.denominatorQuadraticCoefficient == 24)
        #expect(result.denominatorLinearCoefficient == 18)

        #expect(
            abs(
                result.naturalFrequency
                - 0.20412414523193154
            ) < 1e-12
        )

        #expect(
            abs(
                result.dampingRatio
                - 1.8371173070873836
            ) < 1e-12
        )

        #expect(result.dampingRegime == "Overdamped")

        #expect(
            abs(
                result.outletLevelChange
                - 0.38561401362524572
            ) < 1e-12
        )

        #expect(result.finalOutletLevelChange == 2)
        #expect(result.finalFirstTankLevelChange == 3.5)
    }

    @Test("Poles remain in the left half plane")
    func stablePoles() throws {
        let result = try engine.calculate(
            .init(
                firstTankArea: 2,
                secondTankArea: 1,
                interTankResistance: 3,
                outletResistance: 4,
                inletFlowStepChange: 0.5,
                evaluationTime: 5
            )
        )

        #expect(result.slowPole < 0)
        #expect(result.fastPole < 0)
        #expect(result.slowPole > result.fastPole)
    }

    @Test("Rejects invalid resistance")
    func validation() {
        #expect(
            throws:
                InteractingTankSystemError
                    .nonPositiveTankProperty
        ) {
            try engine.calculate(
                .init(
                    firstTankArea: 2,
                    secondTankArea: 1,
                    interTankResistance: 0,
                    outletResistance: 4,
                    inletFlowStepChange: 0.5,
                    evaluationTime: 5
                )
            )
        }
    }
}
