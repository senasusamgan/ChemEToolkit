import SwiftUI

struct LiquidControlValveSizingView: View {
    @State private var flowInput = "50"
    @State private var pressureDropInput = "2"
    @State private var densityInput = "800"
    @State private var installedKvInput = "40"
    @State private var safetyInput = "1.2"

    @State private var result: LiquidControlValveSizingResult?
    @State private var errorMessage = ""

    private let engine = LiquidControlValveSizingEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.fill",
                    title: "Liquid Control Valve Sizing",
                    subtitle: "Calculate required Kv, equivalent Cv and installed-capacity margin",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Kv is the water flow in m³/h through a valve at a pressure drop of one bar.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Liquid Flow Rate",
                            symbol: "Q",
                            unit: "m³/h",
                            placeholder: "50",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Valve Pressure Drop",
                            symbol: "ΔP",
                            unit: "bar",
                            placeholder: "2",
                            text: $pressureDropInput
                        )

                        EngineeringInputField(
                            title: "Liquid Density",
                            symbol: "ρ",
                            unit: "kg/m³",
                            placeholder: "800",
                            text: $densityInput
                        )

                        EngineeringInputField(
                            title: "Installed Valve Kv",
                            symbol: "Kv_inst",
                            unit: "m³/h",
                            placeholder: "40",
                            text: $installedKvInput
                        )

                        EngineeringInputField(
                            title: "Design Safety Factor",
                            symbol: "S",
                            unit: "—",
                            placeholder: "1.2",
                            text: $safetyInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "drop.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Required Kv",
                                        value: numberFormatter.format(result.requiredKvWithoutMargin),
                                        unit: "m³/h"
                                    ),
.init(
                                        label: "Design Kv",
                                        value: numberFormatter.format(result.designKv),
                                        unit: "m³/h"
                                    ),
.init(
                                        label: "Equivalent Cv",
                                        value: numberFormatter.format(result.equivalentCv),
                                        unit: "US gpm/√psi"
                                    ),
.init(
                                        label: "Installed Capacity Used",
                                        value: numberFormatter.format(100 * result.installedCapacityFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Estimated Linear Opening",
                                        value: numberFormatter.format(100 * result.estimatedLinearOpening),
                                        unit: "%"
                                    ),
.init(
                                        label: "Installed Valve Adequate",
                                        value: result.installedValveIsAdequate ? "Yes" : "No",
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription).foregroundStyle(.secondary)
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
        .navigationTitle("Liquid Control Valve Sizing")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    liquidFlowRate: try InputValidator.parseNumber(flowInput, fieldName: "liquid flow rate"),
                    pressureDrop: try InputValidator.parseNumber(pressureDropInput, fieldName: "valve pressure drop"),
                    liquidDensity: try InputValidator.parseNumber(densityInput, fieldName: "liquid density"),
                    installedValveKv: try InputValidator.parseNumber(installedKvInput, fieldName: "installed valve Kv"),
                    designSafetyFactor: try InputValidator.parseNumber(safetyInput, fieldName: "design safety factor")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "50"
        pressureDropInput = "2"
        densityInput = "800"
        installedKvInput = "40"
        safetyInput = "1.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        pressureDropInput = ""
        densityInput = ""
        installedKvInput = ""
        safetyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { LiquidControlValveSizingView() } }
