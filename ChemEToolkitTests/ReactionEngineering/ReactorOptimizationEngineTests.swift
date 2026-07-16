import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Reactor Optimization Engine")
struct ReactorOptimizationEngineTests {
    private let engine =
        ReactorOptimizationEngine()

    @Test("Optimizes consecutive-reaction reactors")
    func optimization() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 1,
                volumetricFlowRate: 0.01,
                firstRateConstant: 0.5,
                secondRateConstant: 0.2
            )
        )

        #expect(
            abs(
                result.optimumPFRSpaceTime
                - 3.0543024395805167
            ) < 1e-12
        )
        #expect(
            abs(
                result.maximumPFRConcentrationB
                - 0.54288352331898126
            ) < 1e-12
        )
        #expect(
            abs(
                result.optimumCSTRSpaceTime
                - 3.1622776601683791
            ) < 1e-12
        )
        #expect(
            abs(
                result.maximumCSTRConcentrationB
                - 0.37524704425735622
            ) < 1e-12
        )
        #expect(result.recommendedReactor == "PFR")
    }

    @Test("Handles equal rate constants")
    func equalRates() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 1,
                volumetricFlowRate: 0.01,
                firstRateConstant: 0.5,
                secondRateConstant: 0.5
            )
        )

        #expect(
            abs(
                result.optimumPFRSpaceTime
                - 2
            ) < 1e-12
        )
        #expect(
            abs(
                result.maximumPFRYieldB
                - 1 / Foundation.exp(1)
            ) < 1e-12
        )
    }

    @Test("Rejects invalid rate constants")
    func validation() {
        #expect(
            throws:
                ReactorOptimizationError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 1,
                    volumetricFlowRate: 0.01,
                    firstRateConstant: 0,
                    secondRateConstant: 0.2
                )
            )
        }
    }
}
