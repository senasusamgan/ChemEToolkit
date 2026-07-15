struct GasAbsorptionStrippingFundamentalsEngine: Sendable {
    private let tolerance = 1.0e-12

    func calculate(
        _ input: GasAbsorptionStrippingFundamentalsInput
    ) throws -> GasAbsorptionStrippingFundamentalsResult {
        let values = [
            input.soluteFreeGasFlowRate,
            input.soluteFreeLiquidFlowRate,
            input.gasInletSoluteRatio,
            input.gasOutletSoluteRatio,
            input.liquidInletSoluteRatio,
            input.equilibriumSlope
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GasAbsorptionStrippingFundamentalsError.nonFiniteInput
        }
        guard input.soluteFreeGasFlowRate > 0,
              input.soluteFreeLiquidFlowRate > 0,
              input.equilibriumSlope > 0 else {
            throw GasAbsorptionStrippingFundamentalsError.nonPositiveProperty
        }
        guard input.gasInletSoluteRatio >= 0,
              input.gasOutletSoluteRatio >= 0,
              input.liquidInletSoluteRatio >= 0 else {
            throw GasAbsorptionStrippingFundamentalsError.negativeSoluteRatio
        }

        switch input.operation {
        case .absorption:
            guard input.gasInletSoluteRatio > input.gasOutletSoluteRatio else {
                throw GasAbsorptionStrippingFundamentalsError.invalidOperationDirection
            }
        case .stripping:
            guard input.gasOutletSoluteRatio > input.gasInletSoluteRatio else {
                throw GasAbsorptionStrippingFundamentalsError.invalidOperationDirection
            }
        }

        let liquidOutlet =
            input.liquidInletSoluteRatio
            + input.soluteFreeGasFlowRate / input.soluteFreeLiquidFlowRate
            * (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)

        guard liquidOutlet >= 0 else {
            throw GasAbsorptionStrippingFundamentalsError.negativeLiquidOutlet
        }

        let absorptionFactor =
            input.soluteFreeLiquidFlowRate
            / (input.equilibriumSlope * input.soluteFreeGasFlowRate)
        let strippingFactor = 1 / absorptionFactor
        let signedTransfer =
            input.soluteFreeGasFlowRate
            * (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)

        let removal: Double
        let limitingFlow: Double
        let actualToMinimum: Double
        let pinchDrivingForce: Double
        let limitingDescription: String
        let direction: String

        switch input.operation {
        case .absorption:
            guard input.gasInletSoluteRatio > 0 else {
                throw GasAbsorptionStrippingFundamentalsError.infeasibleEquilibrium
            }

            removal =
                (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)
                / input.gasInletSoluteRatio

            let equilibriumLiquid = input.gasInletSoluteRatio / input.equilibriumSlope
            let denominator = equilibriumLiquid - input.liquidInletSoluteRatio
            guard denominator > tolerance else {
                throw GasAbsorptionStrippingFundamentalsError.infeasibleEquilibrium
            }

            limitingFlow =
                input.soluteFreeGasFlowRate
                * (input.gasInletSoluteRatio - input.gasOutletSoluteRatio)
                / denominator
            actualToMinimum = input.soluteFreeLiquidFlowRate / limitingFlow
            pinchDrivingForce =
                input.gasInletSoluteRatio - input.equilibriumSlope * liquidOutlet

            guard pinchDrivingForce > tolerance, actualToMinimum > 1 else {
                throw GasAbsorptionStrippingFundamentalsError.pinchOrInsufficientCarrierFlow
            }

            limitingDescription = "Minimum solute-free liquid flow rate"
            direction = "Solute transfers from the gas phase to the liquid phase."

        case .stripping:
            guard input.liquidInletSoluteRatio > 0 else {
                throw GasAbsorptionStrippingFundamentalsError.infeasibleEquilibrium
            }

            removal =
                (input.liquidInletSoluteRatio - liquidOutlet)
                / input.liquidInletSoluteRatio

            let equilibriumGas = input.equilibriumSlope * input.liquidInletSoluteRatio
            let denominator = equilibriumGas - input.gasInletSoluteRatio
            guard denominator > tolerance else {
                throw GasAbsorptionStrippingFundamentalsError.infeasibleEquilibrium
            }

            limitingFlow =
                input.soluteFreeLiquidFlowRate
                * (input.liquidInletSoluteRatio - liquidOutlet)
                / denominator
            actualToMinimum = input.soluteFreeGasFlowRate / limitingFlow
            pinchDrivingForce = equilibriumGas - input.gasOutletSoluteRatio

            guard pinchDrivingForce > tolerance, actualToMinimum > 1 else {
                throw GasAbsorptionStrippingFundamentalsError.pinchOrInsufficientCarrierFlow
            }

            limitingDescription = "Minimum solute-free stripping-gas flow rate"
            direction = "Solute transfers from the liquid phase to the gas phase."
        }

        return GasAbsorptionStrippingFundamentalsResult(
            liquidOutletSoluteRatio: liquidOutlet,
            absorptionFactor: absorptionFactor,
            strippingFactor: strippingFactor,
            signedTransferRateToLiquid: signedTransfer,
            transferRateMagnitude: abs(signedTransfer),
            soluteRemovalFraction: removal,
            limitingCarrierFlowRate: limitingFlow,
            actualToMinimumFlowRatio: actualToMinimum,
            pinchDrivingForce: pinchDrivingForce,
            limitingFlowDescription: limitingDescription,
            directionDescription: direction,
            modelName: "Dilute countercurrent balance with Y* = mX"
        )
    }
}
