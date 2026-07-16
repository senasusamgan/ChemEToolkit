import Testing
@testable import ChemEToolkit

@Suite("Bypass Fraction Estimator Engine")
struct BypassFractionEstimatorEngineTests {
    private let engine =
        BypassFractionEstimatorEngine()

    @Test("Estimates bypass fraction and flows")
    func estimatesBypass() throws {
        let result = try engine.calculate(
            .init(
                inletTracerConcentration: 1,
                immediateOutletTracerConcentration:
                    0.15,
                totalVolumetricFlowRate: 10
            )
        )

        #expect(
            abs(
                result.bypassFraction
                - 0.15
            ) < 1e-12
        )
        #expect(
            abs(
                result.bypassFlowRate
                - 1.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.reactorPathFlowRate
                - 8.5
            ) < 1e-12
        )
    }

    @Test("Zero immediate response means zero bypass")
    func zeroBypass() throws {
        let result = try engine.calculate(
            .init(
                inletTracerConcentration: 1,
                immediateOutletTracerConcentration:
                    0,
                totalVolumetricFlowRate: 10
            )
        )

        #expect(result.bypassFraction == 0)
        #expect(result.bypassFlowRate == 0)
        #expect(result.reactorPathFlowRate == 10)
    }

    @Test("Rejects impossible tracer ratio")
    func validation() {
        #expect(
            throws:
                BypassFractionEstimatorError
                    .outletExceedsInlet
        ) {
            try engine.calculate(
                .init(
                    inletTracerConcentration: 1,
                    immediateOutletTracerConcentration:
                        1.1,
                    totalVolumetricFlowRate: 10
                )
            )
        }

        #expect(
            throws:
                BypassFractionEstimatorError
                    .nonPositiveInletConcentration
        ) {
            try engine.calculate(
                .init(
                    inletTracerConcentration: 0,
                    immediateOutletTracerConcentration:
                        0,
                    totalVolumetricFlowRate: 10
                )
            )
        }
    }
}
