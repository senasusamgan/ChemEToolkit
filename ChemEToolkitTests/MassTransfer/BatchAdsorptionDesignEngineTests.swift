import Testing
@testable import ChemEToolkit

@Suite("Batch Adsorption Design Engine")
struct BatchAdsorptionDesignEngineTests {
    private let engine =
        BatchAdsorptionDesignEngine()

    @Test(
        "Calculates Langmuir equilibrium adsorbent requirement"
    )
    func langmuirDesign() throws {
        let result = try engine.calculate(
            .init(
                model: .langmuir,
                solutionVolume: 10,
                initialConcentration: 5,
                targetEquilibriumConcentration:
                    1,
                maximumAdsorptionCapacity:
                    2,
                langmuirConstant: 0.5,
                freundlichConstant: 1,
                freundlichExponent: 2,
                linearDistributionConstant:
                    1
            )
        )

        #expect(
            abs(
                result.targetEquilibriumLoading
                - 2.0 / 3.0
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRemovedMass
                - 40
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredAdsorbentMass
                - 60
            ) < 1e-12
        )
        #expect(
            abs(
                result.removalFraction
                - 0.8
            ) < 1e-12
        )
    }

    @Test(
        "Calculates Freundlich and linear design cases"
    )
    func alternateModels() throws {
        let freundlich =
            try engine.calculate(
                .init(
                    model: .freundlich,
                    solutionVolume: 10,
                    initialConcentration: 5,
                    targetEquilibriumConcentration:
                        1,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 2,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        1
                )
            )

        #expect(
            abs(
                freundlich
                    .targetEquilibriumLoading
                - 2
            ) < 1e-12
        )
        #expect(
            abs(
                freundlich.requiredAdsorbentMass
                - 20
            ) < 1e-12
        )

        let linear =
            try engine.calculate(
                .init(
                    model: .linear,
                    solutionVolume: 10,
                    initialConcentration: 5,
                    targetEquilibriumConcentration:
                        1,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 1,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        4
                )
            )

        #expect(
            abs(
                linear.targetEquilibriumLoading
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                linear.requiredAdsorbentMass
                - 10
            ) < 1e-12
        )
    }

    @Test(
        "Rejects invalid target, model parameters and zero-loading target"
    )
    func validation() {
        #expect(
            throws:
                BatchAdsorptionDesignError
                    .invalidConcentrationOrdering
        ) {
            try engine.calculate(
                .init(
                    model: .langmuir,
                    solutionVolume: 10,
                    initialConcentration: 5,
                    targetEquilibriumConcentration:
                        5,
                    maximumAdsorptionCapacity:
                        2,
                    langmuirConstant: 0.5,
                    freundlichConstant: 1,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        1
                )
            )
        }

        #expect(
            throws:
                BatchAdsorptionDesignError
                    .invalidFreundlichExponent
        ) {
            try engine.calculate(
                .init(
                    model: .freundlich,
                    solutionVolume: 10,
                    initialConcentration: 5,
                    targetEquilibriumConcentration:
                        1,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 2,
                    freundlichExponent: 1,
                    linearDistributionConstant:
                        1
                )
            )
        }

        #expect(
            throws:
                BatchAdsorptionDesignError
                    .zeroEquilibriumLoading
        ) {
            try engine.calculate(
                .init(
                    model: .linear,
                    solutionVolume: 10,
                    initialConcentration: 5,
                    targetEquilibriumConcentration:
                        0,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 1,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        4
                )
            )
        }

        #expect(
            throws:
                BatchAdsorptionDesignError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    model: .linear,
                    solutionVolume: .nan,
                    initialConcentration: 5,
                    targetEquilibriumConcentration:
                        1,
                    maximumAdsorptionCapacity:
                        1,
                    langmuirConstant: 1,
                    freundlichConstant: 1,
                    freundlichExponent: 2,
                    linearDistributionConstant:
                        4
                )
            )
        }
    }
}
