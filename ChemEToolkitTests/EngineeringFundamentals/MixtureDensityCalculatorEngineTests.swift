import Testing
@testable import ChemEToolkit

@Suite("Mixture Density Calculator Engine")
struct MixtureDensityCalculatorEngineTests {
    private let engine =
        MixtureDensityCalculatorEngine()

    @Test("Calculates additive-volume mixture density")
    func mixtureDensity() throws {
        let result = try engine.calculate(
            .init(
                mass1: 50,
                density1: 1000,
                mass2: 30,
                density2: 800,
                mass3: 20,
                density3: 1200
            )
        )

        let expectedVolume =
            50.0 / 1000
            + 30.0 / 800
            + 20.0 / 1200

        #expect(result.totalMass == 100)

        #expect(
            abs(
                result.totalAdditiveVolume
                - expectedVolume
            ) < 1e-12
        )

        #expect(
            abs(
                result.mixtureDensity
                - 100 / expectedVolume
            ) < 1e-10
        )
    }

    @Test("Single component returns component density")
    func singleComponent() throws {
        let result = try engine.calculate(
            .init(
                mass1: 10,
                density1: 900,
                mass2: 0,
                density2: 1000,
                mass3: 0,
                density3: 1200
            )
        )

        #expect(
            abs(
                result.mixtureDensity
                - 900
            ) < 1e-12
        )
    }

    @Test("Rejects zero total mass")
    func validation() {
        #expect(
            throws:
                MixtureDensityCalculatorError
                    .zeroTotalMass
        ) {
            try engine.calculate(
                .init(
                    mass1: 0,
                    density1: 900,
                    mass2: 0,
                    density2: 1000,
                    mass3: 0,
                    density3: 1200
                )
            )
        }
    }
}
