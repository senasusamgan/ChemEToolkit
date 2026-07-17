import Testing
@testable import ChemEToolkit

@Suite("Valve Characteristics Engine")
struct ValveCharacteristicsEngineTests {
    private let engine = ValveCharacteristicsEngine()

    @Test("Calculates inherent characteristics")
    func characteristics() throws {
        let linear = try engine.calculate(.init(
            characteristic: .linear, openingPercent: 50, ratedKv: 100,
            rangeability: 50, pressureDrop: 1, liquidDensity: 1000
        ))
        #expect(linear.relativeFlowCoefficient == 0.5)
        #expect(linear.effectiveKv == 50)
        #expect(linear.predictedLiquidFlow == 50)

        let equal = try engine.calculate(.init(
            characteristic: .equalPercentage, openingPercent: 50, ratedKv: 100,
            rangeability: 50, pressureDrop: 1, liquidDensity: 1000
        ))
        #expect(abs(equal.relativeFlowCoefficient - 0.1414213562373095) < 1e-12)
        #expect(abs(equal.effectiveKv - 14.142135623730951) < 1e-12)

        let quick = try engine.calculate(.init(
            characteristic: .quickOpening, openingPercent: 25, ratedKv: 100,
            rangeability: 50, pressureDrop: 1, liquidDensity: 1000
        ))
        #expect(quick.relativeFlowCoefficient == 0.5)
    }

    @Test("Closed valve gives zero effective Kv")
    func closedValve() throws {
        for item in ValveCharacteristicType.allCases {
            let result = try engine.calculate(.init(
                characteristic: item, openingPercent: 0, ratedKv: 100,
                rangeability: 50, pressureDrop: 1, liquidDensity: 1000
            ))
            #expect(result.effectiveKv == 0)
            #expect(result.predictedLiquidFlow == 0)
        }
    }

    @Test("Rejects invalid rangeability")
    func validation() {
        #expect(throws: ValveCharacteristicsError.invalidRangeability) {
            try engine.calculate(.init(
                characteristic: .equalPercentage, openingPercent: 50, ratedKv: 100,
                rangeability: 1, pressureDrop: 1, liquidDensity: 1000
            ))
        }
    }
}
