struct DragForceEngine {

    func solve(
        input: DragForceInput
    ) throws -> DragForceResult {

        try validate(input)

        let dynamicPressure =
            0.5
            * input.fluidDensity
            * input.relativeVelocity
            * input.relativeVelocity

        let dragForce =
            dynamicPressure
            * input.dragCoefficient
            * input.projectedArea

        let dragPower =
            dragForce
            * input.relativeVelocity

        guard dynamicPressure.isFinite,
              dragForce.isFinite,
              dragPower.isFinite else {
            throw DragForceError.nonFiniteResult
        }

        return DragForceResult(
            dynamicPressure: dynamicPressure,
            dragForce: dragForce,
            dragPower: dragPower,
            fluidDensity: input.fluidDensity,
            relativeVelocity: input.relativeVelocity,
            projectedArea: input.projectedArea,
            dragCoefficient: input.dragCoefficient
        )
    }

    private func validate(
        _ input: DragForceInput
    ) throws {

        guard input.fluidDensity.isFinite,
              input.fluidDensity > 0 else {
            throw DragForceError.invalidFluidDensity
        }

        guard input.relativeVelocity.isFinite,
              input.relativeVelocity >= 0 else {
            throw DragForceError.invalidVelocity
        }

        guard input.projectedArea.isFinite,
              input.projectedArea > 0 else {
            throw DragForceError.invalidProjectedArea
        }

        guard input.dragCoefficient.isFinite,
              input.dragCoefficient >= 0 else {
            throw DragForceError.invalidDragCoefficient
        }
    }
}
