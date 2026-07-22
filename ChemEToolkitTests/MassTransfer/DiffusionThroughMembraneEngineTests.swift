import Testing
@testable import ChemEToolkit

@Suite("Diffusion Through a Membrane Engine")
struct DiffusionThroughMembraneEngineTests {
    private let engine =
        DiffusionThroughMembraneEngine()

    @Test(
        "Calculates permeability, signed flux and transfer rate"
    )
    func calculatesMembraneTransport()
        throws {

        let result = try engine.calculate(
            .init(
                diffusivityInMembrane:
                    2e-10,
                partitionCoefficient: 1.5,
                membraneThickness: 0.001,
                membraneArea: 10,
                sideOneConcentration: 100,
                sideTwoConcentration: 20
            )
        )

        #expect(
            abs(
                result.membranePermeability
                - 3e-10
            ) < 1e-22
        )
        #expect(
            abs(
                result.membranePermeance
                - 3e-7
            ) < 1e-19
        )
        #expect(
            abs(
                result.membraneResistance
                - 3_333_333.3333333335
            ) < 1e-6
        )
        #expect(
            abs(
                result.signedMolarFlux
                - 2.4e-5
            ) < 1e-17
        )
        #expect(
            abs(
                result.transferRateMagnitude
                - 2.4e-4
            ) < 1e-16
        )
    }

    @Test(
        "Returns zero net transfer for equal concentrations"
    )
    func zeroGradientBoundary() throws {
        let result = try engine.calculate(
            .init(
                diffusivityInMembrane:
                    2e-10,
                partitionCoefficient: 1.5,
                membraneThickness: 0.001,
                membraneArea: 10,
                sideOneConcentration: 50,
                sideTwoConcentration: 50
            )
        )

        #expect(
            result.signedMolarFlux == 0
        )
        #expect(
            result.transferRateMagnitude
            == 0
        )
    }

    @Test(
        "Rejects invalid properties, concentrations and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                DiffusionThroughMembraneError
                    .nonPositiveTransportProperty
        ) {
            try engine.calculate(
                .init(
                    diffusivityInMembrane:
                        0,
                    partitionCoefficient:
                        1.5,
                    membraneThickness:
                        0.001,
                    membraneArea: 10,
                    sideOneConcentration:
                        100,
                    sideTwoConcentration:
                        20
                )
            )
        }

        #expect(
            throws:
                DiffusionThroughMembraneError
                    .negativeConcentration
        ) {
            try engine.calculate(
                .init(
                    diffusivityInMembrane:
                        2e-10,
                    partitionCoefficient:
                        1.5,
                    membraneThickness:
                        0.001,
                    membraneArea: 10,
                    sideOneConcentration:
                        -1,
                    sideTwoConcentration:
                        20
                )
            )
        }

        #expect(
            throws:
                DiffusionThroughMembraneError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    diffusivityInMembrane:
                        .nan,
                    partitionCoefficient:
                        1.5,
                    membraneThickness:
                        0.001,
                    membraneArea: 10,
                    sideOneConcentration:
                        100,
                    sideTwoConcentration:
                        20
                )
            )
        }
    }
}
