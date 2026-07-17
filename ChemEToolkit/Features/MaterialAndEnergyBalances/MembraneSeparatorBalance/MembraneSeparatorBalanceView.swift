import SwiftUI

struct MembraneSeparatorBalanceView:
    View {

    @State private var feedInput = "100"
    @State private var feedFractionInput = "0.10"
    @State private var stageCutInput = "0.20"
    @State private var rejectionInput = "0.90"

    @State private var result:
        MembraneSeparatorBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        MembraneSeparatorBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "rectangle.split.3x1",
                    title: "Membrane Separator Balance",
                    subtitle: "Calculate permeate and retentate component flows",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Stage cut determines permeate flow while observed rejection estimates permeate composition.")
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
                            title: "Feed Mass Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder: "100",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Feed Component Fraction",
                            symbol: "w_F",
                            unit: "—",
                            placeholder: "0.10",
                            text: $feedFractionInput
                        )

                        EngineeringInputField(
                            title: "Stage Cut",
                            symbol: "θ",
                            unit: "—",
                            placeholder: "0.20",
                            text: $stageCutInput
                        )

                        EngineeringInputField(
                            title: "Observed Rejection",
                            symbol: "R",
                            unit: "—",
                            placeholder: "0.90",
                            text: $rejectionInput
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
                            systemImage: "rectangle.split.3x1",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Permeate Flow",
                                        value: numberFormatter.format(result.permeateMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Retentate Flow",
                                        value: numberFormatter.format(result.retentateMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Permeate Component Fraction",
                                        value: numberFormatter.format(result.permeateComponentMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Retentate Component Fraction",
                                        value: numberFormatter.format(result.retentateComponentMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Permeate Component Flow",
                                        value: numberFormatter.format(result.permeateComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Component Recovery to Retentate",
                                        value: numberFormatter.format(100 * result.componentRecoveryToRetentate),
                                        unit: "%"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Membrane Separator Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedMassFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "feed mass flow"
                        ),
                    feedComponentMassFraction:
                        try InputValidator.parseNumber(
                            feedFractionInput,
                            fieldName:
                                "feed component fraction"
                        ),
                    stageCutFraction:
                        try InputValidator.parseNumber(
                            stageCutInput,
                            fieldName:
                                "stage cut"
                        ),
                    observedRejectionFraction:
                        try InputValidator.parseNumber(
                            rejectionInput,
                            fieldName:
                                "observed rejection"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "100"
        feedFractionInput = "0.10"
        stageCutInput = "0.20"
        rejectionInput = "0.90"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        feedFractionInput = ""
        stageCutInput = ""
        rejectionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MembraneSeparatorBalanceView()
    }
}
