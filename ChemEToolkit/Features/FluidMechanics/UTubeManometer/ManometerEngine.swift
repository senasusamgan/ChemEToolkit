struct ManometerEngine {

    func solve(
        input: ManometerInput
    ) throws -> ManometerResult {

        try validate(input)

        let densityDifference =
            input.manometerFluidDensity
            - input.processFluidDensity

        let pressureDifference =
            densityDifference
            * input.gravity
            * input.heightDifference

        guard
            densityDifference.isFinite,
            pressureDifference.isFinite
        else {
            throw ManometerError
                .nonFiniteResult
        }

        let higherPressureSide:
            ManometerSide?

        if input.heightDifference == 0 {
            higherPressureSide = nil
        } else {
            higherPressureSide =
                input.lowerLevelSide
        }

        return ManometerResult(
            pressureDifference:
                pressureDifference,
            densityDifference:
                densityDifference,
            heightDifference:
                input.heightDifference,
            higherPressureSide:
                higherPressureSide
        )
    }

    private func validate(
        _ input: ManometerInput
    ) throws {

        guard
            input.processFluidDensity
                .isFinite,
            input.processFluidDensity > 0
        else {
            throw ManometerError
                .invalidProcessFluidDensity
        }

        guard
            input.manometerFluidDensity
                .isFinite,
            input.manometerFluidDensity > 0
        else {
            throw ManometerError
                .invalidManometerFluidDensity
        }

        guard
            input.manometerFluidDensity
                > input.processFluidDensity
        else {
            throw ManometerError
                .manometerFluidMustBeDenser
        }

        guard
            input.heightDifference.isFinite,
            input.heightDifference >= 0
        else {
            throw ManometerError
                .invalidHeightDifference
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw ManometerError
                .invalidGravity
        }
    }
}
