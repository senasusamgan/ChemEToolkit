import SwiftUI

struct ForcedConvectionCorrelationView: View {

    @State
    private var geometry:
        ForcedConvectionGeometry =
            .internalCircularTube

    @State private var reynoldsInput = "50000"
    @State private var prandtlInput = "7"
    @State private var conductivityInput = "0.6"
    @State private var lengthInput = "0.02"

    @State
    private var result:
        ForcedConvectionCorrelationResult?

    @State
    private var errorMessage = ""

    private let engine =
        ForcedConvectionCorrelationEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title:
                        "Forced Convection Correlations",
                    subtitle:
                        "Estimate Nusselt number and heat-transfer coefficient",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Correlation-Based Convection")
                            .font(.headline)

                        Text("h = Nu·k/L𝚌")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The engine selects a supported correlation from geometry and Reynolds-number range."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }

                CalculatorCard {
                    calculatorContent
                }
            }
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle(
            "Forced Convection Correlations"
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Geometry")
                .font(.headline)

            Picker(
                "Geometry",
                selection: $geometry
            ) {
                ForEach(
                    ForcedConvectionGeometry.allCases
                ) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            EngineeringInputField(
                title: "Reynolds Number",
                symbol: "Re",
                unit: "—",
                placeholder: "Example: 50000",
                text: $reynoldsInput
            )

            EngineeringInputField(
                title: "Prandtl Number",
                symbol: "Pr",
                unit: "—",
                placeholder: "Example: 7",
                text: $prandtlInput
            )

            EngineeringInputField(
                title: "Fluid Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 0.6",
                text: $conductivityInput
            )

            EngineeringInputField(
                title: "Characteristic Length",
                symbol: "L𝚌",
                unit: "m",
                placeholder: "Example: 0.02",
                text: $lengthInput
            )

            actionButtons

            PrimaryActionButton(
                title: "Calculate Forced Convection",
                systemImage: "wind",
                action: calculate
            )

            if let result {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label: "Nusselt Number",
                            value:
                                formatter.format(
                                    result.nusseltNumber
                                ),
                            unit: "—"
                        ),
                        CalculationResultDisplayItem(
                            label:
                                "Heat-Transfer Coefficient",
                            value:
                                formatter.format(
                                    result
                                        .heatTransferCoefficient
                                ),
                            unit: "W/(m²·K)"
                        )
                    ],
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    HStack {
                        Text("Correlation")
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(
                            result
                                .correlationUsed
                                .title
                        )
                        .fontWeight(.semibold)
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

    private var actionButtons: some View {
        HStack(spacing: AppSpacing.small) {
            Button(action: loadExample) {
                Label(
                    "Load Example",
                    systemImage: "doc.text"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button(action: clear) {
                Label(
                    "Clear",
                    systemImage:
                        "arrow.counterclockwise"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                input:
                    ForcedConvectionCorrelationInput(
                        geometry: geometry,
                        reynoldsNumber:
                            try InputValidator.parseNumber(
                                reynoldsInput,
                                fieldName:
                                    "Reynolds number"
                            ),
                        prandtlNumber:
                            try InputValidator.parseNumber(
                                prandtlInput,
                                fieldName:
                                    "Prandtl number"
                            ),
                        fluidThermalConductivity:
                            try InputValidator.parseNumber(
                                conductivityInput,
                                fieldName:
                                    "fluid thermal conductivity"
                            ),
                        characteristicLength:
                            try InputValidator.parseNumber(
                                lengthInput,
                                fieldName:
                                    "characteristic length"
                            )
                    )
            )
        } catch let error as CalculationError {
            errorMessage =
                error.errorDescription
                ?? "Invalid input."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        geometry = .internalCircularTube
        reynoldsInput = "50000"
        prandtlInput = "7"
        conductivityInput = "0.6"
        lengthInput = "0.02"
        result = nil
        errorMessage = ""
    }

    private func clear() {
        reynoldsInput = ""
        prandtlInput = ""
        conductivityInput = ""
        lengthInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ForcedConvectionCorrelationView()
    }
}
