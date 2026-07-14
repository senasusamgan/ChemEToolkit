struct ReynoldsNumberEngine {

    func solve(
        input: ReynoldsNumberInput
    ) throws -> ReynoldsNumberResult {

        try validate(input)

        let reynoldsNumber: Double

        switch input.viscosity {
        case let .dynamic(
            density,
            dynamicViscosity
        ):
            reynoldsNumber =
                density
                * input.velocity
                * input.diameter
                / dynamicViscosity

        case let .kinematic(
            kinematicViscosity
        ):
            reynoldsNumber =
                input.velocity
                * input.diameter
                / kinematicViscosity
        }

        return ReynoldsNumberResult(
            reynoldsNumber: reynoldsNumber,
            flowRegime: FlowRegime.classify(
                reynoldsNumber: reynoldsNumber
            )
        )
    }

    private func validate(
        _ input: ReynoldsNumberInput
    ) throws {

        guard input.velocity.isFinite,
              input.velocity > 0 else {
            throw ReynoldsNumberError.invalidVelocity
        }

        guard input.diameter.isFinite,
              input.diameter > 0 else {
            throw ReynoldsNumberError.invalidDiameter
        }

        switch input.viscosity {
        case let .dynamic(
            density,
            dynamicViscosity
        ):
            guard density.isFinite,
                  density > 0 else {
                throw ReynoldsNumberError.invalidDensity
            }

            guard dynamicViscosity.isFinite,
                  dynamicViscosity > 0 else {
                throw ReynoldsNumberError
                    .invalidDynamicViscosity
            }

        case let .kinematic(
            kinematicViscosity
        ):
            guard kinematicViscosity.isFinite,
                  kinematicViscosity > 0 else {
                throw ReynoldsNumberError
                    .invalidKinematicViscosity
            }
        }
    }
}
