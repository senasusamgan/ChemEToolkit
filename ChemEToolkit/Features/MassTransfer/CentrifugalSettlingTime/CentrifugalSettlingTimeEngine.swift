import Foundation

struct CentrifugalSettlingTimeEngine:
    Sendable {

    private let maximumParticleReynolds =
        0.20

    private let comparisonTolerance =
        1.0e-10

    private let standardGravity =
        9.80665

    func calculate(
        _ input:
            CentrifugalSettlingTimeInput
    ) throws
        -> CentrifugalSettlingTimeResult {

        let values = [
            input.particleDiameter,
            input.particleDensity,
            input.fluidDensity,
            input.fluidViscosity,
            input.rotationalSpeedRPM,
            input.initialRadius,
            input.finalRadius
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CentrifugalSettlingTimeError
                .nonFiniteInput
        }

        guard
            input.particleDiameter > 0,
            input.particleDensity > 0,
            input.fluidDensity > 0,
            input.fluidViscosity > 0,
            input.rotationalSpeedRPM > 0,
            input.initialRadius > 0,
            input.finalRadius > 0
        else {
            throw CentrifugalSettlingTimeError
                .nonPositiveProperty
        }

        guard
            input.particleDensity
            > input.fluidDensity
        else {
            throw CentrifugalSettlingTimeError
                .particleNotDenserThanFluid
        }

        guard
            input.finalRadius
            > input.initialRadius
        else {
            throw CentrifugalSettlingTimeError
                .invalidRadiusOrdering
        }

        let angularVelocity =
            2
            * Double.pi
            * input.rotationalSpeedRPM
            / 60

        let densityDifference =
            input.particleDensity
            - input.fluidDensity

        let responseCoefficient =
            input.particleDiameter
            * input.particleDiameter
            * densityDifference
            * angularVelocity
            * angularVelocity
            / (
                18
                * input.fluidViscosity
            )

        let innerVelocity =
            responseCoefficient
            * input.initialRadius

        let outerVelocity =
            responseCoefficient
            * input.finalRadius

        let outerReynolds =
            input.fluidDensity
            * outerVelocity
            * input.particleDiameter
            / input.fluidViscosity

        let reynoldsTolerance =
            max(
                1.0,
                maximumParticleReynolds
            )
            * comparisonTolerance

        guard
            outerReynolds
            <= maximumParticleReynolds
            + reynoldsTolerance
        else {
            throw CentrifugalSettlingTimeError
                .stokesRegimeExceeded
        }

        let migrationTime =
            log(
                input.finalRadius
                / input.initialRadius
            )
            / responseCoefficient

        let migrationDistance =
            input.finalRadius
            - input.initialRadius

        let outerAcceleration =
            angularVelocity
            * angularVelocity
            * input.finalRadius

        let outerRCF =
            outerAcceleration
            / standardGravity

        let results = [
            angularVelocity,
            responseCoefficient,
            innerVelocity,
            outerVelocity,
            migrationDistance,
            migrationTime,
            outerAcceleration,
            outerRCF,
            outerReynolds,
            densityDifference
        ]

        guard
            results.allSatisfy(\.isFinite),
            angularVelocity > 0,
            responseCoefficient > 0,
            innerVelocity > 0,
            outerVelocity > innerVelocity,
            migrationDistance > 0,
            migrationTime > 0,
            outerAcceleration > 0,
            outerRCF > 0,
            outerReynolds > 0,
            densityDifference > 0
        else {
            throw CentrifugalSettlingTimeError
                .numericalFailure
        }

        return CentrifugalSettlingTimeResult(
            angularVelocity:
                angularVelocity,
            radialResponseCoefficient:
                responseCoefficient,
            innerRadialVelocity:
                innerVelocity,
            outerRadialVelocity:
                outerVelocity,
            migrationDistance:
                migrationDistance,
            migrationTime:
                migrationTime,
            outerCentrifugalAcceleration:
                outerAcceleration,
            outerRelativeCentrifugalForce:
                outerRCF,
            outerParticleReynoldsNumber:
                outerReynolds,
            densityDifference:
                densityDifference,
            modelName:
                "Integrated Stokes radial-settling model in a rigid-body centrifugal field",
            limitationDescription:
                "Assumes isolated spherical particles, creeping flow, no hindered settling, no Brownian diffusion, constant fluid properties and outward motion of particles denser than the liquid."
        )
    }
}
