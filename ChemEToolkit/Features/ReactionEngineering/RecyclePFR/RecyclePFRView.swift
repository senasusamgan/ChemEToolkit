import SwiftUI

struct RecyclePFRView: View {
    @State private var concentrationInput = "10"
    @State private var flowInput = "0.002"
    @State private var volumeInput = "5"
    @State private var rateInput = "0.002"
    @State private var recycleInput = "2"

    @State private var result: RecyclePFRResult?
    @State private var errorMessage = ""

    private let engine = RecyclePFREngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.trianglehead.2.clockwise.rotate.90",
                    title: "Recycle PFR",
                    subtitle: "Calculate mixing, single-pass and overall conversion with recycle",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("R = v_recycle / v_fresh")
                            .font(.headline)

                        Text("Recycle raises reactor flow and shortens the residence time of each pass.")
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
                            title: "Fresh-Feed Concentration",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 10",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Fresh Volumetric Flow",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.002",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Reactor Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "Example: 5",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "First-Order Rate Constant",
                            symbol: "k",
                            unit: "1/s",
                            placeholder: "Example: 0.002",
                            text: $rateInput
                        )

                        EngineeringInputField(
                            title: "Recycle Ratio",
                            symbol: "R",
                            unit: "—",
                            placeholder: "Example: 2",
                            text: $recycleInput
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
                            systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Total Reactor Flow",
                                            value: numberFormatter.format(
                                                result.totalReactorFlowRate
                                            ),
                                            unit: "m³/s"
                                        ),
                                        .init(
                                            label: "Per-Pass Residence Time",
                                            value: numberFormatter.format(
                                                result.reactorResidenceTime
                                            ),
                                            unit: "s"
                                        ),
                                        .init(
                                            label: "Reactor Inlet Concentration",
                                            value: numberFormatter.format(
                                                result.reactorInletConcentration
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Reactor Outlet Concentration",
                                            value: numberFormatter.format(
                                                result.reactorOutletConcentration
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Single-Pass Conversion",
                                            value: numberFormatter.format(
                                                100 * result.singlePassConversion
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "Overall Fresh-Feed Conversion",
                                            value: numberFormatter.format(
                                                100 * result.overallFreshFeedConversion
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "No-Recycle PFR Conversion",
                                            value: numberFormatter.format(
                                                100 * result.noRecyclePFRConversion
                                            ),
                                            unit: "%"
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
        .navigationTitle("Recycle PFR")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    freshFeedConcentration:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName: "fresh-feed concentration"
                        ),
                    freshVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName: "fresh volumetric flow"
                        ),
                    reactorVolume:
                        try InputValidator.parseNumber(
                            volumeInput,
                            fieldName: "reactor volume"
                        ),
                    firstOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateInput,
                            fieldName: "first-order rate constant"
                        ),
                    recycleRatio:
                        try InputValidator.parseNumber(
                            recycleInput,
                            fieldName: "recycle ratio"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "10"
        flowInput = "0.002"
        volumeInput = "5"
        rateInput = "0.002"
        recycleInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        volumeInput = ""
        rateInput = ""
        recycleInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RecyclePFRView()
    }
}
