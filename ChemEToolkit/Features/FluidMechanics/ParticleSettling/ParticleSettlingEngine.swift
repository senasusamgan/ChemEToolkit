struct ParticleSettlingEngine {

    func solve(
        input: ParticleSettlingInput
    ) throws -> ParticleSettlingResult {

        try validate(input)

        let densityDifference =
            input.particleDensity
            - input.fluidDensity

        let signedTerminalVelocity =
            densityDifference
            * input.gravity
            * input.particleDiameter
            * input.particleDiameter
            / (18 * input.dynamicViscosity)

        let terminalSpeed =
            abs(signedTerminalVelocity)

        let particleReynoldsNumber =
            input.fluidDensity
            * terminalSpeed
            * input.particleDiameter
            / input.dynamicViscosity

        let motionDirection:
            ParticleMotionDirection

        if densityDifference > 0 {
            motionDirection = .settling
        } else if densityDifference < 0 {
            motionDirection = .rising
        } else {
            motionDirection = .neutral
        }

        guard densityDifference.isFinite,
              signedTerminalVelocity.isFinite,
              terminalSpeed.isFinite,
              particleReynoldsNumber.isFinite else {
            throw ParticleSettlingError.nonFiniteResult
        }

        return ParticleSettlingResult(
            signedTerminalVelocity:
                signedTerminalVelocity,
            terminalSpeed: terminalSpeed,
            particleReynoldsNumber:
                particleReynoldsNumber,
            densityDifference:
                densityDifference,
            motionDirection:
                motionDirection,
            particleDiameter:
                input.particleDiameter,
            particleDensity:
                input.particleDensity,
            fluidDensity:
                input.fluidDensity
        )
    }

    private func validate(
        _ input: ParticleSettlingInput
    ) throws {

        guard input.particleDensity.isFinite,
              input.particleDensity > 0 else {
            throw ParticleSettlingError
                .invalidParticleDensity
        }

        guard input.fluidDensity.isFinite,
              input.fluidDensity > 0 else {
            throw ParticleSettlingError
                .invalidFluidDensity
        }

        guard input.particleDiameter.isFinite,
              input.particleDiameter > 0 else {
            throw ParticleSettlingError
                .invalidParticleDiameter
        }

        guard input.dynamicViscosity.isFinite,
              input.dynamicViscosity > 0 else {
            throw ParticleSettlingError
                .invalidDynamicViscosity
        }

        guard input.gravity.isFinite,
              input.gravity > 0 else {
            throw ParticleSettlingError
                .invalidGravity
        }
    }
}
