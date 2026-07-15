import Testing
@testable import ChemEToolkit

@Suite("Adsorption Isotherms Engine")
struct AdsorptionIsothermsEngineTests {
    private let engine =
        AdsorptionIsothermsEngine()

    @Test(
        "Calculates Langmuir loading, saturation and local slope"
    )
    func langmuir() throws {
        let result = try engine.calculate(
            .init(
                model: .langmuir,
                equilibriumFluidConcentration:
                    2,
                maximumAdsorptionCapacity:
                    5,
                langmuirConstant: 0.8,
                freundlichConstant: 1,
                freundlichExponent: 2,
                linearDistributionConstant:
                    1
            )
        )

        #expect(
            abs(
                result.equilibriumLoading
                - 3.0769230769230766
            ) < 1e-12
        )
        #expect(
            abs(
                result.fractionalSaturation!
                - 0.6153846153846154
            ) < 1e-12
        )
        #expect(
            abs(
                result.localIsothermSlope
                - 0.5917159763313609
            ) < 1e-12
        )
    }

    @Test(
        "Calculates Freundlich and linear model values"
    )
    func alternateModels() throws {
        let freundlich = try engine.calculate(
            .init(
                model: .freundlich,
                equilibriumFluidConcentration:
                    4,
                maximumAdsorptionCapacity:
                    1,
                langmuirConstant: 1,
                freundlichConstant: 1.5,
                freundlichExponent: 2,
                linearDistributionConstant:
                    1
            )
        )

        #expect(
            abs(
                freundlich.equilibriumLoading
                - 3
            ) < 1e-12
        )

        let linear = try engine.calculate(
            .init(
                model: .linear,
                equilibriumFluidConcentration:
                    1.2,
                maximumAdsorptionCapacity:
                    1,
                langmuirConstant: 1,
                freundlichConstant: 1,
                freundlichExponent: 2,
                linearDistributionConstant:
                    2
            )
        )

        #expect(
            abs(
                linear.equilibriumLoading
                - 2.4
            ) < 1e-12
        )
        #expect(
            linear.localIsothermSlope == 2
        )
    }

    @Test(
        "Rejects invalid selected parameters and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                AdsorptionIsothermsError
                    .nonPositiveParameter
        ) {
            try engine.calculate(
                .init(
                    model: .langmuir,
                    equilibriumFluidConcentration:
                        2,
                    maximumAdsorptionCapacity:
                        0,
                    langmuirConstant: 0.8,
                    freundlichConstant: 1,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        1
                )
            )
        }

        #expect(
            throws:
                AdsorptionIsothermsError
                    .invalidFreundlichExponent
        ) {
            try engine.calculate(
                .init(
                    model: .freundlich,
                    equilibriumFluidConcentration:
                        2,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 1,
                    freundlichExponent: 1,
                    linearDistributionConstant:
                        1
                )
            )
        }

        #expect(
            throws:
                AdsorptionIsothermsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    model: .linear,
                    equilibriumFluidConcentration:
                        .nan,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 1,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        1
                )
            )
        }
    }
}
