import Testing
@testable import ChemEToolkit

@Suite("Equilibrium Conversion Engine")
struct EquilibriumConversionEngineTests {
    private let engine =
        EquilibriumConversionEngine()

    @Test("Calculates forward equilibrium conversion")
    func forwardEquilibrium() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                initialConcentrationB: 0,
                equilibriumConstant: 4
            )
        )

        #expect(
            abs(
                result.equilibriumConcentrationA
                - 0.2
            ) < 1e-12
        )
        #expect(
            abs(
                result.equilibriumConcentrationB
                - 0.8
            ) < 1e-12
        )
        #expect(
            abs(
                result.signedExtentConcentration
                - 0.8
            ) < 1e-12
        )
        #expect(
            abs(
                result.forwardConversionOfInitialA
                - 0.8
            ) < 1e-12
        )
        #expect(
            result.directionDescription
            == "Net reaction proceeds from A toward B."
        )
    }

    @Test("Preserves reverse equilibrium direction")
    func reverseEquilibrium() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 0,
                initialConcentrationB: 1,
                equilibriumConstant: 4
            )
        )

        #expect(
            abs(
                result.signedExtentConcentration
                + 0.2
            ) < 1e-12
        )
        #expect(
            abs(
                result.reverseConversionOfInitialB
                - 0.2
            ) < 1e-12
        )
        #expect(
            result.initialReactionQuotient
                .isInfinite
        )
        #expect(
            result.directionDescription
            == "Net reaction proceeds from B toward A."
        )
    }

    @Test("Rejects invalid equilibrium inputs")
    func validation() {
        #expect(
            throws:
                EquilibriumConversionError
                    .zeroTotalConcentration
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 0,
                    initialConcentrationB: 0,
                    equilibriumConstant: 4
                )
            )
        }

        #expect(
            throws:
                EquilibriumConversionError
                    .nonPositiveEquilibriumConstant
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    initialConcentrationB: 0,
                    equilibriumConstant: 0
                )
            )
        }

        #expect(
            throws:
                EquilibriumConversionError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    initialConcentrationB: 0,
                    equilibriumConstant: 4
                )
            )
        }
    }
}
