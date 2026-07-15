import Testing
@testable import ChemEToolkit

@Suite(
    "Crystallization Yield and Mother Liquor Engine"
)
struct CrystallizationYieldMotherLiquorEngineTests {
    private let engine =
        CrystallizationYieldMotherLiquorEngine()

    @Test(
        "Calculates pure-crystal recovery and saturated mother liquor"
    )
    func pureCrystals() throws {
        let result = try engine.calculate(
            .init(
                feedSolutionMass: 1000,
                feedSoluteMassFraction: 0.3,
                evaporatedSolventMass: 100,
                finalSolubilityRatio: 0.25,
                crystalSoluteMassFraction:
                    1
            )
        )

        #expect(
            result.phaseState
            == .crystalsFormed
        )
        #expect(
            abs(
                result.supersaturationRatio
                - 2
            ) < 1e-12
        )
        #expect(
            abs(result.crystalMass - 150)
            < 1e-12
        )
        #expect(
            abs(
                result.motherLiquorTotalMass
                - 750
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRecoveryFraction
                - 0.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.totalMassBalanceResidual
            ) < 1e-12
        )
    }

    @Test(
        "Accounts for solvent contained in hydrate crystals"
    )
    func solventContainingCrystals()
        throws {

        let result = try engine.calculate(
            .init(
                feedSolutionMass: 1000,
                feedSoluteMassFraction: 0.3,
                evaporatedSolventMass: 100,
                finalSolubilityRatio: 0.25,
                crystalSoluteMassFraction:
                    0.8
            )
        )

        #expect(
            abs(result.crystalMass - 200)
            < 1e-12
        )
        #expect(
            abs(
                result.crystalSoluteMass
                - 160
            ) < 1e-12
        )
        #expect(
            abs(
                result.crystalSolventMass
                - 40
            ) < 1e-12
        )
        #expect(
            abs(
                result.motherLiquorSoluteMass
                - 140
            ) < 1e-12
        )
        #expect(
            abs(
                result.soluteRecoveryFraction
                - 0.5333333333333333
            ) < 1e-12
        )
    }

    @Test(
        "Handles unsaturated solution and rejects invalid inputs"
    )
    func boundaryAndValidation() throws {
        let unsaturated =
            try engine.calculate(
                .init(
                    feedSolutionMass: 1000,
                    feedSoluteMassFraction:
                        0.1,
                    evaporatedSolventMass:
                        0,
                    finalSolubilityRatio:
                        0.25,
                    crystalSoluteMassFraction:
                        1
                )
            )

        #expect(
            unsaturated.phaseState
            == .undersaturated
        )
        #expect(
            unsaturated.crystalMass == 0
        )

        #expect(
            throws:
                CrystallizationYieldMotherLiquorError
                    .evaporationRemovesAllSolvent
        ) {
            try engine.calculate(
                .init(
                    feedSolutionMass: 1000,
                    feedSoluteMassFraction:
                        0.3,
                    evaporatedSolventMass:
                        700,
                    finalSolubilityRatio:
                        0.25,
                    crystalSoluteMassFraction:
                        1
                )
            )
        }

        #expect(
            throws:
                CrystallizationYieldMotherLiquorError
                    .crystalCompositionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    feedSolutionMass: 1000,
                    feedSoluteMassFraction:
                        0.3,
                    evaporatedSolventMass:
                        100,
                    finalSolubilityRatio:
                        0.25,
                    crystalSoluteMassFraction:
                        0
                )
            )
        }

        #expect(
            throws:
                CrystallizationYieldMotherLiquorError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    feedSolutionMass: .nan,
                    feedSoluteMassFraction:
                        0.3,
                    evaporatedSolventMass:
                        100,
                    finalSolubilityRatio:
                        0.25,
                    crystalSoluteMassFraction:
                        1
                )
            )
        }
    }
}
