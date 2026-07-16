import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Second-Order Process Response Engine")
struct SecondOrderProcessResponseEngineTests {
    private let engine =
        SecondOrderProcessResponseEngine()

    @Test("Calculates underdamped response")
    func underdamped() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 0,
                processGain: 1,
                inputStepChange: 1,
                naturalFrequency: 1,
                dampingRatio: 0.5,
                evaluationTime: 2
            )
        )

        #expect(
            result.dampingRegime
            == "Underdamped"
        )

        #expect(
            abs(
                result.normalizedStepResponse
                - 0.84942563485411227
            ) < 1e-12
        )

        #expect(
            abs(
                result.percentOvershoot
                - 16.303353482158048
            ) < 1e-12
        )

        #expect(
            abs(
                result.peakTime!
                - Double.pi
                / 0.8660254037844386
            ) < 1e-12
        )
    }

    @Test("Handles critical and overdamped regimes")
    func otherRegimes() throws {
        let critical = try engine.calculate(
            .init(
                initialOutput: 0,
                processGain: 1,
                inputStepChange: 1,
                naturalFrequency: 1,
                dampingRatio: 1,
                evaluationTime: 2
            )
        )

        #expect(
            critical.dampingRegime
            == "Critically damped"
        )

        #expect(
            abs(
                critical.normalizedStepResponse
                - (
                    1
                    - 3
                    * Foundation.exp(-2)
                )
            ) < 1e-12
        )

        let overdamped = try engine.calculate(
            .init(
                initialOutput: 0,
                processGain: 1,
                inputStepChange: 1,
                naturalFrequency: 1,
                dampingRatio: 2,
                evaluationTime: 2
            )
        )

        #expect(
            overdamped.dampingRegime
            == "Overdamped"
        )

        #expect(
            overdamped.percentOvershoot
            == 0
        )
    }

    @Test("Rejects invalid damping")
    func validation() {
        #expect(
            throws:
                SecondOrderProcessResponseError
                    .nonPositiveDampingRatio
        ) {
            try engine.calculate(
                .init(
                    initialOutput: 0,
                    processGain: 1,
                    inputStepChange: 1,
                    naturalFrequency: 1,
                    dampingRatio: 0,
                    evaluationTime: 2
                )
            )
        }
    }
}
