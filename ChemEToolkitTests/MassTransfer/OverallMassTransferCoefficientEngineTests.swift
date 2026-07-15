import Testing
@testable import ChemEToolkit

@Suite(
    "Overall Mass-Transfer Coefficient Engine"
)
struct OverallMassTransferCoefficientEngineTests {
    private let engine =
        OverallMassTransferCoefficientEngine()

    @Test(
        "Calculates overall coefficients, flux and resistance shares"
    )
    func calculatesOverallTransfer() throws {
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
                result.overallGasCoefficient
                - 0.005714285714285714
            ) < 1e-14
        )
        #expect(
            abs(
                result.overallLiquidCoefficient
                - 0.008571428571428572
            ) < 1e-14
        )
        #expect(
            abs(
                result.gasBasisMolarFlux
                - 0.0012857142857142856
            ) < 1e-14
        )
        #expect(
            abs(
                result.liquidBasisMolarFlux
                - 0.0012857142857142856
            ) < 1e-14
        )
        #expect(
            abs(
                result.molarRate
                - 0.0025714285714285713
            ) < 1e-14
        )
        #expect(
            abs(
                result.gasResistanceFraction
                - 0.5714285714285714
            ) < 1e-14
        )
    }

    @Test(
        "Returns zero flux at bulk equilibrium"
    )
    func bulkEquilibrium() throws {
        let result = try engine.calculate(
            .init(
                gasFilmCoefficient: 0.01,
                liquidFilmCoefficient: 0.02,
                equilibriumSlope: 1.5,
                gasBulkMoleFraction: 0.3,
                liquidBulkMoleFraction: 0.2,
                interfacialArea: 5
            )
        )

        #expect(
            abs(
                result
                    .overallGasDrivingForce
            ) < 1e-12
        )
        #expect(
            abs(
                result
                    .overallLiquidDrivingForce
            ) < 1e-12
        )
        #expect(
            abs(result.molarRate) < 1e-12
        )
    }

    @Test(
        "Rejects invalid properties, fractions and equilibrium states"
    )
    func validation() {
        #expect(
            throws:
                OverallMassTransferCoefficientError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient:
                        0.01,
                    liquidFilmCoefficient: 0,
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
                OverallMassTransferCoefficientError
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
                        -0.1,
                    liquidBulkMoleFraction:
                        0.05,
                    interfacialArea: 1
                )
            )
        }

        #expect(
            throws:
                OverallMassTransferCoefficientError
                    .equilibriumCompositionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient:
                        0.01,
                    liquidFilmCoefficient:
                        0.02,
                    equilibriumSlope: 2,
                    gasBulkMoleFraction:
                        0.4,
                    liquidBulkMoleFraction:
                        0.6,
                    interfacialArea: 1
                )
            )
        }

        #expect(
            throws:
                OverallMassTransferCoefficientError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    gasFilmCoefficient:
                        .nan,
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
