import SwiftUI

struct CSTRsInSeriesView: View {
    @State private var rateConstantInput = "0.002"
    @State private var volumeInput = "5"
    @State private var flowInput = "0.002"
    @State private var countInput = "4"

    @State private var result: CSTRsInSeriesResult?
    @State private var errorMessage = ""

    private let engine = CSTRsInSeriesEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up.fill",
                    title: "CSTRs in Series",
                    subtitle: "Compare an equal CSTR cascade with one CSTR and a PFR",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("X_N = 1 − (1 + kτ/N)⁻ᴺ")
                            .font(.headline)

                        Text("As N increases, an equal-volume CSTR cascade approaches PFR performance.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "First-Order Rate Constant",
                            symbol: "k",
                            unit: "1/s",
                            placeholder: "Example: 0.002",
                            text: $rateConstantInput
                        )

                        EngineeringInputField(
                            title: "Total Reactor Volume",
                            symbol: "V_T",
                            unit: "m³",
                            placeholder: "Example: 5",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.002",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Number of Reactors",
                            symbol: "N",
                            unit: "whole number",
                            placeholder: "Example: 4",
                            text: $countInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "square.stack.3d.up.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Cascade Conversion",
                                            value: numberFormatter.format(
                                                100 * result.conversionForSeries
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "Single-CSTR Conversion",
                                            value: numberFormatter.format(
                                                100 * result.conversionForSingleCSTR
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "PFR Conversion",
                                            value: numberFormatter.format(
                                                100 * result.conversionForPFR
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "Gain over One CSTR",
                                            value: numberFormatter.format(
                                                100 * result.seriesGainOverSingleCSTR
                                            ),
                                            unit: "percentage points"
                                        ),
                                        .init(
                                            label: "Gap to PFR",
                                            value: numberFormatter.format(
                                                100 * result.remainingGapToPFR
                                            ),
                                            unit: "percentage points"
                                        ),
                                        .init(
                                            label: "Space Time per Tank",
                                            value: numberFormatter.format(
                                                result.spaceTimePerReactor
                                            ),
                                            unit: "s"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(result.modelName)
                                            .font(.headline)

                                        Divider()

                                        Text(result.limitationDescription)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("CSTRs in Series")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    firstOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName: "first-order rate constant"
                        ),
                    totalReactorVolume:
                        try InputValidator.parseNumber(
                            volumeInput,
                            fieldName: "total reactor volume"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName: "volumetric flow rate"
                        ),
                    numberOfReactors:
                        try InputValidator.parseNumber(
                            countInput,
                            fieldName: "number of reactors"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        rateConstantInput = "0.002"
        volumeInput = "5"
        flowInput = "0.002"
        countInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        rateConstantInput = ""
        volumeInput = ""
        flowInput = ""
        countInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CSTRsInSeriesView()
    }
}
