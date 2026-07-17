import Testing
@testable import ChemEToolkit

@Suite("Raoult Bubble-Point Pressure Engine")
struct RaoultBubblePointPressureEngineTests {
    private let engine =
        RaoultBubblePointPressureEngine()

    @Test("Calculates bubble pressure and vapor composition")
    func bubblePoint() throws {
        let result = try engine.calculate(
            .init(
                liquidMoleFraction1: 0.4,
                saturationPressure1: 100,
                saturationPressure2: 40
            )
        )

        #expect(
            abs(
                result.bubblePointPressure
                - 64
            ) < 1e-12
        )

        #expect(
            abs(
                result.vaporMoleFraction1
                - 0.625
            ) < 1e-12
        )

        #expect(
            abs(
                result.vaporMoleFraction1
                + result.vaporMoleFraction2
                - 1
            ) < 1e-12
        )
    }

    @Test("Pure component gives its saturation pressure")
    func pureComponent() throws {
        let result = try engine.calculate(
            .init(
                liquidMoleFraction1: 1,
                saturationPressure1: 100,
                saturationPressure2: 40
            )
        )

        #expect(result.bubblePointPressure == 100)
        #expect(result.vaporMoleFraction1 == 1)
    }

    @Test("Rejects zero saturation pressure")
    func validation() {
        #expect(
            throws:
                RaoultBubblePointPressureError
                    .nonPositiveSaturationPressure
        ) {
            try engine.calculate(
                .init(
                    liquidMoleFraction1: 0.4,
                    saturationPressure1: 0,
                    saturationPressure2: 40
                )
            )
        }
    }
}
