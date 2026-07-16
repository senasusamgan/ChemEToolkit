import SwiftUI

struct BypassFractionEstimatorView:
    View {

    @State private var inletTracerInput =
        "1"

    @State private var outletTracerInput =
        "0.15"

    @State private var flowRateInput =
        "10"

    @State private var result:
        BypassFractionEstimatorResult?

    @State private var errorMessage = ""

    private let engine =
        BypassFractionEstimatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.branch",
                    title:
                        "Bypass Fraction Estimator",
                    subtitle:
                        "Estimate immediate bypass from a step-tracer outlet jump",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Immediate Step Response")
                            .font(.headline)

                        Text(
                            "b = C_out(0⁺)/C_in"
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Use the outlet concentration measured immediately after the inlet tracer step."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
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
                            title:
                                "Inlet Tracer Concentration",
                            symbol: "C_in",
                            unit: "tracer units",
                            placeholder: "1",
                            text: $inletTracerInput
                        )

                        EngineeringInputField(
                            title:
                                "Immediate Outlet Concentration",
                            symbol: "C_out(0⁺)",
                            unit: "tracer units",
                            placeholder: "0.15",
                            text:
                                $outletTracerInput
                        )

                        EngineeringInputField(
                            title:
                                "Total Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "10",
                            text: $flowRateInput
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
                            title:
                                "Estimate Bypass",
                            systemImage:
                                "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Bypass Fraction",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .bypassFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Reactor-Path Fraction",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .reactorPathFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Bypass Flow Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .bypassFlowRate
                                                ),
                                            unit: "m³/time"
                                        ),
                                        .init(
                                            label:
                                                "Reactor-Path Flow Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .reactorPathFlowRate
                                                ),
                                            unit: "m³/time"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(
                                            result
                                                .interpretationDescription
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)

                                        Text(
                                            result
                                                .limitationDescription
                                        )
                                        .foregroundStyle(.secondary)
                                    }
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
        .navigationTitle("Bypass Fraction")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletTracerConcentration:
                        try InputValidator.parseNumber(
                            inletTracerInput,
                            fieldName:
                                "inlet tracer concentration"
                        ),
                    immediateOutletTracerConcentration:
                        try InputValidator.parseNumber(
                            outletTracerInput,
                            fieldName:
                                "immediate outlet tracer concentration"
                        ),
                    totalVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowRateInput,
                            fieldName:
                                "total volumetric flow rate"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        inletTracerInput = "1"
        outletTracerInput = "0.15"
        flowRateInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        inletTracerInput = ""
        outletTracerInput = ""
        flowRateInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BypassFractionEstimatorView()
    }
}
