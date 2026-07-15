struct SteadyStateDiffusionEngine: Sendable {
    func calculate(_ input: SteadyStateDiffusionInput) throws -> SteadyStateDiffusionResult {
        let values = [
            input.diffusivity,
            input.area,
            input.thickness,
            input.concentrationAtSideOne,
            input.concentrationAtSideTwo
        ]
        guard values.allSatisfy(\.isFinite) else {
            throw SteadyStateDiffusionError.nonFiniteInput
        }
        guard input.diffusivity > 0, input.area > 0, input.thickness > 0 else {
            throw SteadyStateDiffusionError.nonPositiveGeometryOrDiffusivity
        }
        guard input.concentrationAtSideOne >= 0,
              input.concentrationAtSideTwo >= 0 else {
            throw SteadyStateDiffusionError.negativeConcentration
        }

        let flux = input.diffusivity
            * (input.concentrationAtSideOne - input.concentrationAtSideTwo)
            / input.thickness

        return SteadyStateDiffusionResult(
            molarFlux: flux,
            molarRate: flux * input.area,
            midpointConcentration: 0.5
                * (input.concentrationAtSideOne + input.concentrationAtSideTwo)
        )
    }
}
