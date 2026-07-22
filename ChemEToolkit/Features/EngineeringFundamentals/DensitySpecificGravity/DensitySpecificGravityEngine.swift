struct DensitySpecificGravityEngine:
    Sendable {

    func calculate(
        _ input:
            DensitySpecificGravityInput
    ) throws
        -> DensitySpecificGravityResult {

        let values = [
            input.mass,
            input.volume,
            input.referenceDensity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DensitySpecificGravityError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw DensitySpecificGravityError
                .negativeMass
        }

        guard input.volume > 0 else {
            throw DensitySpecificGravityError
                .nonPositiveVolume
        }

        guard input.referenceDensity > 0 else {
            throw DensitySpecificGravityError
                .nonPositiveReferenceDensity
        }

        let density =
            input.mass
            / input.volume

        let specificGravity =
            density
            / input.referenceDensity

        let specificVolume =
            density > 0
            ? 1 / density
            : Double.infinity

        guard
            density.isFinite,
            specificGravity.isFinite,
            specificVolume.isFinite
                || specificVolume == Double.infinity,
            density >= 0,
            specificGravity >= 0
        else {
            throw DensitySpecificGravityError
                .numericalFailure
        }

        return .init(
            density:
                density,
            specificGravity:
                specificGravity,
            specificVolume:
                specificVolume,
            modelName:
                "Density and reference-density ratio",
            limitationDescription:
                "Mass and volume must describe the same state. Density can vary with temperature, pressure and composition."
        )
    }
}
