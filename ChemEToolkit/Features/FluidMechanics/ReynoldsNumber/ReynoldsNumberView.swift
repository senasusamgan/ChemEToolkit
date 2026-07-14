import SwiftUI

struct ReynoldsNumberView: View {

    private enum ViscosityMode:
        String,
        CaseIterable,
        Identifiable {

        case dynamic
        case kinematic

        var id: Self {
            self
        }

        var pickerTitle: String {
            switch self {
            case .dynamic:
                return "Dynamic"

            case .kinematic:
                return "Kinematic"
            }
        }

        var title: String {
            switch self {
            case .dynamic:
                return "Dynamic Viscosity Method"

            case .kinematic:
                return "Kinematic Viscosity Method"
            }
        }

        var formula: String {
            switch self {
            case .dynamic:
                return "Re = ρvD / μ"

            case .kinematic:
                return "Re = vD / ν"
            }
        }

        var explanation: String {
            switch self {
            case .dynamic:
                return
                    "Uses fluid density, average velocity, pipe diameter and dynamic viscosity."

            case .kinematic:
                return
                    "Uses average velocity, pipe diameter and kinematic viscosity."
            }
        }
    }

    @State
    private var selectedMode:
        ViscosityMode = .dynamic

    @State
    private var velocityText = "2"

    @State
    private var diameterText = "0.05"

    @State
    private var densityText = "998"

    @State
    private var dynamicViscosityText =
        "0.001"

    @State
    private var kinematicViscosityText =
        "1e-6"

    @State
    private var calculationResult:
        ReynoldsNumberResult?

    @State
    private var errorMessage = ""

