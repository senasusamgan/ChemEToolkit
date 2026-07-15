import Testing
@testable import ChemEToolkit

@Suite("PBR Pressure-Drop Effects Engine")
struct PBRPressureDropEffectsEngineTests {
    private let engine =
        PBRPressureDropEffectsEngine()

    @Test("Calculates pressure and conversion effects")
    func calculatesEffects() throws {
        let result = try engine.calculate(
            .init(
                catalystWeight: 10,
                inletMolarFlowRateA: 1,
                inletConcentrationA: 100,
                massSpecificFirstOrderRateConstant:
                    0.001,
                pressureDropParameter: 0.05,
                inletPressure: 500_000
            )
        )

        #expect(
            abs(
                result.outletPressureRatio
                - 0.7071067811865476
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletPressure
                - 353_553.3905932738
            ) < 1e-7
        )
        #expect(
            abs(
                result.effectiveCatalystExposure
                - 8.619288125423017
            ) < 1e-12
        )
        #expect(
            abs(
                result.conversionWithPressureDrop
                - 0.5776533313711771
            ) < 1e-12
        )
        #expect(
            abs(
                result.conversionWithoutPressureDrop
                - 0.6321205588285577
            ) < 1e-12
        )
        #expect(
            abs(
                result.conversionPenalty
                - 0.05446722745738053
            ) < 1e-12
        )
    }

    @Test("Zero pressure parameter matches no-drop conversion")
    func zeroPressureDrop() throws {
        let result = try engine.calculate(
            .init(
                catalystWeight: 10,
                inletMolarFlowRateA: 1,
                inletConcentrationA: 100,
                massSpecificFirstOrderRateConstant:
                    0.001,
                pressureDropParameter: 0,
                inletPressure: 500_000
            )
        )

        #expect(result.outletPressureRatio == 1)
        #expect(result.pressureDrop == 0)
        #expect(
            abs(
                result.conversionWithPressureDrop
                - result.conversionWithoutPressureDrop
            ) < 1e-12
        )
        #expect(result.conversionPenalty == 0)
    }

    @Test("Rejects collapse, negative parameter and invalid input")
    func validation() {
        #expect(
            throws:
                PBRPressureDropEffectsError
                    .pressureCollapse
        ) {
            try engine.calculate(
                .init(
                    catalystWeight: 20,
                    inletMolarFlowRateA: 1,
                    inletConcentrationA: 100,
                    massSpecificFirstOrderRateConstant:
                        0.001,
                    pressureDropParameter: 0.05,
                    inletPressure: 500_000
                )
            )
        }

        #expect(
            throws:
                PBRPressureDropEffectsError
                    .negativePressureDropParameter
        ) {
            try engine.calculate(
                .init(
                    catalystWeight: 10,
                    inletMolarFlowRateA: 1,
                    inletConcentrationA: 100,
                    massSpecificFirstOrderRateConstant:
                        0.001,
                    pressureDropParameter: -0.05,
                    inletPressure: 500_000
                )
            )
        }

        #expect(
            throws:
                PBRPressureDropEffectsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    catalystWeight: .nan,
                    inletMolarFlowRateA: 1,
                    inletConcentrationA: 100,
                    massSpecificFirstOrderRateConstant:
                        0.001,
                    pressureDropParameter: 0.05,
                    inletPressure: 500_000
                )
            )
        }
    }
}
