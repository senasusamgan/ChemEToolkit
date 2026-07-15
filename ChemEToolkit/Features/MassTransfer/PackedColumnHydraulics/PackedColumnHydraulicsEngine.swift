import Foundation

struct PackedColumnHydraulicsEngine: Sendable {
    private let maximumModifiedReynolds = 500.0

    func calculate(
        _ input: PackedColumnHydraulicsInput
    ) throws -> PackedColumnHydraulicsResult {
        let values = [
            input.gasVolumetricFlowRate,
            input.liquidVolumetricFlowRate,
            input.floodingGasVelocity,
            input.designFractionOfFlooding,
            input.packedHeight,
            input.gasDensity,
            input.gasViscosity,
            input.bedVoidFraction,
            input.equivalentPackingDiameter
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PackedColumnHydraulicsError.nonFiniteInput
        }
        guard input.gasVolumetricFlowRate > 0,
              input.floodingGasVelocity > 0,
              input.packedHeight > 0,
              input.gasDensity > 0,
              input.gasViscosity > 0,
              input.equivalentPackingDiameter > 0 else {
            throw PackedColumnHydraulicsError.nonPositiveProperty
        }
        guard input.liquidVolumetricFlowRate >= 0 else {
            throw PackedColumnHydraulicsError.negativeLiquidFlow
        }
        guard input.designFractionOfFlooding > 0,
              input.designFractionOfFlooding < 1 else {
            throw PackedColumnHydraulicsError.invalidDesignFraction
        }
        guard input.bedVoidFraction > 0,
              input.bedVoidFraction < 1 else {
            throw PackedColumnHydraulicsError.invalidVoidFraction
        }

        let gasVelocity =
            input.floodingGasVelocity * input.designFractionOfFlooding
        let area = input.gasVolumetricFlowRate / gasVelocity
        let diameter = sqrt(4 * area / Double.pi)
        let liquidVelocity = input.liquidVolumetricFlowRate / area

        let modifiedReynolds =
            input.gasDensity
            * gasVelocity
            * input.equivalentPackingDiameter
            / (input.gasViscosity * (1 - input.bedVoidFraction))

        let isWithinModifiedReynoldsRange =
            modifiedReynolds
            < maximumModifiedReynolds
            || abs(
                modifiedReynolds
                - maximumModifiedReynolds
            ) <= 1.0e-9

        guard isWithinModifiedReynoldsRange else {
            throw PackedColumnHydraulicsError.modifiedReynoldsOutOfRange
        }

        let viscousGradient =
            150
            * input.gasViscosity
            * pow(1 - input.bedVoidFraction, 2)
            * gasVelocity
            / (
                pow(input.bedVoidFraction, 3)
                * pow(input.equivalentPackingDiameter, 2)
            )

        let inertialGradient =
            1.75
            * input.gasDensity
            * (1 - input.bedVoidFraction)
            * pow(gasVelocity, 2)
            / (
                pow(input.bedVoidFraction, 3)
                * input.equivalentPackingDiameter
            )

        let pressureGradient = viscousGradient + inertialGradient
        let totalPressureDrop = pressureGradient * input.packedHeight
        let capacityFactor = gasVelocity * sqrt(input.gasDensity)

        let assessment =
            (0.5...0.8).contains(input.designFractionOfFlooding)
            ? "The selected design fraction lies within a common preliminary range."
            : "The selected fraction is outside the common 50–80% preliminary range; review the design basis."

        let results = [
            gasVelocity, area, diameter, liquidVelocity,
            modifiedReynolds, pressureGradient,
            totalPressureDrop, capacityFactor
        ]

        guard results.allSatisfy(\.isFinite),
              gasVelocity > 0,
              area > 0,
              diameter > 0,
              pressureGradient > 0,
              totalPressureDrop > 0 else {
            throw PackedColumnHydraulicsError.nonFiniteInput
        }

        return PackedColumnHydraulicsResult(
            designGasVelocity: gasVelocity,
            columnCrossSectionalArea: area,
            columnDiameter: diameter,
            superficialLiquidVelocity: liquidVelocity,
            fractionOfFlooding: input.designFractionOfFlooding,
            gasCapacityFactor: capacityFactor,
            modifiedParticleReynoldsNumber: modifiedReynolds,
            dryPressureDropPerLength: pressureGradient,
            totalDryPressureDrop: totalPressureDrop,
            designAssessment: assessment,
            modelName: "Preliminary diameter sizing plus dry packed-bed Ergun estimate",
            limitationDescription: "The Ergun pressure drop is a dry single-gas-phase estimate. Liquid irrigation, loading and flooding corrections are not included."
        )
    }
}
