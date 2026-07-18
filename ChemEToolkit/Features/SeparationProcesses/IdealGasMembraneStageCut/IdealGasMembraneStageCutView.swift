import SwiftUI

struct IdealGasMembraneStageCutView: View {

    @State private var feedFlowInput = "100"

    @State private var feedFractionInput = "0.20"

    @State private var stageCutInput = "0.30"

    @State private var selectivityInput = "5"

    @State private var result: IdealGasMembraneStageCutResult?
    @State private var errorMessage = ""

    private let engine = IdealGasMembraneStageCutEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "rectangle.split.2x1.fill",
                    title: "Ideal Gas-Membrane Stage Cut",
                    subtitle: "Estimate binary permeate and retentate streams",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Assumes a binary ideal membrane with constant selectivity.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Feed Molar Flow",
                        symbol: "F",
                        unit: "kmol/h",
                        placeholder: "100",
                        text: $feedFlowInput
                    )

                    EngineeringInputField(
                        title: "Fast-Component Feed Fraction",
                        symbol: "zF",
                        unit: "—",
                        placeholder: "0.20",
                        text: $feedFractionInput
                    )

                    EngineeringInputField(
                        title: "Stage Cut",
                        symbol: "theta",
                        unit: "—",
                        placeholder: "0.30",
                        text: $stageCutInput
                    )

                    EngineeringInputField(
                        title: "Ideal Selectivity",
                        symbol: "alpha",
                        unit: "—",
                        placeholder: "5",
                        text: $selectivityInput
                    )

                        HStack {
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "rectangle.split.2x1.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Permeate Flow",
                                value: numberFormatter.format(result.permeateMolarFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Retentate Flow",
                                value: numberFormatter.format(result.retentateMolarFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Permeate Fast Fraction",
                                value: numberFormatter.format(result.permeateFastComponentFraction),
                                unit: "—"
                            ),
.init(
                                label: "Retentate Fast Fraction",
                                value: numberFormatter.format(result.retentateFastComponentFraction),
                                unit: "—"
                            ),
.init(
                                label: "Fast-Component Recovery",
                                value: numberFormatter.format(100 * result.fastComponentRecovery),
                                unit: "%"
                            ),
.init(
                                label: "Enrichment Factor",
                                value: numberFormatter.format(result.enrichmentFactor),
                                unit: "—"
                            )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription)
                                        .foregroundStyle(.secondary)
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
        .navigationTitle("Ideal Gas-Membrane Stage Cut")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        feedMolarFlow:
                            try InputValidator.parseNumber(
                                feedFlowInput,
                                fieldName: "feed molar flow"
                            ),
                        feedFastComponentFraction:
                            try InputValidator.parseNumber(
                                feedFractionInput,
                                fieldName: "fast-component feed fraction"
                            ),
                        stageCut:
                            try InputValidator.parseNumber(
                                stageCutInput,
                                fieldName: "stage cut"
                            ),
                        idealSelectivity:
                            try InputValidator.parseNumber(
                                selectivityInput,
                                fieldName: "ideal selectivity"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        feedFlowInput = ""
        feedFractionInput = ""
        stageCutInput = ""
        selectivityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { IdealGasMembraneStageCutView() }
}
