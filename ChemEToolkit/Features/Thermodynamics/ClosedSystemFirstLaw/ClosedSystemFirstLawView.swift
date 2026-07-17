import SwiftUI

struct ClosedSystemFirstLawView: View {
    @State private var heatInput = "500"
    @State private var workInput = "120"
    @State private var kineticInput = "20"
    @State private var potentialInput = "10"
    @State private var result: ClosedSystemFirstLawResult?
    @State private var errorMessage = ""

    private let engine = ClosedSystemFirstLawEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.left.arrow.right.circle.fill",
                    title: "Closed-System First Law",
                    subtitle: "Calculate internal-energy change from energy transfers",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use the sign convention Q into the system and W by the system.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Heat to System",
                            symbol: "Q",
                            unit: "kJ",
                            placeholder: "500",
                            text: $heatInput
                        )

                        EngineeringInputField(
                            title: "Work by System",
                            symbol: "W",
                            unit: "kJ",
                            placeholder: "120",
                            text: $workInput
                        )

                        EngineeringInputField(
                            title: "Kinetic-Energy Change",
                            symbol: "ΔKE",
                            unit: "kJ",
                            placeholder: "20",
                            text: $kineticInput
                        )

                        EngineeringInputField(
                            title: "Potential-Energy Change",
                            symbol: "ΔPE",
                            unit: "kJ",
                            placeholder: "10",
                            text: $potentialInput
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
                            systemImage: "arrow.left.arrow.right.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Net Energy Transfer, Q − W",
                                        value: numberFormatter.format(result.netEnergyTransfer),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Internal-Energy Change",
                                        value: numberFormatter.format(result.internalEnergyChange),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Mechanical-Energy Change",
                                        value: numberFormatter.format(result.mechanicalEnergyChange),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Total Stored-Energy Change",
                                        value: numberFormatter.format(result.totalStoredEnergyChange),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Direction",
                                        value: result.directionDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Closed-System First Law")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    heatToSystem:
                        try InputValidator.parseNumber(
                            heatInput,
                            fieldName: "heat to system"
                        ),
                    workBySystem:
                        try InputValidator.parseNumber(
                            workInput,
                            fieldName: "work by system"
                        ),
                    kineticEnergyChange:
                        try InputValidator.parseNumber(
                            kineticInput,
                            fieldName: "kinetic-energy change"
                        ),
                    potentialEnergyChange:
                        try InputValidator.parseNumber(
                            potentialInput,
                            fieldName: "potential-energy change"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        heatInput = "500"
        workInput = "120"
        kineticInput = "20"
        potentialInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        heatInput = ""
        workInput = ""
        kineticInput = ""
        potentialInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ClosedSystemFirstLawView() } }
