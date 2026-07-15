import Testing
@testable import ChemEToolkit

@Suite("Packed-Column Hydraulics Engine")
struct PackedColumnHydraulicsEngineTests {
    private let engine = PackedColumnHydraulicsEngine()

    @Test("Sizes the column and calculates dry Ergun pressure drop")
    func calculatesHydraulics() throws {
        let result = try engine.calculate(
            .init(
                gasVolumetricFlowRate: 0.005,
                liquidVolumetricFlowRate: 0.001,
                floodingGasVelocity: 0.1,
                designFractionOfFlooding: 0.6,
                packedHeight: 3,
                gasDensity: 1.2,
                gasViscosity: 1.8e-5,
                bedVoidFraction: 0.4,
                equivalentPackingDiameter: 0.005
            )
        )

        #expect(abs(result.designGasVelocity - 0.06) < 1e-12)
        #expect(abs(result.columnCrossSectionalArea - 0.08333333333333334) < 1e-12)
        #expect(abs(result.columnDiameter - 0.32573500793528) < 1e-12)
        #expect(abs(result.modifiedParticleReynoldsNumber - 33.33333333333333) < 1e-10)
        #expect(abs(result.dryPressureDropPerLength - 50.625) < 1e-10)
        #expect(abs(result.totalDryPressureDrop - 151.875) < 1e-10)
    }

    @Test("Accepts the conservative modified-Reynolds boundary")
    func reynoldsBoundary() throws {
        let result = try engine.calculate(
            .init(
                gasVolumetricFlowRate: 0.01,
                liquidVolumetricFlowRate: 0,
                floodingGasVelocity: 0.2,
                designFractionOfFlooding: 0.5,
                packedHeight: 1,
                gasDensity: 1,
                gasViscosity: 4e-6,
                bedVoidFraction: 0.5,
                equivalentPackingDiameter: 0.01
            )
        )

        #expect(abs(result.modifiedParticleReynoldsNumber - 500) < 1e-10)
    }

    @Test("Rejects invalid fractions, voidage, high Reynolds and nonfinite values")
    func validation() {
        #expect(throws: PackedColumnHydraulicsError.invalidDesignFraction) {
            try engine.calculate(.init(
                gasVolumetricFlowRate: 0.005,
                liquidVolumetricFlowRate: 0.001,
                floodingGasVelocity: 0.1,
                designFractionOfFlooding: 1,
                packedHeight: 3,
                gasDensity: 1.2,
                gasViscosity: 1.8e-5,
                bedVoidFraction: 0.4,
                equivalentPackingDiameter: 0.005
            ))
        }

        #expect(throws: PackedColumnHydraulicsError.invalidVoidFraction) {
            try engine.calculate(.init(
                gasVolumetricFlowRate: 0.005,
                liquidVolumetricFlowRate: 0.001,
                floodingGasVelocity: 0.1,
                designFractionOfFlooding: 0.6,
                packedHeight: 3,
                gasDensity: 1.2,
                gasViscosity: 1.8e-5,
                bedVoidFraction: 1,
                equivalentPackingDiameter: 0.005
            ))
        }

        #expect(throws: PackedColumnHydraulicsError.modifiedReynoldsOutOfRange) {
            try engine.calculate(.init(
                gasVolumetricFlowRate: 0.005,
                liquidVolumetricFlowRate: 0.001,
                floodingGasVelocity: 1,
                designFractionOfFlooding: 0.8,
                packedHeight: 3,
                gasDensity: 1.2,
                gasViscosity: 1.8e-5,
                bedVoidFraction: 0.4,
                equivalentPackingDiameter: 0.01
            ))
        }

        #expect(throws: PackedColumnHydraulicsError.nonFiniteInput) {
            try engine.calculate(.init(
                gasVolumetricFlowRate: .nan,
                liquidVolumetricFlowRate: 0.001,
                floodingGasVelocity: 0.1,
                designFractionOfFlooding: 0.6,
                packedHeight: 3,
                gasDensity: 1.2,
                gasViscosity: 1.8e-5,
                bedVoidFraction: 0.4,
                equivalentPackingDiameter: 0.005
            ))
        }
    }
}
