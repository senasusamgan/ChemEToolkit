import Testing
@testable import ChemEToolkit

@Suite("Raoult Dew-Point Pressure Engine")
struct RaoultDewPointPressureEngineTests {
    private let engine =
        RaoultDewPointPressureEngine()

    @Test("Calculates dew pressure and liquid composition")
    func dewPoint() throws {
        let result = try engine.calculate(
            .init(
                vaporMoleFraction1: 0.6,
                saturationPressure1: 100,
                saturationPressure2: 40
            )
        )

        let expectedPressure =
            1.0 / (0.6 / 100 + 0.4 / 40)

        #expect(
            abs(
                result.dewPointPressure
                - expectedPressure
            ) < 1e-12
        )

        #expect(
            abs(
                result.liquidMoleFraction1
                + result.liquidMoleFraction2
                - 1
            ) < 1e-12
        )
    }

    @Test("Pure vapor gives saturation pressure")
    func pureComponent() throws {
        let result = try engine.calculate(
            .init(
                vaporMoleFraction1: 1,
                saturationPressure1: 100,
                saturationPressure2: 40
            )
        )

        #expect(result.dewPointPressure == 100)
        #expect(result.liquidMoleFraction1 == 1)
    }

    @Test("Rejects composition above one")
    func validation() {
        #expect(
            throws:
                RaoultDewPointPressureError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    vaporMoleFraction1: 1.1,
                    saturationPressure1: 100,
                    saturationPressure2: 40
                )
            )
        }
    }
}
