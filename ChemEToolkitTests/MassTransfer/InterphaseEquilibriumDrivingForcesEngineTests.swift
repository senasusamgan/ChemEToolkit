import Testing
@testable import ChemEToolkit

@Suite(
    "Interphase Equilibrium and Driving Forces Engine"
)
struct InterphaseEquilibriumDrivingForcesEngineTests {
    private let engine =
        InterphaseEquilibriumDrivingForcesEngine()

    @Test(
        "Calculates interface and overall driving forces"
    )
    func calculatesDrivingForces() throws {
        let result = try engine.calculate(
            .init(
                equilibriumSlope: 1.5,
                gasBulkMoleFraction: 0.4,
                liquidBulkMoleFraction: 0.1,
                interfaceLiquidMoleFraction:
                    0.2
            )
        )

        #expect(
            abs(
                result.interfaceGasMoleFraction
                - 0.3
            ) < 1e-12
        )
        #expect(
            abs(
                result.gasFilmDrivingForce
                - 0.1
            ) < 1e-12
        )
        #expect(
            abs(
                result.liquidFilmDrivingForce
                - 0.1
            ) < 1e-12
        )
        #expect(
            abs(
                result.overallGasDrivingForce
                - 0.25
            ) < 1e-12
        )
        #expect(
            abs(
                result.overallLiquidDrivingForce
                - 0.16666666666666669
            ) < 1e-12
        )
    }

    @Test(
        "Identifies bulk equilibrium as zero net driving force"
    )
    func bulkEquilibrium() throws {
        let result = try engine.calculate(
            .init(
                equilibriumSlope: 1.5,
                gasBulkMoleFraction: 0.3,
                liquidBulkMoleFraction: 0.2,
                interfaceLiquidMoleFraction:
                    0.2
            )
        )

        #expect(
            abs(
                result.overallGasDrivingForce
            ) < 1e-12
        )
        #expect(
            abs(
                result.overallLiquidDrivingForce
            ) < 1e-12
        )
        #expect(
            result.directionDescription
                .contains("equilibrium")
        )
    }

    @Test(
        "Rejects invalid slope, fractions and equilibrium predictions"
    )
    func validation() {
        #expect(
            throws:
                InterphaseEquilibriumDrivingForcesError
                    .nonPositiveEquilibriumSlope
        ) {
            try engine.calculate(
                .init(
                    equilibriumSlope: 0,
                    gasBulkMoleFraction: 0.2,
                    liquidBulkMoleFraction:
                        0.1,
                    interfaceLiquidMoleFraction:
                        0.1
                )
            )
        }

        #expect(
            throws:
                InterphaseEquilibriumDrivingForcesError
                    .moleFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    equilibriumSlope: 1,
                    gasBulkMoleFraction: 1.1,
                    liquidBulkMoleFraction:
                        0.1,
                    interfaceLiquidMoleFraction:
                        0.1
                )
            )
        }

        #expect(
            throws:
                InterphaseEquilibriumDrivingForcesError
                    .equilibriumCompositionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    equilibriumSlope: 2,
                    gasBulkMoleFraction: 0.4,
                    liquidBulkMoleFraction:
                        0.1,
                    interfaceLiquidMoleFraction:
                        0.6
                )
            )
        }

        #expect(
            throws:
                InterphaseEquilibriumDrivingForcesError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    equilibriumSlope: .nan,
                    gasBulkMoleFraction: 0.2,
                    liquidBulkMoleFraction:
                        0.1,
                    interfaceLiquidMoleFraction:
                        0.1
                )
            )
        }
    }
}
