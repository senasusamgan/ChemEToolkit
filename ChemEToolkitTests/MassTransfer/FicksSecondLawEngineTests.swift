import Testing
@testable import ChemEToolkit

@Suite("Fick’s Second Law Engine")
struct FicksSecondLawEngineTests {
    private let engine =
        FicksSecondLawEngine()

    @Test("Calculates the semi-infinite concentration profile")
    func calculatesProfile() throws {
        let result = try engine.calculate(
            .init(
                initialConcentration: 1,
                surfaceConcentration: 0,
                diffusivity: 1e-9,
                depth: 0.001,
                diffusionTime: 3600
            )
        )

        #expect(
            abs(
                result.similarityVariable
                - 0.26352313834736496
            ) < 1e-14
        )
        #expect(
            abs(
                result.dimensionlessConcentrationRatio
                - 0.29061188498577367
            ) < 1e-14
        )
        #expect(
            abs(
                result.fractionalApproachToSurface
                - 0.7093881150142263
            ) < 1e-14
        )
        #expect(
            abs(
                result.concentrationAtDepthAndTime
                - 0.29061188498577367
            ) < 1e-14
        )
    }

    @Test("Uses the imposed surface concentration at zero depth")
    func surfaceBoundary() throws {
        let result = try engine.calculate(
            .init(
                initialConcentration: 1,
                surfaceConcentration: 0.2,
                diffusivity: 1e-9,
                depth: 0,
                diffusionTime: 3600
            )
        )

        #expect(
            result.similarityVariable == 0
        )
        #expect(
            result.dimensionlessConcentrationRatio
            == 0
        )
        #expect(
            result.fractionalApproachToSurface
            == 1
        )
        #expect(
            result.concentrationAtDepthAndTime
            == 0.2
        )
    }

    @Test("Rejects invalid diffusivity, time and equal states")
    func validation() {
        #expect(
            throws:
                FicksSecondLawError
                    .nonPositiveDiffusivity
        ) {
            try engine.calculate(
                .init(
                    initialConcentration: 1,
                    surfaceConcentration: 0,
                    diffusivity: 0,
                    depth: 0.001,
                    diffusionTime: 3600
                )
            )
        }

        #expect(
            throws:
                FicksSecondLawError
                    .nonPositiveTime
        ) {
            try engine.calculate(
                .init(
                    initialConcentration: 1,
                    surfaceConcentration: 0,
                    diffusivity: 1e-9,
                    depth: 0.001,
                    diffusionTime: 0
                )
            )
        }

        #expect(
            throws:
                FicksSecondLawError
                    .equalInitialAndSurfaceConcentrations
        ) {
            try engine.calculate(
                .init(
                    initialConcentration: 1,
                    surfaceConcentration: 1,
                    diffusivity: 1e-9,
                    depth: 0.001,
                    diffusionTime: 3600
                )
            )
        }

        #expect(
            throws:
                FicksSecondLawError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentration: .nan,
                    surfaceConcentration: 0,
                    diffusivity: 1e-9,
                    depth: 0.001,
                    diffusionTime: 3600
                )
            )
        }
    }
}
