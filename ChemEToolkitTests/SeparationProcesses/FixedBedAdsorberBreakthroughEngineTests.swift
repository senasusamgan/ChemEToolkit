import Testing
@testable import ChemEToolkit

@Suite("Fixed Bed Adsorber Breakthrough Engine")
struct FixedBedAdsorberBreakthroughEngineTests {
    private let engine =
        FixedBedAdsorberBreakthroughEngine()

    @Test("Calculates positive breakthrough time")
    func breakthrough() throws {
        let result =
            try engine.calculate(
                .init(
                    bedDepth: 1,
                    bedCapacityDensity: 100,
                    inletConcentration: 1,
                    superficialVelocity: 10,
                    kineticConstant: 0.5,
                    breakthroughFraction: 0.05
                )
            )

        #expect(
            result.breakthroughTime
            > 0
        )

        #expect(
            result.capacityTimeTerm
            > result.kineticTimePenalty
        )
    }

    @Test("Deeper bed increases breakthrough time")
    func depthTrend() throws {
        let shallow =
            try engine.calculate(
                .init(
                    bedDepth: 1,
                    bedCapacityDensity: 100,
                    inletConcentration: 1,
                    superficialVelocity: 10,
                    kineticConstant: 0.5,
                    breakthroughFraction: 0.05
                )
            )

        let deep =
            try engine.calculate(
                .init(
                    bedDepth: 2,
                    bedCapacityDensity: 100,
                    inletConcentration: 1,
                    superficialVelocity: 10,
                    kineticConstant: 0.5,
                    breakthroughFraction: 0.05
                )
            )

        #expect(
            deep.breakthroughTime
            > shallow.breakthroughTime
        )
    }

    @Test("Rejects breakthrough fraction above one-half")
    func validation() {
        #expect(
            throws:
                FixedBedAdsorberBreakthroughError
                    .invalidBreakthroughFraction
        ) {
            try engine.calculate(
                .init(
                    bedDepth: 1,
                    bedCapacityDensity: 100,
                    inletConcentration: 1,
                    superficialVelocity: 10,
                    kineticConstant: 0.5,
                    breakthroughFraction: 0.6
                )
            )
        }
    }
}
