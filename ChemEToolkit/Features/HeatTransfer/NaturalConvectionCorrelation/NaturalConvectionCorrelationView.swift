import SwiftUI

struct NaturalConvectionCorrelationView: View {

    @State
    private var geometry:
        NaturalConvectionGeometry =
            .verticalPlate

    @State private var rayleighInput = "100000000"
    @State private var prandtlInput = "0.7"
    @State private var conductivityInput = "0.026"
    @State private var lengthInput = "0.5"

    @State
    private var result:
        NaturalConvectionCorrelationResult?

    @State
    private var errorMessage = ""

    private let engine =
        NaturalConvectionCorrelationEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "wind.circle.fill",
                    title:
                        "Natural Convection Correlations",
                    subtitle:
                        "Estimate natural-convection Nusselt number and coefficient",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Churchill–Chu Correlations")
                            .font(.headline)

                        Text("h = Nu·k/L𝚌")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "Uses geometry-specific Churchill–Chu equations."
                        )
                        .foregroundStyle(.secondary)
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
            "Natural Convection Correlations"
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Picker(
                "Geometry",
                selection: $geometry
            ) {
                ForEach(
                    NaturalConvectionGeometry.allCases
                ) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            EngineeringInputField(
                title: "Rayleigh Number",
                symbol: "Ra",
                unit: "—",
                placeholder: "Example: 100000000",
                text: $rayleighInput
            )

            EngineeringInputField(
                title: "Prandtl Number",
                symbol: "Pr",
                unit: "—",
                placeholder: "Example: 0.7",
                text: $prandtlInput
            )

            EngineeringInputField(
                title: "Fluid Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 0.026",
                text: $conductivityInput
            )

            EngineeringInputField(
                title: "Characteristic Length",
                symbol: "L𝚌",
                unit: "m",
                placeholder: "Example: 0.5",
                text: $lengthInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Natural Convection",
                systemImage:
                    "wind.circle.fill",
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
                    NaturalConvectionCorrelationInput(
                        geometry: geometry,
                        rayleighNumber:
                            try InputValidator.parseNumber(
                                rayleighInput,
                                fieldName:
                                    "Rayleigh number"
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
        geometry = .verticalPlate
        rayleighInput = "100000000"
        prandtlInput = "0.7"
        conductivityInput = "0.026"
        lengthInput = "0.5"
        result = nil
        errorMessage = ""
    }

    private func clear() {
        rayleighInput = ""
        prandtlInput = ""
        conductivityInput = ""
        lengthInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NaturalConvectionCorrelationView()
    }
}
