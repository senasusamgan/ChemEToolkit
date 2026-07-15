import Testing
@testable import ChemEToolkit

@Suite("Centrifugal Settling Time Engine")
struct CentrifugalSettlingTimeEngineTests {
    private let engine =
        CentrifugalSettlingTimeEngine()

    @Test(
        "Calculates radial migration time and Stokes validity"
    )
    func calculatesSettlingTime()
        throws {

        let result = try engine.calculate(
            .init(
                particleDiameter: 4e-6,
                particleDensity: 2500,
                fluidDensity: 1000,
                fluidViscosity: 0.001,
                rotationalSpeedRPM: 3000,
                initialRadius: 0.05,
                finalRadius: 0.15
            )
        )

        #expect(
            abs(
                result.angularVelocity
                - 314.1592653589793
            ) < 1e-12
        )
        #expect(
            abs(
                result.radialResponseCoefficient
                - 0.1315947253478581
            ) < 1e-14
        )
        #expect(
            abs(
                result.migrationTime
                - 8.348452308890291
            ) < 1e-12
        )
        #expect(
            abs(
                result.outerRadialVelocity
                - 0.019739208802178713
            ) < 1e-15
        )
        #expect(
            abs(
                result.outerParticleReynoldsNumber
                - 0.07895683520871484
            ) < 1e-14
        )
        #expect(
            abs(
                result.outerRelativeCentrifugalForce
                - 1509.6293435203702
            ) < 1e-9
        )
    }

    @Test(
        "Doubling rotational speed quarters migration time"
    )
    func speedScaling() throws {
        let base = try engine.calculate(
            .init(
                particleDiameter: 2e-6,
                particleDensity: 2500,
                fluidDensity: 1000,
                fluidViscosity: 0.001,
                rotationalSpeedRPM: 3000,
                initialRadius: 0.05,
                finalRadius: 0.15
            )
        )

        let faster = try engine.calculate(
            .init(
                particleDiameter: 2e-6,
                particleDensity: 2500,
                fluidDensity: 1000,
                fluidViscosity: 0.001,
                rotationalSpeedRPM: 6000,
                initialRadius: 0.05,
                finalRadius: 0.15
            )
        )

        #expect(
            abs(
                faster.migrationTime
                - base.migrationTime / 4
            ) < 1e-12
        )
    }

    @Test(
        "Rejects invalid density, radii and Stokes regime"
    )
    func validation() {
        #expect(
            throws:
                CentrifugalSettlingTimeError
                    .particleNotDenserThanFluid
        ) {
            try engine.calculate(
                .init(
                    particleDiameter:
                        4e-6,
                    particleDensity: 900,
                    fluidDensity: 1000,
                    fluidViscosity:
                        0.001,
                    rotationalSpeedRPM:
                        3000,
                    initialRadius: 0.05,
                    finalRadius: 0.15
                )
            )
        }

        #expect(
            throws:
                CentrifugalSettlingTimeError
                    .invalidRadiusOrdering
        ) {
            try engine.calculate(
                .init(
                    particleDiameter:
                        4e-6,
                    particleDensity:
                        2500,
                    fluidDensity: 1000,
                    fluidViscosity:
                        0.001,
                    rotationalSpeedRPM:
                        3000,
                    initialRadius: 0.15,
                    finalRadius: 0.05
                )
            )
        }

        #expect(
            throws:
                CentrifugalSettlingTimeError
                    .stokesRegimeExceeded
        ) {
            try engine.calculate(
                .init(
                    particleDiameter:
                        10e-6,
                    particleDensity:
                        2500,
                    fluidDensity: 1000,
                    fluidViscosity:
                        0.001,
                    rotationalSpeedRPM:
                        3000,
                    initialRadius: 0.05,
                    finalRadius: 0.15
                )
            )
        }

        #expect(
            throws:
                CentrifugalSettlingTimeError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    particleDiameter:
                        .nan,
                    particleDensity:
                        2500,
                    fluidDensity: 1000,
                    fluidViscosity:
                        0.001,
                    rotationalSpeedRPM:
                        3000,
                    initialRadius: 0.05,
                    finalRadius: 0.15
                )
            )
        }
    }
}
