import Testing
@testable import ChemEToolkit

@Suite("Reactor Comparison Engine")
struct ReactorComparisonEngineTests {
    private let engine =
        ReactorComparisonEngine()

    private let tolerance =
        0.00000001

    @Test("Compares PFR and CSTR volumes")
    func comparesVolumes() throws {
        let input = ReactorComparisonInput(
            rateConstant: 0.1,
            conversion: 0.5,
            flowRate: 5
        )

        let result =
            try engine.compare(input: input)

        #expect(
            abs(
                result.pfrSpaceTime -
                6.931471805599453
            ) < tolerance
        )

        #expect(
            abs(
                result.cstrSpaceTime -
                10
            ) < tolerance
        )

        #expect(
            abs(
                result.pfrVolume -
                34.657359027997266
            ) < tolerance
        )

        #expect(
            abs(
                result.cstrVolume -
                50
            ) < tolerance
        )
    }

    @Test("Calculates difference and ratio")
    func calculatesDifferenceAndRatio() throws {
        let input = ReactorComparisonInput(
            rateConstant: 0.1,
            conversion: 0.5,
            flowRate: 5
        )

        let result =
            try engine.compare(input: input)

        #expect(
            abs(
                result.volumeDifference -
                15.342640972002734
            ) < tolerance
        )

        #expect(
            abs(
                result.volumeRatio -
                1.4426950408889634
            ) < tolerance
        )
    }

    @Test("CSTR requires more volume")
    func cstrRequiresMoreVolume() throws {
        let input = ReactorComparisonInput(
            rateConstant: 0.2,
            conversion: 0.8,
            flowRate: 10
        )

        let result =
            try engine.compare(input: input)

        #expect(
            result.cstrVolume >
            result.pfrVolume
        )
    }

    @Test("Rejects a zero rate constant")
    func rejectsZeroRateConstant() {
        let input = ReactorComparisonInput(
            rateConstant: 0,
            conversion: 0.5,
            flowRate: 5
        )

        #expect(
            throws:
                CalculationError
                    .valueMustBePositive(
                        fieldName:
                            "Rate Constant"
                    )
        ) {
            try engine.compare(input: input)
        }
    }

    @Test("Rejects invalid conversion")
    func rejectsInvalidConversion() {
        let input = ReactorComparisonInput(
            rateConstant: 0.1,
            conversion: 1,
            flowRate: 5
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Conversion must be greater than zero and less than one."
                    )
        ) {
            try engine.compare(input: input)
        }
    }
}
