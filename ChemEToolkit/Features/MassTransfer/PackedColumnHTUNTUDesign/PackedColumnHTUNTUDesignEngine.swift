import Foundation

struct PackedColumnHTUNTUDesignEngine: Sendable {
    private let tolerance = 1.0e-12

    func calculate(
        _ input: PackedColumnHTUNTUDesignInput
    ) throws -> PackedColumnHTUNTUDesignResult {
        let values = [
            input.soluteFreeGasFlowRate,
            input.soluteFreeLiquidFlowRate,
            input.equilibriumSlope,
            input.gasInletSoluteRatio,
            input.gasOutletSoluteRatio,
            input.liquidInletSoluteRatio,
            input.overallGasHeightOfTransferUnit
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PackedColumnHTUNTUDesignError.nonFiniteInput
        }
        guard input.soluteFreeGasFlowRate > 0,
              input.soluteFreeLiquidFlowRate > 0,
              input.equilibriumSlope > 0,
              input.overallGasHeightOfTransferUnit > 0 else {
            throw PackedColumnHTUNTUDesignError.nonPositiveProperty
        }
        guard input.gasInletSoluteRatio >= 0,
              input.gasOutletSoluteRatio >= 0,
              input.liquidInletSoluteRatio >= 0 else {
            throw PackedColumnHTUNTUDesignError.negativeSoluteRatio
        }
        guard input.gasInletSoluteRatio > input.gasOutletSoluteRatio else {
            throw PackedColumnHTUNTUDesignError.invalidAbsorptionDirection
        }

        let operatingSlope =
            input.soluteFreeGasFlowRate / input.soluteFreeLiquidFlowRate

        let liquidOutlet =
            input.liquidInletSoluteRatio
            + operatingSlope
            * (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)

        let topDriving =
            input.gasOutletSoluteRatio
            - input.equilibriumSlope * input.liquidInletSoluteRatio
        let bottomDriving =
            input.gasInletSoluteRatio
            - input.equilibriumSlope * liquidOutlet

        guard topDriving > tolerance, bottomDriving > tolerance else {
            throw PackedColumnHTUNTUDesignError.pinchOrCrossedOperatingLine
        }

        let logMeanDriving: Double

        if abs(bottomDriving - topDriving) <= tolerance {
            logMeanDriving = 0.5 * (bottomDriving + topDriving)
        } else {
            let ratio = bottomDriving / topDriving
            guard ratio > 0 else {
                throw PackedColumnHTUNTUDesignError.pinchOrCrossedOperatingLine
            }
            logMeanDriving = (bottomDriving - topDriving) / log(ratio)
        }

        let ntu =
            (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)
            / logMeanDriving
        let height = input.overallGasHeightOfTransferUnit * ntu

        let equilibriumLiquid = input.gasInletSoluteRatio / input.equilibriumSlope
        let minimumDenominator = equilibriumLiquid - input.liquidInletSoluteRatio
        guard minimumDenominator > tolerance else {
            throw PackedColumnHTUNTUDesignError.infeasibleEquilibrium
        }

        let minimumLiquidFlow =
            input.soluteFreeGasFlowRate
            * (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)
            / minimumDenominator
        let actualToMinimum =
            input.soluteFreeLiquidFlowRate / minimumLiquidFlow

        let results = [
            liquidOutlet, logMeanDriving, ntu, height,
            minimumLiquidFlow, actualToMinimum
        ]
        guard results.allSatisfy(\.isFinite),
              results.allSatisfy({ $0 > 0 }) else {
            throw PackedColumnHTUNTUDesignError.numericalFailure
        }

        return PackedColumnHTUNTUDesignResult(
            liquidOutletSoluteRatio: liquidOutlet,
            topDrivingForce: topDriving,
            bottomDrivingForce: bottomDriving,
            logMeanDrivingForce: logMeanDriving,
            overallGasNumberOfTransferUnits: ntu,
            overallGasHeightOfTransferUnit: input.overallGasHeightOfTransferUnit,
            requiredPackedHeight: height,
            minimumLiquidFlowRate: minimumLiquidFlow,
            actualToMinimumLiquidFlowRatio: actualToMinimum,
            operatingLineSlope: operatingSlope,
            modelName: "Dilute countercurrent absorption, overall gas HTU–NTU basis"
        )
    }
}
