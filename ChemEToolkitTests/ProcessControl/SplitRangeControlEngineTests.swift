import Testing
@testable import ChemEToolkit

@Suite("Split-Range Control Engine")
struct SplitRangeControlEngineTests {
    private let engine =
        SplitRangeControlEngine()

    @Test("Maps lower and upper split ranges")
    func mapping() throws {
        let lower = try engine.calculate(
            .init(
                controllerOutput: 25,
                minimumControllerOutput: 0,
                splitPoint: 50,
                maximumControllerOutput: 100,
                firstActuatorMinimum: 0,
                firstActuatorMaximum: 100,
                secondActuatorMinimum: 0,
                secondActuatorMaximum: 100
            )
        )

        #expect(
            lower.firstActuatorOpeningFraction
            == 0.5
        )

        #expect(
            lower.secondActuatorOpeningFraction
            == 0
        )

        let upper = try engine.calculate(
            .init(
                controllerOutput: 75,
                minimumControllerOutput: 0,
                splitPoint: 50,
                maximumControllerOutput: 100,
                firstActuatorMinimum: 0,
                firstActuatorMaximum: 100,
                secondActuatorMinimum: 0,
                secondActuatorMaximum: 100
            )
        )

        #expect(
            upper.firstActuatorOpeningFraction
            == 1
        )

        #expect(
            upper.secondActuatorOpeningFraction
            == 0.5
        )
    }

    @Test("Constrains controller output")
    func outputLimiting() throws {
        let result = try engine.calculate(
            .init(
                controllerOutput: 120,
                minimumControllerOutput: 0,
                splitPoint: 50,
                maximumControllerOutput: 100,
                firstActuatorMinimum: 0,
                firstActuatorMaximum: 100,
                secondActuatorMinimum: 0,
                secondActuatorMaximum: 100
            )
        )

        #expect(
            result.constrainedControllerOutput
            == 100
        )

        #expect(
            result.secondActuatorOpeningFraction
            == 1
        )

        #expect(result.controllerOutputWasLimited)
    }

    @Test("Rejects invalid split point")
    func validation() {
        #expect(
            throws:
                SplitRangeControlError
                    .invalidControllerRange
        ) {
            try engine.calculate(
                .init(
                    controllerOutput: 50,
                    minimumControllerOutput: 0,
                    splitPoint: 100,
                    maximumControllerOutput: 100,
                    firstActuatorMinimum: 0,
                    firstActuatorMaximum: 100,
                    secondActuatorMinimum: 0,
                    secondActuatorMaximum: 100
                )
            )
        }
    }
}
