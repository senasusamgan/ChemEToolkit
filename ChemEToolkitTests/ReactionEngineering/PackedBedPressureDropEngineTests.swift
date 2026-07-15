import Testing
@testable import ChemEToolkit

@Suite("Packed-Bed Pressure Drop Engine")
struct PackedBedPressureDropEngineTests {
    private let engine =
        PackedBedPressureDropEngine()

    @Test("Calculates Ergun pressure drop")
    func calculatesPressureDrop() throws {
        let result = try engine.calculate(
            .init(
                fluidDensity: 1.2,
                fluidViscosity: 1.8e-5,
                superficialVelocity: 0.2,
                particleDiameter: 0.005,
                bedVoidFraction: 0.4,
                bedLength: 2
            )
        )

        #expect(
            abs(
                result.viscousPressureGradient
                - 121.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.inertialPressureGradient
                - 157.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.totalPressureDrop
                - 558
            ) < 1e-12
        )
        #expect(
            abs(
                result.particleReynoldsNumber
                - 66.66666666666666
            ) < 1e-12
        )
        #expect(
            abs(
                result.viscousContributionFraction
                - 0.4354838709677419
            ) < 1e-12
        )
    }

    @Test("Doubling bed length doubles pressure drop")
    func lengthScaling() throws {
        let shortBed = try engine.calculate(
            .init(
                fluidDensity: 1.2,
                fluidViscosity: 1.8e-5,
                superficialVelocity: 0.2,
                particleDiameter: 0.005,
                bedVoidFraction: 0.4,
                bedLength: 2
            )
        )

        let longBed = try engine.calculate(
            .init(
                fluidDensity: 1.2,
                fluidViscosity: 1.8e-5,
                superficialVelocity: 0.2,
                particleDiameter: 0.005,
                bedVoidFraction: 0.4,
                bedLength: 4
            )
        )

        #expect(
            abs(
                longBed.totalPressureDrop
                - 2
                * shortBed.totalPressureDrop
            ) < 1e-12
        )
    }

    @Test("Rejects invalid properties and geometry")
    func validation() {
        #expect(
            throws:
                PackedBedPressureDropError
                    .voidFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    fluidDensity: 1.2,
                    fluidViscosity: 1.8e-5,
                    superficialVelocity: 0.2,
                    particleDiameter: 0.005,
                    bedVoidFraction: 1,
                    bedLength: 2
                )
            )
        }

        #expect(
            throws:
                PackedBedPressureDropError
                    .nonPositiveGeometry
        ) {
            try engine.calculate(
                .init(
                    fluidDensity: 1.2,
                    fluidViscosity: 1.8e-5,
                    superficialVelocity: 0.2,
                    particleDiameter: 0,
                    bedVoidFraction: 0.4,
                    bedLength: 2
                )
            )
        }

        #expect(
            throws:
                PackedBedPressureDropError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    fluidDensity: .nan,
                    fluidViscosity: 1.8e-5,
                    superficialVelocity: 0.2,
                    particleDiameter: 0.005,
                    bedVoidFraction: 0.4,
                    bedLength: 2
                )
            )
        }
    }
}
