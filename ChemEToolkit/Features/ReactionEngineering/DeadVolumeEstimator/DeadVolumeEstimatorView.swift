import SwiftUI

struct DeadVolumeEstimatorView:
    View {

    @State private var nominalVolumeInput =
        "10"

    @State private var flowRateInput =
        "1"

    @State private var meanTimeInput =
        "8"

    @State private var result:
        DeadVolumeEstimatorResult?

    @State private var errorMessage = ""

    private let engine =
        DeadVolumeEstimatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "cube.transparent.fill",
                    title:
                        "Dead Volume Estimator",
                    subtitle:
                        "Estimate inaccessible reactor volume from the measured mean residence time",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Active-Volume Estimate")
                            .font(.headline)

                        Text("V_active = Q·t̄")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The model is valid only when the measured mean time does not exceed the nominal space time."
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
                                "Nominal Reactor Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "10",
                            text:
                                $nominalVolumeInput
                        )

                        EngineeringInputField(
                            title:
                                "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "1",
                            text: $flowRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Measured Mean Residence Time",
                            symbol: "t̄",
                            unit: "time",
                            placeholder: "8",
                            text: $meanTimeInput
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
                                "Estimate Dead Volume",
                            systemImage:
                                "cube.transparent.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Nominal Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .nominalSpaceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Active Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .activeVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Dead Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .deadVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Active Volume Fraction",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .activeVolumeFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Dead Volume Fraction",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .deadVolumeFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Measured / Nominal Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .residenceTimeRatio
                                                ),
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
        .navigationTitle("Dead Volume")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    nominalReactorVolume:
                        try InputValidator.parseNumber(
                            nominalVolumeInput,
                            fieldName:
                                "nominal reactor volume"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowRateInput,
                            fieldName:
                                "volumetric flow rate"
                        ),
                    measuredMeanResidenceTime:
                        try InputValidator.parseNumber(
                            meanTimeInput,
                            fieldName:
                                "measured mean residence time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        nominalVolumeInput = "10"
        flowRateInput = "1"
        meanTimeInput = "8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        nominalVolumeInput = ""
        flowRateInput = ""
        meanTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DeadVolumeEstimatorView()
    }
}
