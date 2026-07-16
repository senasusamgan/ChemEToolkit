struct SplitRangeControlEngine:
    Sendable {

    func calculate(
        _ input:
            SplitRangeControlInput
    ) throws
        -> SplitRangeControlResult {

        let values = [
            input.controllerOutput,
            input.minimumControllerOutput,
            input.splitPoint,
            input.maximumControllerOutput,
            input.firstActuatorMinimum,
            input.firstActuatorMaximum,
            input.secondActuatorMinimum,
            input.secondActuatorMaximum
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SplitRangeControlError
                .nonFiniteInput
        }

        guard
            input.minimumControllerOutput
            < input.splitPoint,
            input.splitPoint
            < input.maximumControllerOutput
        else {
            throw SplitRangeControlError
                .invalidControllerRange
        }

        guard
            input.firstActuatorMinimum
            <= input.firstActuatorMaximum,
            input.secondActuatorMinimum
            <= input.secondActuatorMaximum
        else {
            throw SplitRangeControlError
                .invalidActuatorRange
        }

        let constrained =
            min(
                input.maximumControllerOutput,
                max(
                    input.minimumControllerOutput,
                    input.controllerOutput
                )
            )

        let firstFraction: Double
        let secondFraction: Double
        let activeRange: String

        if constrained
            < input.splitPoint {

            firstFraction =
                (
                    constrained
                    - input.minimumControllerOutput
                )
                / (
                    input.splitPoint
                    - input.minimumControllerOutput
                )

            secondFraction = 0
            activeRange =
                "Lower range: first actuator is active."
        } else if constrained
            > input.splitPoint {

            firstFraction = 1

            secondFraction =
                (
                    constrained
                    - input.splitPoint
                )
                / (
                    input.maximumControllerOutput
                    - input.splitPoint
                )

            activeRange =
                "Upper range: second actuator is active after the first actuator reaches full signal."
        } else {
            firstFraction = 1
            secondFraction = 0
            activeRange =
                "At split point: first actuator is at maximum and second actuator is at minimum."
        }

        let firstSignal =
            input.firstActuatorMinimum
            + firstFraction
            * (
                input.firstActuatorMaximum
                - input.firstActuatorMinimum
            )

        let secondSignal =
            input.secondActuatorMinimum
            + secondFraction
            * (
                input.secondActuatorMaximum
                - input.secondActuatorMinimum
            )

        let results = [
            constrained,
            firstFraction,
            secondFraction,
            firstSignal,
            secondSignal
        ]

        guard
            results.allSatisfy(\.isFinite),
            firstFraction >= 0,
            firstFraction <= 1,
            secondFraction >= 0,
            secondFraction <= 1
        else {
            throw SplitRangeControlError
                .numericalFailure
        }

        return .init(
            constrainedControllerOutput:
                constrained,
            firstActuatorOpeningFraction:
                firstFraction,
            secondActuatorOpeningFraction:
                secondFraction,
            firstActuatorSignal:
                firstSignal,
            secondActuatorSignal:
                secondSignal,
            activeRangeDescription:
                activeRange,
            controllerOutputWasLimited:
                constrained
                != input.controllerOutput,
            modelName:
                "Sequential split-range mapping across two actuators",
            limitationDescription:
                "Uses a non-overlapping sequential split. Real valves may require overlap, dead band, reverse action, characterization and bumpless transfer."
        )
    }
}
