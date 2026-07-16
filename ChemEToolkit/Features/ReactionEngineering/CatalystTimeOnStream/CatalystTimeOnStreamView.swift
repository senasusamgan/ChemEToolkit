import SwiftUI

struct CatalystTimeOnStreamView:
    View {

    @State private var damkohlerInput =
        "4"

    @State private var deactivationRateInput =
        "0.1"

    @State private var minimumConversionInput =
        "0.7"

    @State private var result:
        CatalystTimeOnStreamResult?

    @State private var errorMessage = ""

    private let engine =
        CatalystTimeOnStreamEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    title:
                        "Catalyst Time-on-Stream",
                    subtitle:
                        "Estimate when PFR and CSTR conversion fall below an operating limit",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Conversion-Limited Catalyst Lifetime")
                            .font(.headline)

                        Text("a(t) = exp(−k_d t)")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The same fresh Damköhler number is evaluated for ideal PFR and CSTR performance."
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
                                "Fresh Damköhler Number",
                            symbol: "Da₀",
                            unit: "—",
                            placeholder: "4",
                            text: $damkohlerInput
                        )

                        EngineeringInputField(
                            title:
                                "Deactivation Rate Constant",
                            symbol: "k_d",
                            unit: "1/time",
                            placeholder: "0.1",
                            text:
                                $deactivationRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Minimum Acceptable Conversion",
                            symbol: "X_min",
                            unit: "—",
                            placeholder: "0.7",
                            text:
                                $minimumConversionInput
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
                                "Calculate Time-on-Stream",
                            systemImage:
                                "clock.arrow.trianglehead.counterclockwise.rotate.90",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Fresh PFR Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .freshPFRConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Fresh CSTR Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .freshCSTRConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "PFR Time-on-Stream Limit",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .pfrTimeOnStreamLimit
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "CSTR Time-on-Stream Limit",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .cstrTimeOnStreamLimit
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Required PFR Activity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredPFRActivity
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Catalyst Activity Half-Life",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .catalystActivityHalfLife
                                                ),
                                            unit: "time"
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
                                                .limitingReactorDescription
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
        .navigationTitle("Catalyst Time-on-Stream")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    freshDamkohlerNumber:
                        try InputValidator.parseNumber(
                            damkohlerInput,
                            fieldName:
                                "fresh Damköhler number"
                        ),
                    deactivationRateConstant:
                        try InputValidator.parseNumber(
                            deactivationRateInput,
                            fieldName:
                                "deactivation rate constant"
                        ),
                    minimumAcceptableConversion:
                        try InputValidator.parseNumber(
                            minimumConversionInput,
                            fieldName:
                                "minimum acceptable conversion"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        damkohlerInput = "4"
        deactivationRateInput = "0.1"
        minimumConversionInput = "0.7"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        damkohlerInput = ""
        deactivationRateInput = ""
        minimumConversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CatalystTimeOnStreamView()
    }
}
