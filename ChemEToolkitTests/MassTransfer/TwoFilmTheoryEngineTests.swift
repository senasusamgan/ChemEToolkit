import Testing
@testable import ChemEToolkit

@Suite("Two-Film Theory Engine")
struct TwoFilmTheoryEngineTests {
    private let engine =
        TwoFilmTheoryEngine()

    @Test(
        "Solves interface compositions and steady flux"
    )
    func solvesTwoFilmState() throws {
        let result = try engine.calculate(
            .init(
                gasFilmCoefficient: 0.01,
                liquidFilmCoefficient: 0.02,
                equilibriumSlope: 1.5,
                gasBulkMoleFraction: 0.3,
                liquidBulkMoleFraction:
                    0.05,
                interfacialArea: 2
            )
        )

        #expect(
            abs(
                result
                    .interfaceLiquidMoleFraction
                - 0.11428571428571428
            ) < 1e-12
        )
        #expect(
            abs(
                result
                    .interfaceGasMoleFraction
                - 0.17142857142857143
            ) < 1e-12
        )
        #expect(
            abs(
                result.molarFlux
                - 0.0012857142857142856
            ) < 1e-14
        )
        #expect(
            abs(
                result.molarRate
                - 0.0025714285714285713
            ) < 1e-14
        )
    }

    @Test(
        "Returns zero transfer at bulk equilibrium"
    )
    func bulkEquilibrium() throws {
        let result = try engine.calculate(
            .init(
                gasFilmCoefficient: 0.01,
                liquidFilmCoefficient: 0.02,
                equilibriumSlope: 1.5,
                gasBulkMoleFraction: 0.3,
                liquidBulkMoleFraction: 0.2,
                interfacialArea: 1
            )
        )

        #expect(
            abs(result.molarFlux) < 1e-12
        )
        #expect(
            abs(result.molarRate) < 1e-12
        )
        #expect(
            abs(
                result
                    .interfaceLiquidMoleFraction
                - 0.2
            ) < 1e-12
        )
    }

    @Test(
        "Rejects invalid properties, fractions and interface states"
    )
    func validation() {
        #expect(
            throws:
                TwoFilmTheoryError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient: 0,
                    liquidFilmCoefficient:
                        0.02,
                    equilibriumSlope: 1.5,
                    gasBulkMoleFraction:
                        0.3,
                    liquidBulkMoleFraction:
                        0.05,
                    interfacialArea: 1
                )
            )
        }

        #expect(
            throws:
                TwoFilmTheoryError
                    .moleFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient:
                        0.01,
                    liquidFilmCoefficient:
                        0.02,
                    equilibriumSlope: 1.5,
                    gasBulkMoleFraction:
                        1.1,
                    liquidBulkMoleFraction:
                        0.05,
                    interfacialArea: 1
                )
            )
        }

        #expect(
            throws:
                TwoFilmTheoryError
                    .interfaceCompositionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient:
                        0.01,
                    liquidFilmCoefficient:
                        0.02,
                    equilibriumSlope: 10,
                    gasBulkMoleFraction:
                        0.9,
                    liquidBulkMoleFraction:
                        0.9,
                    interfacialArea: 1
                )
            )
        }

        #expect(
            throws:
                TwoFilmTheoryError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient:
                        .infinity,
                    liquidFilmCoefficient:
                        0.02,
                    equilibriumSlope: 1.5,
                    gasBulkMoleFraction:
                        0.3,
                    liquidBulkMoleFraction:
                        0.05,
                    interfacialArea: 1
                )
            )
        }
    }
}
