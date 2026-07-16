import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Catalyst Time-on-Stream Engine")
struct CatalystTimeOnStreamEngineTests {
    private let engine =
        CatalystTimeOnStreamEngine()

    @Test("Calculates PFR and CSTR operating limits")
    func timeLimits() throws {
        let result = try engine.calculate(
            .init(
                freshDamkohlerNumber: 4,
                deactivationRateConstant: 0.1,
                minimumAcceptableConversion: 0.7
            )
        )

        #expect(
            abs(
                result.requiredPFRActivity
                - 0.30099320108148397
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredCSTRActivity
                - 0.58333333333333326
            ) < 1e-12
        )
        #expect(
            abs(
                result.pfrTimeOnStreamLimit
                - 12.006676022575251
            ) < 1e-12
        )
        #expect(
            abs(
                result.cstrTimeOnStreamLimit
                - 5.3899650073268708
            ) < 1e-12
        )
        #expect(
            result.cstrTimeOnStreamLimit
            < result.pfrTimeOnStreamLimit
        )
    }

    @Test("Half-life follows first-order deactivation")
    func halfLife() throws {
        let result = try engine.calculate(
            .init(
                freshDamkohlerNumber: 4,
                deactivationRateConstant: 0.1,
                minimumAcceptableConversion: 0.7
            )
        )

        #expect(
            abs(
                result.catalystActivityHalfLife
                - Foundation.log(2) / 0.1
            ) < 1e-12
        )
    }

    @Test("Rejects target above fresh performance")
    func validation() {
        #expect(
            throws:
                CatalystTimeOnStreamError
                    .freshReactorBelowTarget
        ) {
            try engine.calculate(
                .init(
                    freshDamkohlerNumber: 1,
                    deactivationRateConstant: 0.1,
                    minimumAcceptableConversion: 0.6
                )
            )
        }

        #expect(
            throws:
                CatalystTimeOnStreamError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    freshDamkohlerNumber: 4,
                    deactivationRateConstant: 0.1,
                    minimumAcceptableConversion: 1
                )
            )
        }
    }
}
