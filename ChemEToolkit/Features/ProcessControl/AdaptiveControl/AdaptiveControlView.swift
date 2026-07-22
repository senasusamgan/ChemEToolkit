import SwiftUI

struct AdaptiveControlView:
    View {

    @State private var currentGainInput = "2"
    @State private var referenceInput = "10"
    @State private var measuredInput = "8"
    @State private var sensitivityInput = "0.5"
    @State private var adaptationInput = "0.2"
    @State private var sampleTimeInput = "1"
    @State private var minimumGainInput = "0"
    @State private var maximumGainInput = "5"

    @State private var result:
        AdaptiveControlResult?

    @State private var errorMessage = ""

    private let engine =
        AdaptiveControlEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.2.circlepath",
                    title: "Adaptive Control",
                    subtitle: "Apply a constrained gradient update to the controller gain",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Adaptive control updates controller parameters online as process behavior or operating conditions change.")
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
                            title: "Current Controller Gain",
                            symbol: "Kc",
                            unit: "—",
                            placeholder: "2",
                            text: $currentGainInput
                        )

                        EngineeringInputField(
                            title: "Reference Output",
                            symbol: "r",
                            unit: "output units",
                            placeholder: "10",
                            text: $referenceInput
                        )

                        EngineeringInputField(
                            title: "Measured Output",
                            symbol: "y",
                            unit: "output units",
                            placeholder: "8",
                            text: $measuredInput
                        )

                        EngineeringInputField(
                            title: "Model Output Sensitivity",
                            symbol: "∂y/∂Kc",
                            unit: "output/gain",
                            placeholder: "0.5",
                            text: $sensitivityInput
                        )

                        EngineeringInputField(
                            title: "Adaptation Rate",
                            symbol: "γ",
                            unit: "1/(output²·time)",
                            placeholder: "0.2",
                            text: $adaptationInput
                        )

                        EngineeringInputField(
                            title: "Sample Time",
                            symbol: "Δt",
                            unit: "time",
                            placeholder: "1",
                            text: $sampleTimeInput
                        )

                        EngineeringInputField(
                            title: "Minimum Controller Gain",
                            symbol: "Kc_min",
                            unit: "—",
                            placeholder: "0",
                            text: $minimumGainInput
                        )

                        EngineeringInputField(
                            title: "Maximum Controller Gain",
                            symbol: "Kc_max",
                            unit: "—",
                            placeholder: "5",
                            text: $maximumGainInput
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
                            systemImage: "arrow.triangle.2.circlepath",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Tracking Error",
                                        value: numberFormatter.format(result.trackingError),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Requested Gain Update",
                                        value: numberFormatter.format(result.requestedGainUpdate),
                                        unit: "gain units"
                                    ),
.init(
                                        label: "Applied Gain Update",
                                        value: numberFormatter.format(result.appliedGainUpdate),
                                        unit: "gain units"
                                    ),
.init(
                                        label: "Updated Controller Gain",
                                        value: numberFormatter.format(result.updatedControllerGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Predicted Tracking Error",
                                        value: numberFormatter.format(result.predictedTrackingError),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Predicted Cost Improvement",
                                        value: numberFormatter.format(100 * result.predictedImprovementFraction),
                                        unit: "%"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Adaptive Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    currentControllerGain:
                        try InputValidator.parseNumber(
                            currentGainInput,
                            fieldName:
                                "current controller gain"
                        ),
                    referenceOutput:
                        try InputValidator.parseNumber(
                            referenceInput,
                            fieldName:
                                "reference output"
                        ),
                    measuredOutput:
                        try InputValidator.parseNumber(
                            measuredInput,
                            fieldName:
                                "measured output"
                        ),
                    modelOutputSensitivity:
                        try InputValidator.parseNumber(
                            sensitivityInput,
                            fieldName:
                                "model output sensitivity"
                        ),
                    adaptationRate:
                        try InputValidator.parseNumber(
                            adaptationInput,
                            fieldName:
                                "adaptation rate"
                        ),
                    sampleTime:
                        try InputValidator.parseNumber(
                            sampleTimeInput,
                            fieldName:
                                "sample time"
                        ),
                    minimumControllerGain:
                        try InputValidator.parseNumber(
                            minimumGainInput,
                            fieldName:
                                "minimum controller gain"
                        ),
                    maximumControllerGain:
                        try InputValidator.parseNumber(
                            maximumGainInput,
                            fieldName:
                                "maximum controller gain"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        currentGainInput = "2"
        referenceInput = "10"
        measuredInput = "8"
        sensitivityInput = "0.5"
        adaptationInput = "0.2"
        sampleTimeInput = "1"
        minimumGainInput = "0"
        maximumGainInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        currentGainInput = ""
        referenceInput = ""
        measuredInput = ""
        sensitivityInput = ""
        adaptationInput = ""
        sampleTimeInput = ""
        minimumGainInput = ""
        maximumGainInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AdaptiveControlView()
    }
}
