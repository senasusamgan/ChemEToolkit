import Testing
@testable import ChemEToolkit

@Suite("Straight-Line Depreciation Engine")
struct StraightLineDepreciationEngineTests {
    private let engine =
        StraightLineDepreciationEngine()

    @Test("Calculates annual and accumulated depreciation")
    func depreciation() throws {
        let result = try engine.calculate(
            .init(
                depreciableAssetCost:
                    10000000,
                salvageValue: 1000000,
                serviceLifeYears: 10,
                evaluationAgeYears: 4
            )
        )

        #expect(
            result.depreciableBasis
            == 9000000
        )

        #expect(
            result.annualDepreciation
            == 900000
        )

        #expect(
            result.accumulatedDepreciation
            == 3600000
        )

        #expect(
            result.bookValue
            == 6400000
        )

        #expect(
            result.remainingDepreciableBasis
            == 5400000
        )

        #expect(
            abs(
                result.elapsedLifeFraction
                - 0.4
            ) < 1e-12
        )
    }

    @Test("Book value reaches salvage at end of life")
    func endOfLife() throws {
        let result = try engine.calculate(
            .init(
                depreciableAssetCost:
                    10_000_000,
                salvageValue: 1_000_000,
                serviceLifeYears: 10,
                evaluationAgeYears: 10
            )
        )

        #expect(result.bookValue == 1_000_000)

        #expect(
            result.remainingDepreciableBasis
            == 0
        )

        #expect(result.assetIsFullyDepreciated)
    }

    @Test("Rejects invalid evaluation age")
    func validation() {
        #expect(
            throws:
                StraightLineDepreciationError
                    .invalidEvaluationAge
        ) {
            try engine.calculate(
                .init(
                    depreciableAssetCost:
                        10_000_000,
                    salvageValue: 1_000_000,
                    serviceLifeYears: 10,
                    evaluationAgeYears: 11
                )
            )
        }
    }
}
