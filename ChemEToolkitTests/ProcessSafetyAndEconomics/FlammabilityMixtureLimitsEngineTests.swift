import Testing
@testable import ChemEToolkit

@Suite("Flammability Mixture Limits Engine")
struct FlammabilityMixtureLimitsEngineTests {
    private let engine =
        FlammabilityMixtureLimitsEngine()

    @Test("Calculates reciprocal mixture limits")
    func mixtureLimits() throws {
        let result = try engine.calculate(
            .init(
                component1Fraction: 0.5,
                component1LowerLimit: 5,
                component1UpperLimit: 15,
                component2Fraction: 0.3,
                component2LowerLimit: 2.1,
                component2UpperLimit: 9.5,
                component3Fraction: 0.2,
                component3LowerLimit: 1.8,
                component3UpperLimit: 8.4
            )
        )

        #expect(
            abs(
                result.mixtureLowerFlammabilityLimit
                - 2.8251121076233181
            ) < 1e-12
        )

        #expect(
            abs(
                result.mixtureUpperFlammabilityLimit
                - 11.271186440677965
            ) < 1e-12
        )

        #expect(
            result.dominantFuelComponent
            == "Component 1"
        )
    }

    @Test("Normalizes fractions that do not sum to one")
    func normalization() throws {
        let result = try engine.calculate(
            .init(
                component1Fraction: 2,
                component1LowerLimit: 5,
                component1UpperLimit: 15,
                component2Fraction: 1,
                component2LowerLimit: 2,
                component2UpperLimit: 10,
                component3Fraction: 1,
                component3LowerLimit: 1,
                component3UpperLimit: 8
            )
        )

        #expect(
            result.combustibleFractionSum == 4
        )

        #expect(
            result.normalizedComponent1Fraction
            == 0.5
        )
    }

    @Test("Rejects invalid active-component limits")
    func validation() {
        #expect(
            throws:
                FlammabilityMixtureLimitsError
                    .invalidFlammabilityLimit
        ) {
            try engine.calculate(
                .init(
                    component1Fraction: 1,
                    component1LowerLimit: 5,
                    component1UpperLimit: 4,
                    component2Fraction: 0,
                    component2LowerLimit: 0,
                    component2UpperLimit: 0,
                    component3Fraction: 0,
                    component3LowerLimit: 0,
                    component3UpperLimit: 0
                )
            )
        }
    }
}
