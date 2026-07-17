import Testing
@testable import ChemEToolkit

@Suite("Gaussian Plume Dispersion Engine")
struct GaussianPlumeDispersionEngineTests {
    private let engine =
        GaussianPlumeDispersionEngine()

    @Test("Calculates reflected Gaussian-plume concentration")
    func plumeConcentration() throws {
        let result = try engine.calculate(
            .init(
                sourceEmissionRate: 1,
                windSpeed: 5,
                crosswindDistance: 0,
                receptorHeight: 1.5,
                effectiveReleaseHeight: 10,
                horizontalDispersionCoefficient: 30,
                verticalDispersionCoefficient: 15
            )
        )

        #expect(
            abs(
                result.crosswindAttenuation
                - 1
            ) < 1e-12
        )

        #expect(
            abs(
                result.directVerticalTerm
                - 0.85167050722944093
            ) < 1e-12
        )

        #expect(
            abs(
                result.reflectedVerticalTerm
                - 0.74535930454298049
            ) < 1e-12
        )

        #expect(
            abs(
                result.receptorConcentration
                - 0.00011296675058164446
            ) < 1e-14
        )

        #expect(
            abs(
                result.groundCenterlineConcentration
                - 0.00011328116959357925
            ) < 1e-14
        )
    }

    @Test("Crosswind offset lowers concentration")
    func crosswindEffect() throws {
        let centerline = try engine.calculate(
            .init(
                sourceEmissionRate: 1,
                windSpeed: 5,
                crosswindDistance: 0,
                receptorHeight: 0,
                effectiveReleaseHeight: 10,
                horizontalDispersionCoefficient: 30,
                verticalDispersionCoefficient: 15
            )
        )

        let offset = try engine.calculate(
            .init(
                sourceEmissionRate: 1,
                windSpeed: 5,
                crosswindDistance: 60,
                receptorHeight: 0,
                effectiveReleaseHeight: 10,
                horizontalDispersionCoefficient: 30,
                verticalDispersionCoefficient: 15
            )
        )

        #expect(
            offset.receptorConcentration
            < centerline.receptorConcentration
        )
    }

    @Test("Rejects zero wind speed")
    func validation() {
        #expect(
            throws:
                GaussianPlumeDispersionError
                    .nonPositiveWindSpeed
        ) {
            try engine.calculate(
                .init(
                    sourceEmissionRate: 1,
                    windSpeed: 0,
                    crosswindDistance: 0,
                    receptorHeight: 1.5,
                    effectiveReleaseHeight: 10,
                    horizontalDispersionCoefficient: 30,
                    verticalDispersionCoefficient: 15
                )
            )
        }
    }
}
