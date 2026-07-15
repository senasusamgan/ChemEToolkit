import Testing
@testable import ChemEToolkit

@Suite("Constant-Volume Stoichiometry Engine")
struct ConstantVolumeStoichiometryEngineTests {
    private let engine =
        ConstantVolumeStoichiometryEngine()

    @Test("Calculates the constant-volume concentration table")
    func calculatesTable() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 2,
                initialConcentrationB: 3,
                initialConcentrationProduct: 0,
                stoichiometricCoefficientA: 1,
                stoichiometricCoefficientB: 2,
                stoichiometricCoefficientProduct: 1,
                conversionOfA: 0.5
            )
        )

        #expect(
            result.reactionExtentPerVolume
            == 1
        )
        #expect(
            result.finalConcentrationA
            == 1
        )
        #expect(
            result.finalConcentrationB
            == 1
        )
        #expect(
            result.finalConcentrationProduct
            == 1
        )
        #expect(
            abs(
                result.conversionOfB
                - 2.0 / 3.0
            ) < 1e-12
        )
        #expect(
            result.maximumFeasibleConversionOfA
            == 0.75
        )
        #expect(
            result.limitingReactant
            == .reactantB
        )
    }

    @Test("Recognizes a stoichiometric feed")
    func stoichiometricFeed() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 2,
                initialConcentrationB: 4,
                initialConcentrationProduct: 0,
                stoichiometricCoefficientA: 1,
                stoichiometricCoefficientB: 2,
                stoichiometricCoefficientProduct: 1,
                conversionOfA: 1
            )
        )

        #expect(
            result.limitingReactant
            == .stoichiometricFeed
        )
        #expect(
            result.finalConcentrationA
            == 0
        )
        #expect(
            result.finalConcentrationB
            == 0
        )
    }

    @Test("Rejects infeasible conversion and invalid data")
    func validation() {
        #expect(
            throws:
                ConstantVolumeStoichiometryError
                    .conversionExceedsReactantAvailability
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 2,
                    initialConcentrationB: 3,
                    initialConcentrationProduct: 0,
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 2,
                    stoichiometricCoefficientProduct: 1,
                    conversionOfA: 0.8
                )
            )
        }

        #expect(
            throws:
                ConstantVolumeStoichiometryError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 2,
                    initialConcentrationB: 4,
                    initialConcentrationProduct: 0,
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 2,
                    stoichiometricCoefficientProduct: 1,
                    conversionOfA: 1.1
                )
            )
        }

        #expect(
            throws:
                ConstantVolumeStoichiometryError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    initialConcentrationB: 4,
                    initialConcentrationProduct: 0,
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 2,
                    stoichiometricCoefficientProduct: 1,
                    conversionOfA: 0.5
                )
            )
        }
    }
}
