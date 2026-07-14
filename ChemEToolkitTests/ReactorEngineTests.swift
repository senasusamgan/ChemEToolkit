import Testing
@testable import ChemEToolkit

@Suite("Reactor Design Engine")
struct ReactorEngineTests {
    private let engine = ReactorEngine()
    private let tolerance = 0.00000001

    @Test("Calculates Batch conversion")
    func calculatesBatchConversion() throws {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: nil,
            time: 10,
            spaceTime: nil,
            flowRate: nil
        )

        let result = try engine.solve(
            reactorType: .batch,
            calculation: .conversion,
            input: input
        )

        #expect(
            abs(
                result.items[0].value -
                0.6321205588285577
            ) < tolerance
        )
    }

    @Test("Calculates Batch reaction time")
    func calculatesBatchTime() throws {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: 0.5,
            time: nil,
            spaceTime: nil,
            flowRate: nil
        )

        let result = try engine.solve(
            reactorType: .batch,
            calculation: .time,
            input: input
        )

        #expect(
            abs(
                result.items[0].value -
                6.931471805599453
            ) < tolerance
        )
    }

    @Test("Calculates Batch rate constant")
    func calculatesBatchRateConstant() throws {
        let input = ReactorInput(
            rateConstant: nil,
            conversion: 0.5,
            time: 10,
            spaceTime: nil,
            flowRate: nil
        )

        let result = try engine.solve(
            reactorType: .batch,
            calculation: .rateConstant,
            input: input
        )

        #expect(
            abs(
                result.items[0].value -
                0.06931471805599453
            ) < tolerance
        )
    }

    @Test("Calculates PFR conversion")
    func calculatesPFRConversion() throws {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: nil,
            time: nil,
            spaceTime: 10,
            flowRate: nil
        )

        let result = try engine.solve(
            reactorType: .pfr,
            calculation: .conversion,
            input: input
        )

        #expect(
            abs(
                result.items[0].value -
                0.6321205588285577
            ) < tolerance
        )
    }

    @Test("Calculates CSTR conversion")
    func calculatesCSTRConversion() throws {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: nil,
            time: nil,
            spaceTime: 10,
            flowRate: nil
        )

        let result = try engine.solve(
            reactorType: .cstr,
            calculation: .conversion,
            input: input
        )

        #expect(
            abs(result.items[0].value - 0.5) <
            tolerance
        )
    }

    @Test("Calculates CSTR volume")
    func calculatesCSTRVolume() throws {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: 0.5,
            time: nil,
            spaceTime: nil,
            flowRate: 5
        )

        let result = try engine.solve(
            reactorType: .cstr,
            calculation: .volume,
            input: input
        )

        #expect(result.items.count == 2)

        #expect(
            abs(result.items[0].value - 10) <
            tolerance
        )

        #expect(
            abs(result.items[1].value - 50) <
            tolerance
        )
    }

    @Test("Calculates PFR volume")
    func calculatesPFRVolume() throws {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: 0.5,
            time: nil,
            spaceTime: nil,
            flowRate: 5
        )

        let result = try engine.solve(
            reactorType: .pfr,
            calculation: .volume,
            input: input
        )

        #expect(
            abs(
                result.items[0].value -
                6.931471805599453
            ) < tolerance
        )

        #expect(
            abs(
                result.items[1].value -
                34.657359027997266
            ) < tolerance
        )
    }

    @Test("Rejects zero rate constant")
    func rejectsZeroRateConstant() {
        let input = ReactorInput(
            rateConstant: 0,
            conversion: nil,
            time: 10,
            spaceTime: nil,
            flowRate: nil
        )

        #expect(
            throws: CalculationError.valueMustBePositive(
                fieldName: "Rate Constant"
            )
        ) {
            try engine.solve(
                reactorType: .batch,
                calculation: .conversion,
                input: input
            )
        }
    }

    @Test("Rejects invalid conversion")
    func rejectsInvalidConversion() {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: 1,
            time: nil,
            spaceTime: nil,
            flowRate: nil
        )

        #expect(
            throws: CalculationError.calculationFailed(
                reason:
                    "Conversion must be at least zero and less than one."
            )
        ) {
            try engine.solve(
                reactorType: .pfr,
                calculation: .spaceTime,
                input: input
            )
        }
    }

    @Test("Rejects unsupported Batch volume calculation")
    func rejectsUnsupportedCalculation() {
        let input = ReactorInput(
            rateConstant: 0.1,
            conversion: 0.5,
            time: nil,
            spaceTime: nil,
            flowRate: 5
        )

        #expect(
            throws: CalculationError.calculationFailed(
                reason:
                    "Reactor Volume is not supported for Batch Reactor."
            )
        ) {
            try engine.solve(
                reactorType: .batch,
                calculation: .volume,
                input: input
            )
        }
    }
}//
//  ReactorEngineTests.swift
//  ChemEToolkitTests
//
//  Created by Sena Su Samgan on 14.07.2026.
//

import Foundation
