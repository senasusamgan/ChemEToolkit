import SwiftUI

struct LevenspielPlotSizingView:
    View {

    @State private var feedRateInput = "2"
    @State private var initialConversionInput = "0"
    @State private var finalConversionInput = "0.8"
    @State private var inverseRateInitialInput = "1"
    @State private var inverseRateMidpointInput = "2"
    @State private var inverseRateFinalInput = "5"

    @State private var result:
        LevenspielPlotSizingResult?

    @State private var errorMessage = ""

    private let engine =
        LevenspielPlotSizingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.area.fill",
                    title:
                        "Levenspiel Plot Sizing",
                    subtitle:
                        "Estimate PFR and CSTR volumes from inverse-rate data",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Ideal-Reactor Design Areas")
                            .font(.headline)

                        Text(
                            "V_PFR = F_A0 ∫ dX/(−r_A)"
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )

                        Text(
                            "PFR area uses Simpson’s rule; CSTR area uses the final inverse rate."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title:
                                "Inlet Molar Flow of A",
                            symbol: "F_A0",
                            unit: "mol/s",
                            placeholder: "Example: 2",
                            text: $feedRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Initial Conversion",
                            symbol: "X₀",
                            unit: "—",
                            placeholder: "Example: 0",
                            text:
                                $initialConversionInput
                        )

                        EngineeringInputField(
                            title:
                                "Final Conversion",
                            symbol: "X₁",
                            unit: "—",
                            placeholder: "Example: 0.8",
                            text:
                                $finalConversionInput
                        )

                        Divider()

                        Text("Inverse-Rate Data")
                            .font(.headline)

                        EngineeringInputField(
                            title:
                                "1/(−r_A) at X₀",
                            symbol: "f₀",
                            unit: "m³·s/mol",
                            placeholder: "Example: 1",
                            text:
                                $inverseRateInitialInput
                        )

                        EngineeringInputField(
                            title:
                                "1/(−r_A) at Midpoint",
                            symbol: "f_m",
                            unit: "m³·s/mol",
                            placeholder: "Example: 2",
                            text:
                                $inverseRateMidpointInput
                        )

                        EngineeringInputField(
                            title:
                                "1/(−r_A) at X₁",
                            symbol: "f₁",
                            unit: "m³·s/mol",
                            placeholder: "Example: 5",
                            text:
                                $inverseRateFinalInput
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
                            title:
                                "Size Ideal Reactors",
                            systemImage:
                                "chart.area.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "PFR Volume",
                                            value:
                                                numberFormatter.format(
                                                    result.pfrVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "CSTR Volume",
                                            value:
                                                numberFormatter.format(
                                                    result.cstrVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "CSTR / PFR Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .cstrToPFRVolumeRatio
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Volume Difference",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .volumeDifference
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "PFR Volume Saving",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .percentVolumeSavingWithPFR
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Simpson Average 1/(−r_A)",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .simpsonAverageInverseRate
                                                ),
                                            unit: "m³·s/mol"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(
                                            result
                                                .comparisonDescription
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)

                                        Text(
                                            result
                                                .limitationDescription
                                        )
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
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Levenspiel Plot")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletMolarFlowRateA:
                        try InputValidator.parseNumber(
                            feedRateInput,
                            fieldName:
                                "inlet molar flow rate A"
                        ),
                    initialConversion:
                        try InputValidator.parseNumber(
                            initialConversionInput,
                            fieldName:
                                "initial conversion"
                        ),
                    finalConversion:
                        try InputValidator.parseNumber(
                            finalConversionInput,
                            fieldName:
                                "final conversion"
                        ),
                    inverseRateAtInitialConversion:
                        try InputValidator.parseNumber(
                            inverseRateInitialInput,
                            fieldName:
                                "initial inverse rate"
                        ),
                    inverseRateAtMidpointConversion:
                        try InputValidator.parseNumber(
                            inverseRateMidpointInput,
                            fieldName:
                                "midpoint inverse rate"
                        ),
                    inverseRateAtFinalConversion:
                        try InputValidator.parseNumber(
                            inverseRateFinalInput,
                            fieldName:
                                "final inverse rate"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedRateInput = "2"
        initialConversionInput = "0"
        finalConversionInput = "0.8"
        inverseRateInitialInput = "1"
        inverseRateMidpointInput = "2"
        inverseRateFinalInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedRateInput = ""
        initialConversionInput = ""
        finalConversionInput = ""
        inverseRateInitialInput = ""
        inverseRateMidpointInput = ""
        inverseRateFinalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LevenspielPlotSizingView()
    }
}
