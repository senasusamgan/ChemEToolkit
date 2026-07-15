import Testing
@testable import ChemEToolkit

@Suite("Constant-Pressure Filtration Engine")
struct ConstantPressureFiltrationEngineTests {
    private let engine =
        ConstantPressureFiltrationEngine()

    @Test(
        "Calculates time, resistances and changing flow rate"
    )
    func calculatesFiltration() throws {
        let result = try engine.calculate(
            .init(
                filtrateViscosity: 0.001,
                pressureDrop: 200_000,
                filterArea: 0.5,
                specificCakeResistance:
                    5e10,
                slurrySolidsPerFiltrateVolume:
                    20,
                filterMediumResistance:
                    1e10,
                targetFiltrateVolume:
                    0.2
            )
        )

        #expect(
            abs(result.filtrationTime - 420)
            < 1e-10
        )
        #expect(
            abs(
                result.depositedCakeMass
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalCakeResistance
                - 4e11
            ) < 1e-2
        )
        #expect(
            abs(
                result.initialFiltrateFlowRate
                - 0.01
            ) < 1e-14
        )
        #expect(
            abs(
                result.finalFiltrateFlowRate
                - 0.00024390243902439024
            ) < 1e-16
        )
        #expect(
            abs(
                result.cakeResistanceFraction
                - 0.975609756097561
            ) < 1e-14
        )
    }

    @Test(
        "Doubling pressure halves filtration time"
    )
    func pressureScaling() throws {
        let base = try engine.calculate(
            .init(
                filtrateViscosity: 0.001,
                pressureDrop: 200_000,
                filterArea: 0.5,
                specificCakeResistance:
                    5e10,
                slurrySolidsPerFiltrateVolume:
                    20,
                filterMediumResistance:
                    1e10,
                targetFiltrateVolume:
                    0.2
            )
        )

        let doubledPressure =
            try engine.calculate(
                .init(
                    filtrateViscosity:
                        0.001,
                    pressureDrop: 400_000,
                    filterArea: 0.5,
                    specificCakeResistance:
                        5e10,
                    slurrySolidsPerFiltrateVolume:
                        20,
                    filterMediumResistance:
                        1e10,
                    targetFiltrateVolume:
                        0.2
                )
            )

        #expect(
            abs(
                doubledPressure
                    .filtrationTime
                - base.filtrationTime / 2
            ) < 1e-12
        )
    }

    @Test(
        "Rejects zero properties and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                ConstantPressureFiltrationError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    filtrateViscosity: 0,
                    pressureDrop: 200_000,
                    filterArea: 0.5,
                    specificCakeResistance:
                        5e10,
                    slurrySolidsPerFiltrateVolume:
                        20,
                    filterMediumResistance:
                        1e10,
                    targetFiltrateVolume:
                        0.2
                )
            )
        }

        #expect(
            throws:
                ConstantPressureFiltrationError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    filtrateViscosity:
                        0.001,
                    pressureDrop: 200_000,
                    filterArea: 0.5,
                    specificCakeResistance:
                        5e10,
                    slurrySolidsPerFiltrateVolume:
                        20,
                    filterMediumResistance:
                        1e10,
                    targetFiltrateVolume:
                        0
                )
            )
        }

        #expect(
            throws:
                ConstantPressureFiltrationError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    filtrateViscosity:
                        .nan,
                    pressureDrop: 200_000,
                    filterArea: 0.5,
                    specificCakeResistance:
                        5e10,
                    slurrySolidsPerFiltrateVolume:
                        20,
                    filterMediumResistance:
                        1e10,
                    targetFiltrateVolume:
                        0.2
                )
            )
        }
    }
}
