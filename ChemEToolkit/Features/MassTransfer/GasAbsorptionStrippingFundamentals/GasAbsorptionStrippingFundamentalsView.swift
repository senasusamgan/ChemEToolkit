import SwiftUI

struct GasAbsorptionStrippingFundamentalsView: View {
    @State private var operation: GasAbsorptionStrippingOperation = .absorption
    @State private var gasFlow = "1"
    @State private var liquidFlow = "2"
    @State private var gasInlet = "0.2"
    @State private var gasOutlet = "0.05"
    @State private var liquidInlet = "0.02"
    @State private var slope = "1.5"
    @State private var result: GasAbsorptionStrippingFundamentalsResult?
    @State private var errorMessage = ""

    private let engine = GasAbsorptionStrippingFundamentalsEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.down.to.line",
                    title: "Gas Absorption & Stripping Fundamentals",
                    subtitle: "Solve countercurrent balances, operating factors and limiting carrier flow",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Solute-Free Countercurrent Balance").font(.headline)
                        Text("Gₛ(Yin − Yout) = Lₛ(Xout − Xin)")
                            .font(.system(size: 18, weight: .semibold))
                            .minimumScaleFactor(0.55)
                        Text("A = Lₛ/(mGₛ)    •    S = 1/A")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Uses dilute solute-free ratios and a linear equilibrium relation. The limiting flow is calculated from the corresponding equilibrium pinch.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("Operation").font(.headline)

                        Picker("Operation", selection: $operation) {
                            ForEach(GasAbsorptionStrippingOperation.allCases) {
                                Text($0.title).tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .onChange(of: operation) { loadExample() }

                        Divider()
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

                        Divider()
                        Text("Solute Ratios and Equilibrium").font(.headline)

                        EngineeringInputField(
                            title: "Gas Inlet Solute Ratio",
                            symbol: "Yin",
                            unit: "mol/mol",
                            placeholder: operation == .absorption ? "Example: 0.2" : "Example: 0.01",
                            text: $gasInlet
                        )

                        EngineeringInputField(
                            title: "Gas Outlet Solute Ratio",
                            symbol: "Yout",
                            unit: "mol/mol",
                            placeholder: operation == .absorption ? "Example: 0.05" : "Example: 0.08",
                            text: $gasOutlet
                        )

                        EngineeringInputField(
                            title: "Liquid Inlet Solute Ratio",
                            symbol: "Xin",
                            unit: "mol/mol",
                            placeholder: operation == .absorption ? "Example: 0.02" : "Example: 0.1",
                            text: $liquidInlet
                        )

                        EngineeringInputField(
                            title: "Equilibrium-Line Slope",
                            symbol: "m",
                            unit: "—",
                            placeholder: "Example: 1.5",
                            text: $slope
                        )

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)

                        PrimaryActionButton(
                            title: "Solve Countercurrent Balance",
                            systemImage: "arrow.down.to.line",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Liquid Outlet Solute Ratio", value: formatter.format(result.liquidOutletSoluteRatio), unit: "mol/mol"),
                                    .init(label: "Absorption Factor", value: formatter.format(result.absorptionFactor), unit: "—"),
                                    .init(label: "Stripping Factor", value: formatter.format(result.strippingFactor), unit: "—"),
                                    .init(label: "Transfer-Rate Magnitude", value: formatter.format(result.transferRateMagnitude), unit: "mol/s"),
                                    .init(label: "Solute Removal", value: formatter.format(100 * result.soluteRemovalFraction), unit: "%"),
                                    .init(label: result.limitingFlowDescription, value: formatter.format(result.limitingCarrierFlowRate), unit: "mol/s"),
                                    .init(label: "Actual / Minimum Flow", value: formatter.format(result.actualToMinimumFlowRatio), unit: "—"),
                                    .init(label: "Pinch Driving Force", value: formatter.format(result.pinchDrivingForce), unit: "ratio")
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label("Process Interpretation", systemImage: "arrow.down.to.line")
                                        .font(.headline)
                                    Divider()
                                    Text(result.directionDescription).fontWeight(.semibold)
                                    Text(result.modelName).foregroundStyle(.secondary)
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
        .navigationTitle("Absorption & Stripping")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(
                .init(
                    operation: operation,
                    soluteFreeGasFlowRate: try InputValidator.parseNumber(gasFlow, fieldName: "solute-free gas flow"),
                    soluteFreeLiquidFlowRate: try InputValidator.parseNumber(liquidFlow, fieldName: "solute-free liquid flow"),
                    gasInletSoluteRatio: try InputValidator.parseNumber(gasInlet, fieldName: "gas inlet solute ratio"),
                    gasOutletSoluteRatio: try InputValidator.parseNumber(gasOutlet, fieldName: "gas outlet solute ratio"),
                    liquidInletSoluteRatio: try InputValidator.parseNumber(liquidInlet, fieldName: "liquid inlet solute ratio"),
                    equilibriumSlope: try InputValidator.parseNumber(slope, fieldName: "equilibrium-line slope")
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
        switch operation {
        case .absorption:
            gasInlet = "0.2"
            gasOutlet = "0.05"
            liquidInlet = "0.02"
        case .stripping:
            gasInlet = "0.01"
            gasOutlet = "0.08"
            liquidInlet = "0.1"
        }
        clearResult()
    }

    private func resetInputs() {
        gasFlow = ""
        liquidFlow = ""
        gasInlet = ""
        gasOutlet = ""
        liquidInlet = ""
        slope = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { GasAbsorptionStrippingFundamentalsView() }
}
