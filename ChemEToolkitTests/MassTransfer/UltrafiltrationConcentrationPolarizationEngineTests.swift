import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Ultrafiltration Concentration Polarization Engine")
struct UltrafiltrationConcentrationPolarizationEngineTests {
    private let engine =
        UltrafiltrationConcentrationPolarizationEngine()

    @Test("Calculates gel-polarization limiting flux and retentate concentration")
    func calculatesPerformance() throws {
        let result = try engine.calculate(
            .init(
                feedVolumetricFlowRate: 5,
                membraneArea: 20,
                liquidSideMassTransferCoefficient: 0.02,
                bulkSoluteConcentration: 10,
                gelConcentration: 100,
                observedSievingCoefficient: 0.02
            )
        )

        #expect(
            abs(
                result.limitingFluxLMH
                - 46.051701859880914
            ) < 1e-10
        )
        #expect(
            abs(
                result.permeateFlowRate
                - 0.9210340371976183
            ) < 1e-12
        )
        #expect(
            abs(
                result.volumetricRecoveryFraction
                - 0.18420680743952366
            ) < 1e-12
        )
        #expect(
            abs(
                result.permeateSoluteConcentration
                - 0.2
            ) < 1e-12
        )
        #expect(
            abs(
                result.retentateSoluteConcentration
                - 12.212848463764923
            ) < 1e-12
        )
        #expect(
            abs(result.observedRejection - 0.98)
            < 1e-12
        )
    }

    @Test("Handles total observed rejection")
    func totalRejectionBoundary() throws {
        let result = try engine.calculate(
            .init(
                feedVolumetricFlowRate: 5,
                membraneArea: 20,
                liquidSideMassTransferCoefficient: 0.02,
                bulkSoluteConcentration: 10,
                gelConcentration: 100,
                observedSievingCoefficient: 0
            )
        )

        #expect(
            result.permeateSoluteConcentration
            == 0
        )
        #expect(
            result.observedRejection == 1
        )
    }

    @Test("Rejects invalid gel state, sieving and recovery")
    func validation() {
        #expect(
            throws:
                UltrafiltrationConcentrationPolarizationError
                    .gelConcentrationNotAboveBulk
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: 5,
                    membraneArea: 20,
                    liquidSideMassTransferCoefficient: 0.02,
                    bulkSoluteConcentration: 10,
                    gelConcentration: 10,
                    observedSievingCoefficient: 0.02
                )
            )
        }

        #expect(
            throws:
                UltrafiltrationConcentrationPolarizationError
                    .sievingCoefficientOutOfRange
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: 5,
                    membraneArea: 20,
                    liquidSideMassTransferCoefficient: 0.02,
                    bulkSoluteConcentration: 10,
                    gelConcentration: 100,
                    observedSievingCoefficient: 1.1
                )
            )
        }

        #expect(
            throws:
                UltrafiltrationConcentrationPolarizationError
                    .recoveryOutsideLowRecoveryModel
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: 5,
                    membraneArea: 50,
                    liquidSideMassTransferCoefficient: 0.02,
                    bulkSoluteConcentration: 10,
                    gelConcentration: 100,
                    observedSievingCoefficient: 0.02
                )
            )
        }

        #expect(
            throws:
                UltrafiltrationConcentrationPolarizationError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: .nan,
                    membraneArea: 20,
                    liquidSideMassTransferCoefficient: 0.02,
                    bulkSoluteConcentration: 10,
                    gelConcentration: 100,
                    observedSievingCoefficient: 0.02
                )
            )
        }
    }
}
