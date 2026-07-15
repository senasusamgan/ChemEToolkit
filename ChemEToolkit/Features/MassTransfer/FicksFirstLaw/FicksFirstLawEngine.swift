struct FicksFirstLawEngine: Sendable {
    func calculate(_ input: FicksFirstLawInput) throws -> FicksFirstLawResult {
        guard input.diffusivity.isFinite,
              input.concentrationGradient.isFinite else {
            throw FicksFirstLawError.nonFiniteInput
        }
        guard input.diffusivity > 0 else {
            throw FicksFirstLawError.nonPositiveDiffusivity
        }

        let flux = -input.diffusivity * input.concentrationGradient
        let direction = flux == 0
            ? "No net diffusive transport"
            : flux > 0
                ? "Positive coordinate direction"
                : "Negative coordinate direction"

        return FicksFirstLawResult(
            molarFlux: flux,
            directionDescription: direction
        )
    }
}
