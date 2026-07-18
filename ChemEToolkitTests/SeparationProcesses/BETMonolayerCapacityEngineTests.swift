import Testing
@testable import ChemEToolkit

@Suite("BET Monolayer Capacity Engine")
struct BETMonolayerCapacityEngineTests {
    private let engine =
        BETMonolayerCapacityEngine()

    @Test("Calculates BET loading")
    func loading() throws {
        let result =
            try engine.calculate(
                .init(
                    relativePressure: 0.20,
                    monolayerCapacity: 5,
                    betConstant: 50
                )
            )

        let monolayerCapacity =
            5.0

        let betConstant =
            50.0

        let relativePressure =
            0.20

        let denominator =
            (
                1.0 - relativePressure
            )
            * (
                1.0
                + (
                    betConstant - 1.0
                )
                * relativePressure
            )

        let expected =
            monolayerCapacity
            * betConstant
            * relativePressure
            / denominator

        #expect(
            abs(
                result.equilibriumLoading
                - expected
            ) < 1e-12
        )
    }

    @Test("Higher relative pressure raises loading")
    func pressureTrend() throws {
        let low =
            try engine.calculate(
                .init(
                    relativePressure: 0.10,
                    monolayerCapacity: 5,
                    betConstant: 50
                )
            )

        let high =
            try engine.calculate(
                .init(
                    relativePressure: 0.30,
                    monolayerCapacity: 5,
                    betConstant: 50
                )
            )

        #expect(
            high.equilibriumLoading
            > low.equilibriumLoading
        )
    }

    @Test("Rejects relative pressure of one")
    func validation() {
        #expect(
            throws:
                BETMonolayerCapacityError
                    .invalidRelativePressure
        ) {
            try engine.calculate(
                .init(
                    relativePressure: 1,
                    monolayerCapacity: 5,
                    betConstant: 50
                )
            )
        }
    }
}
