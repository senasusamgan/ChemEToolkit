import SwiftUI

struct MembraneReactorView:
    View {

    @State private var aInput = "1"
    @State private var bInput = "0"
    @State private var forwardInput = "1"
    @State private var reverseInput = "0.5"
    @State private var removalInput = "1"
    @State private var timeInput = "2"
    @State private var result:
        MembraneReactorResult?

    @State private var errorMessage = ""

    private let engine =
        MembraneReactorEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "rectangle.split.3x1.fill",
                    title: "Membrane Reactor",
                    subtitle: "Evaluate reversible reaction enhancement by selective product removal",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Selective removal of product B can shift a reversible reaction beyond its no-membrane conversion.")
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
                            title: "Inlet Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "1",
                            text: $aInput
                        )

                        EngineeringInputField(
                            title: "Inlet Concentration B",
                            symbol: "C_B0",
                            unit: "mol/m³",
                            placeholder: "0",
                            text: $bInput
                        )

                        EngineeringInputField(
                            title: "Forward Rate Constant",
                            symbol: "k_f",
                            unit: "1/time",
                            placeholder: "1",
                            text: $forwardInput
                        )

                        EngineeringInputField(
                            title: "Reverse Rate Constant",
                            symbol: "k_r",
                            unit: "1/time",
                            placeholder: "0.5",
                            text: $reverseInput
                        )

                        EngineeringInputField(
                            title: "Membrane Removal Constant",
                            symbol: "k_m",
                            unit: "1/time",
                            placeholder: "1",
                            text: $removalInput
                        )

                        EngineeringInputField(
                            title: "Space Time",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "2",
                            text: $timeInput
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
                            title: "Calculate",
                            systemImage: "rectangle.split.3x1.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Outlet A",
                                        value: formatter.format(result.outletConcentrationA),
                                        unit: "mol/m³"
                                    ),
.init(
                                        label: "Outlet B",
                                        value: formatter.format(result.outletConcentrationB),
                                        unit: "mol/m³"
                                    ),
.init(
                                        label: "Removed B",
                                        value: formatter.format(result.removedProductEquivalent),
                                        unit: "mol/m³ equivalent"
                                    ),
.init(
                                        label: "Conversion of A",
                                        value: formatter.format(100 * result.conversionOfA),
                                        unit: "%"
                                    ),
.init(
                                        label: "No-Membrane Conversion",
                                        value: formatter.format(100 * result.conversionWithoutMembrane),
                                        unit: "%"
                                    ),
.init(
                                        label: "Membrane Gain",
                                        value: formatter.format(100 * result.membraneConversionGain),
                                        unit: "percentage points"
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
        .navigationTitle("Membrane Reactor")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletConcentrationA: try InputValidator.parseNumber(aInput, fieldName: "inlet concentration A"),
                    inletConcentrationB: try InputValidator.parseNumber(bInput, fieldName: "inlet concentration B"),
                    forwardRateConstant: try InputValidator.parseNumber(forwardInput, fieldName: "forward rate constant"),
                    reverseRateConstant: try InputValidator.parseNumber(reverseInput, fieldName: "reverse rate constant"),
                    membraneRemovalConstant: try InputValidator.parseNumber(removalInput, fieldName: "membrane removal constant"),
                    spaceTime: try InputValidator.parseNumber(timeInput, fieldName: "space time")
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        aInput = "1"
        bInput = "0"
        forwardInput = "1"
        reverseInput = "0.5"
        removalInput = "1"
        timeInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        aInput = ""
        bInput = ""
        forwardInput = ""
        reverseInput = ""
        removalInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MembraneReactorView()
    }
}
