import SwiftUI

struct FicksSecondLawView: View {
    @State private var initialConcentrationInput = "1"
    @State private var surfaceConcentrationInput = "0"
    @State private var diffusivityInput = "0.000000001"
    @State private var depthInput = "0.001"
    @State private var timeInput = "3600"

    @State private var result:
        FicksSecondLawResult?

    @State private var errorMessage = ""

    private let engine =
        FicksSecondLawEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path.ecg.rectangle",
                    title: "Fick’s Second Law",
                    subtitle:
                        "Solve transient diffusion into or out of a semi-infinite medium",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Semi-Infinite Transient Solution")
                            .font(.headline)

                        Text(
                            "(C − Cs)/(Ci − Cs) = erf[x/(2√Dt)]"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                        .minimumScaleFactor(0.45)
                        .multilineTextAlignment(.center)

                        Text(
                            "The surface concentration changes instantaneously at t = 0 and remains constant."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout.calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("Concentrations")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Initial Concentration",
                            symbol: "Ci",
                            unit: "mol/m³",
                            placeholder: "Example: 1",
                            text: $initialConcentrationInput
                        )

                        EngineeringInputField(
                            title: "Surface Concentration",
                            symbol: "Cs",
                            unit: "mol/m³",
                            placeholder: "Example: 0",
                            text: $surfaceConcentrationInput
                        )

                        Divider()

                        Text("Diffusion Conditions")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Diffusivity",
                            symbol: "D",
                            unit: "m²/s",
                            placeholder: "Example: 1e-9",
                            text: $diffusivityInput
                        )

                        EngineeringInputField(
                            title: "Depth",
                            symbol: "x",
                            unit: "m",
                            placeholder: "Example: 0.001",
                            text: $depthInput
                        )

                        EngineeringInputField(
                            title: "Diffusion Time",
                            symbol: "t",
                            unit: "s",
                            placeholder: "Example: 3600",
                            text: $timeInput
                        )

                        MassTransferActionButtons(
                            loadExample: loadExample,
                            clear: resetInputs
                        )

                        PrimaryActionButton(
                            title: "Calculate Transient Diffusion",
                            systemImage:
                                "waveform.path.ecg.rectangle",
                            action: calculate
                        )

                        if let result {
                            resultSection(result)
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Fick’s Second Law")
    }

    private func resultSection(
        _ result: FicksSecondLawResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label: "Similarity Variable",
                        value: numberFormatter.format(
                            result.similarityVariable
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "Dimensionless Concentration",
                        value: numberFormatter.format(
                            result.dimensionlessConcentrationRatio
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "Approach to Surface State",
                        value: numberFormatter.format(
                            100 * result.fractionalApproachToSurface
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Concentration at x,t",
                        value: numberFormatter.format(
                            result.concentrationAtDepthAndTime
                        ),
                        unit: "mol/m³"
                    ),
                    .init(
                        label: "Diffusion Length",
                        value: numberFormatter.format(
                            result.diffusionLength
                        ),
                        unit: "m"
                    ),
                    .init(
                        label: "Signed Surface Flux",
                        value: numberFormatter.format(
                            result.signedSurfaceFlux
                        ),
                        unit: "mol/(m²·s)"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Text(result.directionDescription)
                        .font(.headline)

                    Divider()

                    Text(result.modelName)
                        .foregroundStyle(.secondary)

                    Text(result.limitationDescription)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> FicksSecondLawInput {

        .init(
            initialConcentration:
                try InputValidator.parseNumber(
                    initialConcentrationInput,
                    fieldName: "initial concentration"
                ),
            surfaceConcentration:
                try InputValidator.parseNumber(
                    surfaceConcentrationInput,
                    fieldName: "surface concentration"
                ),
            diffusivity:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName: "diffusivity"
                ),
            depth:
                try InputValidator.parseNumber(
                    depthInput,
                    fieldName: "depth"
                ),
            diffusionTime:
                try InputValidator.parseNumber(
                    timeInput,
                    fieldName: "diffusion time"
                )
        )
    }

    private func loadExample() {
        initialConcentrationInput = "1"
        surfaceConcentrationInput = "0"
        diffusivityInput = "0.000000001"
        depthInput = "0.001"
        timeInput = "3600"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialConcentrationInput = ""
        surfaceConcentrationInput = ""
        diffusivityInput = ""
        depthInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FicksSecondLawView()
    }
}
