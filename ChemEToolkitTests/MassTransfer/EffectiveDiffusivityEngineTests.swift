import Testing
@testable import ChemEToolkit

@Suite("Effective Diffusivity Engine")
struct EffectiveDiffusivityEngineTests {
    private let engine =
        EffectiveDiffusivityEngine()

    @Test("Calculates porous and Bosanquet diffusivities")
    func calculatesDiffusivities() throws {
        let result = try engine.calculate(
            .init(
                molecularDiffusivity: 1e-9,
                knudsenDiffusivity: 5e-9,
                porosity: 0.4,
                tortuosity: 2.5,
                constrictivity: 0.8
            )
        )

        #expect(
            abs(
                result.porousMediumCorrectionFactor
                - 0.128
            ) < 1e-15
        )
        #expect(
            abs(
                result.effectiveMolecularDiffusivity
                - 1.28e-10
            ) < 1e-22
        )
        #expect(
            abs(
                result.bosanquetPoreDiffusivity
                - 8.333333333333334e-10
            ) < 1e-22
        )
        #expect(
            abs(
                result.effectiveCombinedDiffusivity
                - 1.0666666666666668e-10
            ) < 1e-22
        )
        #expect(
            abs(
                result.molecularResistanceFraction
                - 0.8333333333333334
            ) < 1e-15
        )
    }

    @Test("Handles equal molecular and Knudsen resistance")
    func equalResistanceBoundary() throws {
        let result = try engine.calculate(
            .init(
                molecularDiffusivity: 1e-9,
                knudsenDiffusivity: 1e-9,
                porosity: 0.5,
                tortuosity: 2,
                constrictivity: 1
            )
        )

        #expect(
            abs(
                result.bosanquetPoreDiffusivity
                - 5e-10
            ) < 1e-22
        )
        #expect(
            result.molecularResistanceFraction
            == 0.5
        )
        #expect(
            result.knudsenResistanceFraction
            == 0.5
        )
    }

    @Test("Rejects invalid porosity, tortuosity and diffusivity")
    func validation() {
        #expect(
            throws:
                EffectiveDiffusivityError
                    .porosityOutOfRange
        ) {
            try engine.calculate(
                .init(
                    molecularDiffusivity: 1e-9,
                    knudsenDiffusivity: 5e-9,
                    porosity: 1,
                    tortuosity: 2.5,
                    constrictivity: 0.8
                )
            )
        }

        #expect(
            throws:
                EffectiveDiffusivityError
                    .tortuosityBelowUnity
        ) {
            try engine.calculate(
                .init(
                    molecularDiffusivity: 1e-9,
                    knudsenDiffusivity: 5e-9,
                    porosity: 0.4,
                    tortuosity: 0.9,
                    constrictivity: 0.8
                )
            )
        }

        #expect(
            throws:
                EffectiveDiffusivityError
                    .nonPositiveDiffusivity
        ) {
            try engine.calculate(
                .init(
                    molecularDiffusivity: 0,
                    knudsenDiffusivity: 5e-9,
                    porosity: 0.4,
                    tortuosity: 2.5,
                    constrictivity: 0.8
                )
            )
        }

        #expect(
            throws:
                EffectiveDiffusivityError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    molecularDiffusivity: .nan,
                    knudsenDiffusivity: 5e-9,
                    porosity: 0.4,
                    tortuosity: 2.5,
                    constrictivity: 0.8
                )
            )
        }
    }
}
