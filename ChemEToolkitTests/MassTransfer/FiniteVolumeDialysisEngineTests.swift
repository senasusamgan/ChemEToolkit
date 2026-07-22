import Testing
@testable import ChemEToolkit

@Suite("Finite-Volume Dialysis Engine")
struct FiniteVolumeDialysisEngineTests {
    private let engine =
        FiniteVolumeDialysisEngine()

    @Test(
        "Calculates transient donor and receiver concentrations"
    )
    func calculatesTransfer() throws {
        let result = try engine.calculate(
            .init(
                donorVolume: 1,
                receiverVolume: 2,
                membraneArea: 5,
                overallMassTransferCoefficient:
                    0.00001,
                contactTime: 3600,
                donorInitialConcentration:
                    10,
                receiverInitialConcentration:
                    0
            )
        )

        #expect(
            abs(
                result.equilibriumConcentration
                - 3.3333333333333335
            ) < 1e-12
        )
        #expect(
            abs(
                result
                    .concentrationDifferenceDecayFactor
                - 0.7633794943368531
            ) < 1e-12
        )
        #expect(
            abs(
                result.donorFinalConcentration
                - 8.422529962245688
            ) < 1e-12
        )
        #expect(
            abs(
                result.receiverFinalConcentration
                - 0.788735018877156
            ) < 1e-12
        )
        #expect(
            abs(
                result.transferMagnitude
                - 1.577470037754312
            ) < 1e-12
        )
        #expect(
            abs(
                result
                    .fractionOfEquilibriumApproach
                - 0.2366205056631469
            ) < 1e-12
        )
    }

    @Test(
        "Returns unchanged concentrations at zero time and equal states"
    )
    func zeroTimeAndEqualBoundary()
        throws {

        let zeroTime = try engine.calculate(
            .init(
                donorVolume: 1,
                receiverVolume: 2,
                membraneArea: 5,
                overallMassTransferCoefficient:
                    0.00001,
                contactTime: 0,
                donorInitialConcentration:
                    10,
                receiverInitialConcentration:
                    0
            )
        )

        #expect(
            zeroTime.donorFinalConcentration
            == 10
        )
        #expect(
            abs(
                zeroTime.receiverFinalConcentration
            ) < 1e-12
        )
        #expect(
            zeroTime.transferMagnitude == 0
        )

        let equalState = try engine.calculate(
            .init(
                donorVolume: 1,
                receiverVolume: 2,
                membraneArea: 5,
                overallMassTransferCoefficient:
                    0.00001,
                contactTime: 3600,
                donorInitialConcentration:
                    4,
                receiverInitialConcentration:
                    4
            )
        )

        #expect(
            equalState.donorFinalConcentration
            == 4
        )
        #expect(
            equalState.receiverFinalConcentration
            == 4
        )
        #expect(
            equalState.initialSignedFlux == 0
        )
    }

    @Test(
        "Rejects invalid properties, negative values and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                FiniteVolumeDialysisError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    donorVolume: 0,
                    receiverVolume: 2,
                    membraneArea: 5,
                    overallMassTransferCoefficient:
                        0.00001,
                    contactTime: 3600,
                    donorInitialConcentration:
                        10,
                    receiverInitialConcentration:
                        0
                )
            )
        }

        #expect(
            throws:
                FiniteVolumeDialysisError
                    .negativeContactTime
        ) {
            try engine.calculate(
                .init(
                    donorVolume: 1,
                    receiverVolume: 2,
                    membraneArea: 5,
                    overallMassTransferCoefficient:
                        0.00001,
                    contactTime: -1,
                    donorInitialConcentration:
                        10,
                    receiverInitialConcentration:
                        0
                )
            )
        }

        #expect(
            throws:
                FiniteVolumeDialysisError
                    .negativeConcentration
        ) {
            try engine.calculate(
                .init(
                    donorVolume: 1,
                    receiverVolume: 2,
                    membraneArea: 5,
                    overallMassTransferCoefficient:
                        0.00001,
                    contactTime: 3600,
                    donorInitialConcentration:
                        -1,
                    receiverInitialConcentration:
                        0
                )
            )
        }

        #expect(
            throws:
                FiniteVolumeDialysisError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    donorVolume: .nan,
                    receiverVolume: 2,
                    membraneArea: 5,
                    overallMassTransferCoefficient:
                        0.00001,
                    contactTime: 3600,
                    donorInitialConcentration:
                        10,
                    receiverInitialConcentration:
                        0
                )
            )
        }
    }
}
