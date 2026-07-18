struct HydrocycloneSeparationNumberEngine: Sendable {
    func calculate(_ input: HydrocycloneSeparationNumberInput) throws -> HydrocycloneSeparationNumberResult {
        let values = [
            input.particleDiameter, input.particleDensity, input.liquidDensity,
            input.liquidViscosity, input.tangentialVelocity, input.cycloneRadius
        ]
        guard values.allSatisfy(\.isFinite) else { throw HydrocycloneSeparationNumberError.nonFiniteInput }
        guard input.particleDiameter > 0, input.liquidViscosity > 0,
              input.tangentialVelocity > 0, input.cycloneRadius > 0 else {
            throw HydrocycloneSeparationNumberError.nonPositiveGeometryOrViscosity
        }

        let densityDifference = input.particleDensity - input.liquidDensity
        guard densityDifference > 0 else { throw HydrocycloneSeparationNumberError.invalidDensityDifference }

        let acceleration = input.tangentialVelocity * input.tangentialVelocity / input.cycloneRadius
        let gForce = acceleration / 9.80665
        let relaxation = input.particleDensity * input.particleDiameter * input.particleDiameter / (18 * input.liquidViscosity)
        let radialVelocity = densityDifference * input.particleDiameter * input.particleDiameter * acceleration / (18 * input.liquidViscosity)
        let separationNumber = radialVelocity / input.tangentialVelocity

        guard [acceleration, gForce, relaxation, radialVelocity, separationNumber].allSatisfy(\.isFinite) else {
            throw HydrocycloneSeparationNumberError.numericalFailure
        }

        return .init(
            radialSettlingVelocity: radialVelocity,
            centrifugalAcceleration: acceleration,
            centrifugalGForce: gForce,
            separationNumber: separationNumber,
            particleRelaxationTime: relaxation,
            modelName: "Stokes-regime hydrocyclone separation index",
            limitationDescription: "Uses centrifugal acceleration v_t²/r and Stokes radial settling; turbulence and hindered settling are neglected."
        )
    }
}
