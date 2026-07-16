import SwiftUI

struct OverrideSelectiveControlView:
    View {

    @State private var selectorMode:
        OverrideSelectorMode =
            .lowSelect

    @State private var primaryOutputInput =
        "70"

    @State private var constraintOutputInput =
        "55"

    @State private var minimumInput =
        "0"

    @State private var maximumInput =
        "100"

    @State private var result:
        OverrideSelectiveControlResult?

    @State private var errorMessage = ""

    private let engine =
        OverrideSelectiveControlEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.up.arrow.down.circle.fill",
                    title:
                        "Override / Selective Control",
                    subtitle:
                        "Select the protective or primary controller output",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text(
                        "A selector transfers the final manipulated signal to whichever controller must dominate under the selected high- or low-select logic."
                    )
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
                        VStack(
                            alignment: .leading,
                            spacing: AppSpacing.small
                        ) {
                            Text("Selector Mode")
                                .font(.headline)

                            Picker(
                                "Selector Mode",
                                selection: $selectorMode
                            ) {
                                ForEach(
                                    OverrideSelectorMode
                                        .allCases
                                ) { mode in
                                    Text(mode.title)
                                        .tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        EngineeringInputField(
                            title:
                                "Primary Controller Output",
                            symbol: "u_primary",
                            unit: "%",
                            placeholder: "70",
                            text:
                                $primaryOutputInput
                        )

                        EngineeringInputField(
                            title:
                                "Constraint Controller Output",
                            symbol: "u_constraint",
                            unit: "%",
                            placeholder: "55",
                            text:
                                $constraintOutputInput
                        )

                        EngineeringInputField(
                            title:
                                "Minimum Final Output",
                            symbol: "u_min",
                            unit: "%",
                            placeholder: "0",
                            text:
                                $minimumInput
                        )

                        EngineeringInputField(
                            title:
                                "Maximum Final Output",
                            symbol: "u_max",
                            unit: "%",
                            placeholder: "100",
                            text:
                                $maximumInput
                        )

                        HStack(
                            spacing: AppSpacing.medium
                        ) {
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
                            title:
                                "Select Controller Output",
                            systemImage:
                                "arrow.up.arrow.down.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label:
                                            "Selected Raw Output",
                                        value:
                                            numberFormatter.format(
                                                result
                                                    .selectedRawOutput
                                            ),
                                        unit: "%"
                                    ),
                                    .init(
                                        label:
                                            "Final Output",
                                        value:
                                            numberFormatter.format(
                                                result.finalOutput
                                            ),
                                        unit: "%"
                                    ),
                                    .init(
                                        label:
                                            "Selected Controller",
                                        value:
                                            result
                                                .selectedControllerDescription,
                                        unit: "—"
                                    ),
                                    .init(
                                        label:
                                            "Constraint Override",
                                        value:
                                            result.constraintHasOverride
                                            ? "Active"
                                            : "Inactive",
                                        unit: "—"
                                    ),
                                    .init(
                                        label:
                                            "Controller Separation",
                                        value:
                                            numberFormatter.format(
                                                result
                                                    .controllerSeparation
                                            ),
                                        unit: "%"
                                    ),
                                    .init(
                                        label:
                                            "Final Limit Active",
                                        value:
                                            result.finalOutputWasLimited
                                            ? "Yes"
                                            : "No",
                                        unit: "—"
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
        .navigationTitle(
            "Override / Selective Control"
        )
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    selectorMode:
                        selectorMode,
                    primaryControllerOutput:
                        try InputValidator
                            .parseNumber(
                                primaryOutputInput,
                                fieldName:
                                    "primary controller output"
                            ),
                    constraintControllerOutput:
                        try InputValidator
                            .parseNumber(
                                constraintOutputInput,
                                fieldName:
                                    "constraint controller output"
                            ),
                    minimumFinalOutput:
                        try InputValidator
                            .parseNumber(
                                minimumInput,
                                fieldName:
                                    "minimum final output"
                            ),
                    maximumFinalOutput:
                        try InputValidator
                            .parseNumber(
                                maximumInput,
                                fieldName:
                                    "maximum final output"
                            )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        selectorMode = .lowSelect
        primaryOutputInput = "70"
        constraintOutputInput = "55"
        minimumInput = "0"
        maximumInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        primaryOutputInput = ""
        constraintOutputInput = ""
        minimumInput = ""
        maximumInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        OverrideSelectiveControlView()
    }
}
