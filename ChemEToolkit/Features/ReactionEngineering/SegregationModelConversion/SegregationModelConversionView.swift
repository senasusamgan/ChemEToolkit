import Foundation
import SwiftUI

struct SegregationModelConversionView:
    View {

    @State private var concentrationInput =
        "1"

    @State private var rateConstantInput =
        "0.2"

    @State private var reactionOrderInput =
        "2"

    @State private var timesInput =
        "0, 2, 4, 6, 8"

    @State private var eValuesInput =
        "0, 0.1, 0.3, 0.1, 0"

    @State private var result:
        SegregationModelConversionResult?

    @State private var errorMessage = ""

    private let engine =
        SegregationModelConversionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "circle.grid.cross.fill",
                    title:
                        "Segregation Model Conversion",
                    subtitle:
                        "Predict nonideal-reactor conversion for general-order power-law kinetics",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Complete Segregation")
                            .font(.headline)

                        Text(
                            "C_A,out = ∫C_A,batch(t)E(t)dt"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Reaction order is restricted to the validated range 0 through 3."
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
                                "Initial Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "1",
                            text:
                                $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant",
                            symbol: "k",
                            unit:
                                "consistent power-law units",
                            placeholder: "0.2",
                            text:
                                $rateConstantInput
                        )

                        EngineeringInputField(
                            title: "Reaction Order",
                            symbol: "n",
                            unit: "—",
                            placeholder: "2",
                            text:
                                $reactionOrderInput
                        )

                        EngineeringInputField(
                            title: "Times",
                            symbol: "t",
                            unit: "comma-separated",
                            placeholder:
                                "0, 2, 4, 6, 8",
                            text: $timesInput
                        )

                        EngineeringInputField(
                            title: "E Values",
                            symbol: "E(t)",
                            unit: "comma-separated",
                            placeholder:
                                "0, 0.1, 0.3, 0.1, 0",
                            text: $eValuesInput
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
                                "Calculate Segregation Conversion",
                            systemImage:
                                "circle.grid.cross.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Segregation Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Mean Residence Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .meanResidenceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Equivalent PFR Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .equivalentPFRConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Difference from PFR",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionDifferenceFromPFR
                                                ),
                                            unit:
                                                "percentage points"
                                        ),
                                        .init(
                                            label:
                                                "RTD Area Before Normalization",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .rawRTDArea
                                                ),
                                            unit: "—"
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
        .navigationTitle("Segregation Model")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName:
                                "initial concentration A"
                        ),
                    rateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "rate constant"
                        ),
                    reactionOrder:
                        try InputValidator.parseNumber(
                            reactionOrderInput,
                            fieldName:
                                "reaction order"
                        ),
                    times:
                        try parseList(
                            timesInput,
                            fieldName: "times"
                        ),
                    eValues:
                        try parseList(
                            eValuesInput,
                            fieldName:
                                "E values"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "1"
        rateConstantInput = "0.2"
        reactionOrderInput = "2"
        timesInput =
            "0, 2, 4, 6, 8"
        eValuesInput =
            "0, 0.1, 0.3, 0.1, 0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        rateConstantInput = ""
        reactionOrderInput = ""
        timesInput = ""
        eValuesInput = ""
        result = nil
        errorMessage = ""
    }


    private func parseList(
        _ text: String,
        fieldName: String
    ) throws -> [Double] {
        try text
            .split(separator: ",")
            .map {
                try InputValidator.parseNumber(
                    String($0)
                        .trimmingCharacters(
                            in: .whitespaces
                        ),
                    fieldName: fieldName
                )
            }
    }

}

#Preview {
    NavigationStack {
        SegregationModelConversionView()
    }
}
