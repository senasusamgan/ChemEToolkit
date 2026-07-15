import SwiftUI

struct PackedColumnHTUNTUDesignView: View {
    @State private var gasFlow = "1"
    @State private var liquidFlow = "2"
    @State private var slope = "1.5"
    @State private var gasInlet = "0.2"
    @State private var gasOutlet = "0.05"
    @State private var liquidInlet = "0.02"
    @State private var htu = "0.8"
    @State private var result: PackedColumnHTUNTUDesignResult?
    @State private var errorMessage = ""

    private let engine = PackedColumnHTUNTUDesignEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "ruler",
                    title: "Packed-Column HTU–NTU Design",
                    subtitle: "Calculate overall gas NTU and required packed height for dilute absorption",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Overall Gas-Phase Design").font(.headline)
                        Text("Z = HOG × NOG")
                            .font(.system(size: 23, weight: .semibold))
                        Text("NOG = (Yin − Yout)/ΔYlm")
                            .font(.system(size: 18, weight: .semibold))
                        Text("The log-mean driving force is exact for the implemented linear equilibrium and operating lines. Both column ends are checked for a pinch.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("Solute-Free Flow Rates").font(.headline)

                        EngineeringInputField(
                            title: "Solute-Free Gas Flow",
                            symbol: "Gₛ",
                            unit: "mol/s",
                            placeholder: "Example: 1",
                            text: $gasFlow
                        )

                        EngineeringInputField(
                            title: "Solute-Free Liquid Flow",
                            symbol: "Lₛ",
                            unit: "mol/s",
                            placeholder: "Example: 2",
                            text: $liquidFlow
                        )

                        EngineeringInputField(
                            title: "Equilibrium-Line Slope",
                            symbol: "m",
                            unit: "—",
                            placeholder: "Example: 1.5",
                            text: $slope
                        )

                        Divider()
                        Text("Column-End Solute Ratios").font(.headline)

                        EngineeringInputField(
                            title: "Gas Inlet Solute Ratio",
                            symbol: "Yin",
                            unit: "mol/mol",
                            placeholder: "Example: 0.2",
                            text: $gasInlet
                        )

                        EngineeringInputField(
                            title: "Gas Outlet Solute Ratio",
                            symbol: "Yout",
                            unit: "mol/mol",
                            placeholder: "Example: 0.05",
                            text: $gasOutlet
                        )

                        EngineeringInputField(
                            title: "Liquid Inlet Solute Ratio",
                            symbol: "Xin",
                            unit: "mol/mol",
                            placeholder: "Example: 0.02",
                            text: $liquidInlet
                        )

                        Divider()
                        Text("Transfer-Unit Property").font(.headline)

                        EngineeringInputField(
                            title: "Overall Gas HTU",
                            symbol: "HOG",
                            unit: "m",
                            placeholder: "Example: 0.8",
                            text: $htu
                        )

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)

                        PrimaryActionButton(
                            title: "Calculate Packed Height",
                            systemImage: "ruler",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Liquid Outlet Solute Ratio", value: formatter.format(result.liquidOutletSoluteRatio), unit: "mol/mol"),
                                    .init(label: "Top Driving Force", value: formatter.format(result.topDrivingForce), unit: "ratio"),
                                    .init(label: "Bottom Driving Force", value: formatter.format(result.bottomDrivingForce), unit: "ratio"),
                                    .init(label: "Log-Mean Driving Force", value: formatter.format(result.logMeanDrivingForce), unit: "ratio"),
                                    .init(label: "Overall Gas NTU", value: formatter.format(result.overallGasNumberOfTransferUnits), unit: "—"),
                                    .init(label: "Required Packed Height", value: formatter.format(result.requiredPackedHeight), unit: "m"),
                                    .init(label: "Minimum Liquid Flow", value: formatter.format(result.minimumLiquidFlowRate), unit: "mol/s"),
                                    .init(label: "Actual / Minimum Liquid Flow", value: formatter.format(result.actualToMinimumLiquidFlowRatio), unit: "—")
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label("Design Basis", systemImage: "ruler").font(.headline)
                                    Divider()
                                    Text(result.modelName).fontWeight(.semibold)
                                    Text("Operating-line slope Gₛ/Lₛ = \(formatter.format(result.operatingLineSlope)).")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Packed-Column HTU–NTU")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(
                .init(
                    soluteFreeGasFlowRate: try InputValidator.parseNumber(gasFlow, fieldName: "solute-free gas flow"),
                    soluteFreeLiquidFlowRate: try InputValidator.parseNumber(liquidFlow, fieldName: "solute-free liquid flow"),
                    equilibriumSlope: try InputValidator.parseNumber(slope, fieldName: "equilibrium-line slope"),
                    gasInletSoluteRatio: try InputValidator.parseNumber(gasInlet, fieldName: "gas inlet solute ratio"),
                    gasOutletSoluteRatio: try InputValidator.parseNumber(gasOutlet, fieldName: "gas outlet solute ratio"),
                    liquidInletSoluteRatio: try InputValidator.parseNumber(liquidInlet, fieldName: "liquid inlet solute ratio"),
                    overallGasHeightOfTransferUnit: try InputValidator.parseNumber(htu, fieldName: "overall gas HTU")
                )
            )
        } catch {
            errorMessage = MassTransferViewSupport.errorMessage(for: error)
        }
    }

    private func loadExample() {
        gasFlow = "1"
        liquidFlow = "2"
        slope = "1.5"
        gasInlet = "0.2"
        gasOutlet = "0.05"
        liquidInlet = "0.02"
        htu = "0.8"
        clearResult()
    }

    private func resetInputs() {
        gasFlow = ""
        liquidFlow = ""
        slope = ""
        gasInlet = ""
        gasOutlet = ""
        liquidInlet = ""
        htu = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { PackedColumnHTUNTUDesignView() }
}
