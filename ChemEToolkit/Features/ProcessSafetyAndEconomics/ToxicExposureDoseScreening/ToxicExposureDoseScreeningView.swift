import SwiftUI

struct ToxicExposureDoseScreeningView:
    View {

    @State private var concentrationInput = "500"
    @State private var durationInput = "30"
    @State private var exponentInput = "2"
    @State private var referenceDoseInput = "10000000"

    @State private var result:
        ToxicExposureDoseScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        ToxicExposureDoseScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "lungs.fill",
                    title: "Toxic Exposure Dose",
                    subtitle: "Compare concentration-time dose with an entered reference",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use a chemical-specific concentration exponent and reference dose from an appropriate authoritative source.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
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
                            title: "Exposure Concentration",
                            symbol: "C",
                            unit: "consistent concentration units",
                            placeholder: "500",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Exposure Duration",
                            symbol: "t",
                            unit: "min",
                            placeholder: "30",
                            text: $durationInput
                        )

                        EngineeringInputField(
                            title: "Concentration Exponent",
                            symbol: "n",
                            unit: "—",
                            placeholder: "2",
                            text: $exponentInput
                        )

                        EngineeringInputField(
                            title: "Reference Dose",
                            symbol: "D_ref",
                            unit: "Cⁿ·min",
                            placeholder: "10000000",
                            text: $referenceDoseInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
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
                            systemImage: "lungs.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Calculated Dose",
                                        value: numberFormatter.format(result.calculatedDose),
                                        unit: "Cⁿ·min"
                                    ),
.init(
                                        label: "Dose Ratio",
                                        value: numberFormatter.format(result.doseRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Maximum Duration",
                                        value: numberFormatter.format(result.maximumDurationAtCurrentConcentration),
                                        unit: "min"
                                    ),
.init(
                                        label: "Maximum Concentration",
                                        value: numberFormatter.format(result.maximumConcentrationAtCurrentDuration),
                                        unit: "input concentration units"
                                    ),
.init(
                                        label: "Reference Exceeded",
                                        value: result.targetExceeded ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Exposure Band",
                                        value: result.exposureBand,
                                        unit: "—"
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

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
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
        .navigationTitle("Toxic Exposure Dose")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    exposureConcentration:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName:
                                "exposure concentration"
                        ),
                    exposureDuration:
                        try InputValidator.parseNumber(
                            durationInput,
                            fieldName:
                                "exposure duration"
                        ),
                    concentrationExponent:
                        try InputValidator.parseNumber(
                            exponentInput,
                            fieldName:
                                "concentration exponent"
                        ),
                    referenceDose:
                        try InputValidator.parseNumber(
                            referenceDoseInput,
                            fieldName:
                                "reference dose"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "500"
        durationInput = "30"
        exponentInput = "2"
        referenceDoseInput = "10000000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        durationInput = ""
        exponentInput = ""
        referenceDoseInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ToxicExposureDoseScreeningView()
    }
}
