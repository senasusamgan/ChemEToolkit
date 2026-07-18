import SwiftUI

    struct MurphreeTrayEfficiencyView: View {
        @State private var idealInput = "12"

    @State private var efficiencyInput = "0.65"

    @State private var spacingInput = "0.6"

    @State private var safetyInput = "1.10"

        @State private var result: MurphreeTrayEfficiencyResult?
        @State private var errorMessage = ""

        private let engine = MurphreeTrayEfficiencyEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "square.stack.3d.down.forward.fill",
                        title: "Murphree Tray Efficiency",
                        subtitle: "Convert ideal stages into actual tray count",
                        tint: .purple
                    )

                    CalculatorInfoCard(tint: .purple) {
                        Text("Use a consistent engineering unit system across all entered quantities.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Ideal Stage Count",
                        symbol: "N_ideal",
                        unit: "stages",
                        placeholder: "12",
                        text: $idealInput
                    )

                    EngineeringInputField(
                        title: "Murphree Efficiency",
                        symbol: "E_M",
                        unit: "—",
                        placeholder: "0.65",
                        text: $efficiencyInput
                    )

                    EngineeringInputField(
                        title: "Tray Spacing",
                        symbol: "s",
                        unit: "m",
                        placeholder: "0.6",
                        text: $spacingInput
                    )

                    EngineeringInputField(
                        title: "Height Safety Factor",
                        symbol: "SF",
                        unit: "—",
                        placeholder: "1.10",
                        text: $safetyInput
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
                                systemImage: "square.stack.3d.down.forward.fill",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Continuous Actual Stages",
                                value: numberFormatter.format(result.continuousActualStageCount),
                                unit: "stages"
                            ),
.init(
                                label: "Required Actual Trays",
                                value: numberFormatter.format(Double(result.requiredActualTrays)),
                                unit: "trays"
                            ),
.init(
                                label: "Active Tray Height",
                                value: numberFormatter.format(result.activeTrayHeight),
                                unit: "m"
                            ),
.init(
                                label: "Design Tray-Section Height",
                                value: numberFormatter.format(result.designTraySectionHeight),
                                unit: "m"
                            ),
.init(
                                label: "Stage Penalty",
                                value: numberFormatter.format(result.stagePenalty),
                                unit: "stages"
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
            .navigationTitle("Murphree Tray Efficiency")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            idealStageCount: try InputValidator.parseNumber(
                            idealInput,
                            fieldName: "ideal stage count"
                        ),
                        murphreeEfficiency: try InputValidator.parseNumber(
                            efficiencyInput,
                            fieldName: "murphree efficiency"
                        ),
                        traySpacing: try InputValidator.parseNumber(
                            spacingInput,
                            fieldName: "tray spacing"
                        ),
                        columnHeightSafetyFactor: try InputValidator.parseNumber(
                            safetyInput,
                            fieldName: "height safety factor"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            idealInput = ""
        efficiencyInput = ""
        spacingInput = ""
        safetyInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { MurphreeTrayEfficiencyView() }
    }