    private let engine =
        ReynoldsNumberEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "water.waves",
                    title:
                        "Reynolds Number",
                    subtitle:
                        "Calculate Reynolds number and determine the flow regime",
                    tint:
                        .cyan
                )

                methodInformationCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
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
        .navigationTitle(
            "Reynolds Number"
        )
        .onChange(
            of: selectedMode
        ) { _, _ in
            clearResult()
        }
    }

    private var calculatorContent:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            viscosityModeSection

            Divider()

            flowPropertiesSection

            Divider()

            fluidPropertiesSection

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Reynolds Number",
                systemImage:
                    "equal.circle",
                action:
                    calculate
            )

            if let calculationResult {
                resultSection(
                    calculationResult
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message:
                        errorMessage
                )
            }
        }
    }

    private var viscosityModeSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            Text("Viscosity Type")
                .font(.headline)

            Text(
                "Choose which viscosity property is available."
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Picker(
                "Viscosity Type",
                selection:
                    $selectedMode
            ) {
                ForEach(
                    ViscosityMode.allCases
                ) { mode in
                    Text(
                        mode.pickerTitle
                    )
                    .tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var methodInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .cyan
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    selectedMode.title
                )
                .font(.headline)

                Text(
                    selectedMode.formula
                )
                .font(
                    .system(
                        size: 24,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(
                    .center
                )
                .minimumScaleFactor(0.7)

                Text(
                    selectedMode
                        .explanation
                )
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "The Reynolds number is dimensionless."
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .frame(
            maxWidth:
                AppTheme.Layout
                    .calculatorMaxWidth
        )
    }

    private var flowPropertiesSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Flow Properties")
                .font(.headline)

            numberInputField(
                title:
                    "Average Flow Velocity",
                symbol:
                    "v",
                unit:
                    "m/s",
                placeholder:
                    "Example: 2",
                text:
                    $velocityText
            )

            numberInputField(
                title:
                    "Pipe Diameter",
                symbol:
                    "D",
                unit:
                    "m",
                placeholder:
                    "Example: 0.05",
                text:
                    $diameterText
            )
        }
    }

    @ViewBuilder
    private var fluidPropertiesSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Fluid Properties")
                .font(.headline)

            switch selectedMode {
            case .dynamic:
                numberInputField(
                    title:
                        "Fluid Density",
                    symbol:
                        "ρ",
                    unit:
                        "kg/m³",
                    placeholder:
                        "Example: 998",
                    text:
                        $densityText
                )

                numberInputField(
                    title:
                        "Dynamic Viscosity",
                    symbol:
                        "μ",
                    unit:
                        "Pa·s",
                    placeholder:
                        "Example: 0.001",
                    text:
                        $dynamicViscosityText
                )

            case .kinematic:
                numberInputField(
                    title:
                        "Kinematic Viscosity",
                    symbol:
                        "ν",
                    unit:
                        "m²/s",
                    placeholder:
                        "Example: 1e-6",
                    text:
                        $kinematicViscosityText
                )
            }
        }
    }

    private func numberInputField(
        title: String,
        symbol: String,
        unit: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.xxSmall
        ) {
            HStack(
                alignment: .firstTextBaseline
            ) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                Text(symbol)
                    .font(.subheadline)
                    .foregroundStyle(
                        .secondary
                    )
            }

            HStack(
                spacing: AppSpacing.small
            ) {
                TextField(
                    placeholder,
                    text: text
                )
                .textFieldStyle(
                    .roundedBorder
                )
                .engineeringNumberKeyboard()
                .accessibilityLabel(
                    title
                )

                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(
                        .secondary
                    )
                    .frame(
                        minWidth: 54,
                        alignment: .leading
                    )
            }
        }
    }

    private var actionButtons:
        some View {

        ViewThatFits(
            in: .horizontal
        ) {
            HStack(
                spacing: AppSpacing.small
            ) {
                loadExampleButton
                clearButton
            }

            VStack(
                spacing: AppSpacing.small
            ) {
                loadExampleButton
                clearButton
            }
        }
    }

    private var loadExampleButton:
        some View {

        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage:
                    "doc.text"
            )
            .frame(
                maxWidth: .infinity
            )
        }
        .buttonStyle(.bordered)
    }

    private var clearButton:
        some View {

        Button {
            resetInputs()
        } label: {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(
                maxWidth: .infinity
            )
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result:
            ReynoldsNumberResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Reynolds Number",
                        value:
                            numberFormatter
                                .format(
                                    result
                                        .reynoldsNumber
                                ),
                        unit:
                            "dimensionless"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Flow Regime",
                        value:
                            regimeTitle(
                                result
                                    .flowRegime
                            ),
                        unit:
                            ""
                    )
                ]
            )

            flowRegimeInformationCard(
                result.flowRegime
            )
        }
    }

    private func flowRegimeInformationCard(
        _ regime: FlowRegime
    ) -> some View {

        CalculatorInfoCard(
            tint:
                regimeTint(regime)
        ) {
            VStack(
                spacing: AppSpacing.medium
            ) {
                Label(
                    regimeTitle(regime),
                    systemImage:
                        regimeSymbol(regime)
                )
                .font(.headline)

                Text(
                    regimeExplanation(
                        regime
                    )
                )
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )

                Divider()

                VStack(
                    spacing: AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Laminar",
                        value:
                            "Re < 2,300"
                    )

                    informationRow(
                        title:
                            "Transitional",
                        value:
                            "2,300 ≤ Re ≤ 4,000"
                    )

                    informationRow(
                        title:
                            "Turbulent",
                        value:
                            "Re > 4,000"
                    )
                }
            }
            .frame(
                maxWidth: .infinity
            )
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {

        HStack(
            alignment: .firstTextBaseline
        ) {
            Text(title)
                .foregroundStyle(
                    .secondary
                )

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(
                    .trailing
                )
        }
    }

    private func calculate() {
        clearResult()

        do {
            let input =
                try makeInput()

            calculationResult =
                try engine.solve(
                    input: input
                )
        } catch let error
            as CalculationError {

            showCalculationError(
                error
            )
        } catch let error
            as ReynoldsNumberError {

            errorMessage =
                error.errorDescription
                ?? "The Reynolds number could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> ReynoldsNumberInput {

        let velocity =
            try parsePositiveNumber(
                velocityText,
                fieldName:
                    "Average Flow Velocity"
            )

        let diameter =
            try parsePositiveNumber(
                diameterText,
                fieldName:
                    "Pipe Diameter"
            )

        switch selectedMode {
        case .dynamic:
            let density =
                try parsePositiveNumber(
                    densityText,
                    fieldName:
                        "Fluid Density"
                )

            let dynamicViscosity =
                try parsePositiveNumber(
                    dynamicViscosityText,
                    fieldName:
                        "Dynamic Viscosity"
                )

            return ReynoldsNumberInput(
                velocity: velocity,
                diameter: diameter,
                viscosity: .dynamic(
                    density: density,
                    dynamicViscosity:
                        dynamicViscosity
                )
            )

        case .kinematic:
            let kinematicViscosity =
                try parsePositiveNumber(
                    kinematicViscosityText,
                    fieldName:
                        "Kinematic Viscosity"
                )

            return ReynoldsNumberInput(
                velocity: velocity,
                diameter: diameter,
                viscosity: .kinematic(
                    kinematicViscosity:
                        kinematicViscosity
                )
            )
        }
    }

    private func parsePositiveNumber(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let parsedValue =
            try InputValidator
                .parseNumber(
                    text,
                    fieldName:
                        fieldName
                )

        return try InputValidator
            .requirePositive(
                parsedValue,
                fieldName:
                    fieldName
            )
    }

    private func loadExample() {
        velocityText = "2"
        diameterText = "0.05"

        switch selectedMode {
        case .dynamic:
            densityText = "998"
            dynamicViscosityText =
                "0.001"

        case .kinematic:
            kinematicViscosityText =
                "1e-6"
        }

        clearResult()
    }

    private func resetInputs() {
        velocityText = ""
        diameterText = ""
        densityText = ""
        dynamicViscosityText = ""
        kinematicViscosityText = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The input values could not be processed."

        if let suggestion =
            error.recoverySuggestion {

            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage =
                description
        }
    }

    private func regimeTitle(
        _ regime: FlowRegime
    ) -> String {

        switch regime {
        case .laminar:
            return "Laminar"

        case .transitional:
            return "Transitional"

        case .turbulent:
            return "Turbulent"
        }
    }

    private func regimeExplanation(
        _ regime: FlowRegime
    ) -> String {

        switch regime {
        case .laminar:
            return
                "The fluid moves in smooth and orderly layers with limited mixing."

        case .transitional:
            return
                "The flow is between laminar and turbulent behaviour and may be unstable."

        case .turbulent:
            return
                "The fluid exhibits substantial mixing, fluctuations and irregular motion."
        }
    }

    private func regimeSymbol(
        _ regime: FlowRegime
    ) -> String {

        switch regime {
        case .laminar:
            return
                "line.3.horizontal"

        case .transitional:
            return
                "waveform.path"

        case .turbulent:
            return
                "tornado"
        }
    }

    private func regimeTint(
        _ regime: FlowRegime
    ) -> Color {

        switch regime {
        case .laminar:
            return .blue

        case .transitional:
            return .orange

        case .turbulent:
            return .red
        }
    }

    private func clearResult() {
        calculationResult = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReynoldsNumberView()
    }
}
