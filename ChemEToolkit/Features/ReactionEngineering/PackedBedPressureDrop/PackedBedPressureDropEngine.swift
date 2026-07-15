struct PackedBedPressureDropEngine:
    Sendable {

    func calculate(
        _ input:
            PackedBedPressureDropInput
    ) throws
        -> PackedBedPressureDropResult {

        let values = [
            input.fluidDensity,
            input.fluidViscosity,
            input.superficialVelocity,
            input.particleDiameter,
            input.bedVoidFraction,
            input.bedLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PackedBedPressureDropError
                .nonFiniteInput
        }

        guard
            input.fluidDensity > 0,
            input.fluidViscosity > 0,
            input.superficialVelocity > 0
        else {
            throw PackedBedPressureDropError
                .nonPositiveFluidProperty
        }

        guard
            input.particleDiameter > 0,
            input.bedLength > 0
        else {
            throw PackedBedPressureDropError
                .nonPositiveGeometry
        }

        guard
            input.bedVoidFraction > 0,
            input.bedVoidFraction < 1
        else {
            throw PackedBedPressureDropError
                .voidFractionOutOfRange
        }

        let oneMinusVoid =
            1 - input.bedVoidFraction

        let voidCubed =
            input.bedVoidFraction
            * input.bedVoidFraction
            * input.bedVoidFraction

        let particleDiameterSquared =
            input.particleDiameter
            * input.particleDiameter

        let viscousGradient =
            150
            * input.fluidViscosity
            * oneMinusVoid
            * oneMinusVoid
            / (
                voidCubed
                * particleDiameterSquared
            )
            * input.superficialVelocity

        let inertialGradient =
            1.75
            * input.fluidDensity
            * oneMinusVoid
            / (
                voidCubed
                * input.particleDiameter
            )
            * input.superficialVelocity
            * input.superficialVelocity

        let totalGradient =
            viscousGradient
            + inertialGradient

        let viscousDrop =
            viscousGradient
            * input.bedLength

        let inertialDrop =
            inertialGradient
            * input.bedLength

        let totalDrop =
            totalGradient
            * input.bedLength

        let particleReynolds =
            input.fluidDensity
            * input.superficialVelocity
            * input.particleDiameter
            / input.fluidViscosity

        let viscousFraction =
            viscousGradient
            / totalGradient

        let inertialFraction =
            inertialGradient
            / totalGradient

        let results = [
            viscousGradient,
            inertialGradient,
            totalGradient,
            viscousDrop,
            inertialDrop,
            totalDrop,
            particleReynolds,
            viscousFraction,
            inertialFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            viscousGradient > 0,
            inertialGradient > 0,
            totalGradient > 0,
            viscousDrop > 0,
            inertialDrop > 0,
            totalDrop > 0,
            particleReynolds > 0,
            viscousFraction > 0,
            viscousFraction < 1,
            inertialFraction > 0,
            inertialFraction < 1
        else {
            throw PackedBedPressureDropError
                .numericalFailure
        }

        return .init(
            viscousPressureGradient:
                viscousGradient,
            inertialPressureGradient:
                inertialGradient,
            totalPressureGradient:
                totalGradient,
            viscousPressureDrop:
                viscousDrop,
            inertialPressureDrop:
                inertialDrop,
            totalPressureDrop:
                totalDrop,
            particleReynoldsNumber:
                particleReynolds,
            viscousContributionFraction:
                viscousFraction,
            inertialContributionFraction:
                inertialFraction,
            modelName:
                "Ergun equation for pressure drop through a packed bed",
            limitationDescription:
                "Assumes a uniformly packed bed of approximately spherical particles, steady single-phase flow and constant fluid properties over the bed."
        )
    }
}
