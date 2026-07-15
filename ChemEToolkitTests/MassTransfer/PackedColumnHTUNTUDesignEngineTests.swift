import Testing
@testable import ChemEToolkit

@Suite("Packed-Column HTU–NTU Design Engine")
struct PackedColumnHTUNTUDesignEngineTests {
    private let engine = PackedColumnHTUNTUDesignEngine()

    @Test("Calculates log-mean driving force, NTU and packed height")
    func calculatesPackedHeight() throws {
        let result = try engine.calculate(
            .init(
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 2,
                equilibriumSlope: 1.5,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                overallGasHeightOfTransferUnit: 0.8
            )
        )

        #expect(abs(result.liquidOutletSoluteRatio - 0.095) < 1e-12)
        #expect(abs(result.logMeanDrivingForce - 0.035509592385300826) < 1e-14)
        #expect(abs(result.overallGasNumberOfTransferUnits - 4.224210696997255) < 1e-12)
        #expect(abs(result.requiredPackedHeight - 3.379368557597804) < 1e-12)
    }

    @Test("Uses the equal-end-driving-force limit")
    func equalDrivingForces() throws {
        let result = try engine.calculate(
            .init(
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 1.5,
                equilibriumSlope: 1.5,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                overallGasHeightOfTransferUnit: 1
            )
        )

        #expect(abs(result.topDrivingForce - 0.02) < 1e-12)
        #expect(abs(result.bottomDrivingForce - 0.02) < 1e-12)
        #expect(abs(result.overallGasNumberOfTransferUnits - 7.5) < 1e-12)
    }

    @Test("Rejects reversed absorption, pinches and nonfinite values")
    func validation() {
        #expect(throws: PackedColumnHTUNTUDesignError.invalidAbsorptionDirection) {
            try engine.calculate(.init(
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 2,
                equilibriumSlope: 1.5,
                gasInletSoluteRatio: 0.05,
                gasOutletSoluteRatio: 0.2,
                liquidInletSoluteRatio: 0.02,
                overallGasHeightOfTransferUnit: 0.8
            ))
        }

        #expect(throws: PackedColumnHTUNTUDesignError.pinchOrCrossedOperatingLine) {
            try engine.calculate(.init(
                soluteFreeGasFlowRate: 1,
                soluteFreeLiquidFlowRate: 1,
                equilibriumSlope: 1.5,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                overallGasHeightOfTransferUnit: 0.8
            ))
        }

        #expect(throws: PackedColumnHTUNTUDesignError.nonFiniteInput) {
            try engine.calculate(.init(
                soluteFreeGasFlowRate: .infinity,
                soluteFreeLiquidFlowRate: 2,
                equilibriumSlope: 1.5,
                gasInletSoluteRatio: 0.2,
                gasOutletSoluteRatio: 0.05,
                liquidInletSoluteRatio: 0.02,
                overallGasHeightOfTransferUnit: 0.8
            ))
        }
    }
}
