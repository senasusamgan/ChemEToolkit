import SwiftUI
import Charts

private struct RegressionPointDraft:
    Identifiable,
    Equatable {

    let id: UUID

    var xText: String
    var yText: String

    init(
        id: UUID = UUID(),
        xText: String = "",
        yText: String = ""
    ) {
        self.id = id
        self.xText = xText
        self.yText = yText
    }
}

struct CurveFittingView: View {
    @State
    private var selectedMethod:
        CurveFittingMethod = .linear

    @State
    private var polynomialDegree = 2

    @State
    private var pointRows:
        [RegressionPointDraft] = [
            RegressionPointDraft(),
            RegressionPointDraft(),
            RegressionPointDraft()
        ]

    @State
    private var predictionXInput = ""

    @State
    private var result:
        CurveFittingResult?

    @State
    private var plottedPoints:
        [RegressionPoint] = []

    @State
    private var curvePoints:
        [RegressionPoint] = []

    @State
    private var errorMessage = ""

    private let engine =
        CurveFittingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    private var effectiveDegree: Int {
        selectedMethod == .linear
            ? 1
            : polynomialDegree
    }

    private var minimumPointCount: Int {
        effectiveDegree + 1
    }

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "chart.line.uptrend.xyaxis",
                    title:
                        "Curve Fitting & Regression",
                    subtitle:
                        "Linear and Polynomial Least-Squares Regression",
                    tint: .blue
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
            "Curve Fitting"
        )
        .onChange(
            of: selectedMethod
        ) { _, _ in
            ensureMinimumPointCount()
            clearResult()
        }
        .onChange(
            of: polynomialDegree
        ) { _, _ in
            ensureMinimumPointCount()
            clearResult()
        }
    }

    private var calculatorContent:
        some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Regression Model")
                .font(.headline)

            Picker(
                "Regression Model",
                selection: $selectedMethod
            ) {
                ForEach(
                    CurveFittingMethod
                        .allCases
                ) { method in
                    Text(method.pickerTitle)
                        .tag(method)
                }
            }
            .pickerStyle(.segmented)

            if selectedMethod ==
                .polynomial {

                HStack {
                    Text("Polynomial Degree")
                        .font(.headline)

                    Spacer()

                    Picker(
                        "Polynomial Degree",
                        selection:
                            $polynomialDegree
                    ) {
                        ForEach(
                            2...4,
                            id: \.self
                        ) { degree in
                            Text(
                                "Degree \(degree)"
                            )
                            .tag(degree)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }

            Divider()

            dataPointsHeader

            VStack(
                spacing: AppSpacing.small
            ) {
                ForEach(
                    Array(
                        pointRows
                            .enumerated()
                    ),
                    id: \.element.id
                ) { index, row in
                    pointRow(
                        index: index,
                        rowID: row.id,
                        xText:
                            $pointRows[index]
                                .xText,
                        yText:
                            $pointRows[index]
                                .yText
                    )
                }
            }

            pointActions

            Divider()

            CalculatorInputField(
                title: "Prediction Value",
                symbol: "xₚ",
                unit: "",
                placeholder:
                    "Optional prediction x value",
                text:
                    $predictionXInput
            )

            Text(
                "Leave the prediction field empty to calculate only the regression model."
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            PrimaryActionButton(
                title: "Fit Regression Model",
                systemImage:
                    "chart.line.uptrend.xyaxis",
                action: fitRegression
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

    private var methodInformationCard:
        some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(selectedMethod.title)
                    .font(.headline)

                Text(modelFormula)
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .multilineTextAlignment(
                        .center
                    )

                Text(
                    selectedMethod.explanation
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "Minimum required data points: \(minimumPointCount)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout
                    .calculatorMaxWidth
        )
    }

    private var modelFormula: String {
        switch effectiveDegree {
        case 1:
            return "ŷ = a₀ + a₁x"

        case 2:
            return "ŷ = a₀ + a₁x + a₂x²"

        case 3:
            return
                "ŷ = a₀ + a₁x + a₂x² + a₃x³"

        default:
            return
                "ŷ = a₀ + a₁x + a₂x² + a₃x³ + a₄x⁴"
        }
    }

    private var dataPointsHeader:
        some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing:
                    AppSpacing.xxSmall
            ) {
                Text("Experimental Data")
                    .font(.headline)

                Text(
                    "Enter measured x and y values."
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
            }

            Spacer()

            Text(
                pointRows.count == 1
                    ? "1 point"
                    : "\(pointRows.count) points"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private func pointRow(
        index: Int,
        rowID: UUID,
        xText: Binding<String>,
        yText: Binding<String>
    ) -> some View {
        HStack(
            alignment: .bottom,
            spacing: AppSpacing.small
        ) {
            Text("\(index + 1)")
                .font(
                    .subheadline
                        .monospacedDigit()
                )
                .foregroundStyle(.secondary)
                .frame(width: 24)

            compactNumberField(
                title: "x",
                placeholder: "x",
                text: xText
            )

            compactNumberField(
                title: "y",
                placeholder: "y",
                text: yText
            )

            Button {
                removePoint(rowID)
            } label: {
                Image(
                    systemName: "trash"
                )
                .frame(
                    width: 34,
                    height: 34
                )
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.red)
            .disabled(
                pointRows.count <=
                    minimumPointCount
            )
            .accessibilityLabel(
                "Delete point \(index + 1)"
            )
        }
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.medium
            )
            .fill(
                AppTheme.Colors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.medium
            )
            .stroke(
                AppTheme.Colors.border,
                lineWidth: 1
            )
        )
    }

    private func compactNumberField(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing:
                AppSpacing.xxSmall
        ) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField(
                placeholder,
                text: text
            )
            .textFieldStyle(
                .roundedBorder
            )
            .engineeringNumberKeyboard()
            .accessibilityLabel(title)
        }
        .frame(maxWidth: .infinity)
    }

    private var pointActions:
        some View {
        ViewThatFits(in: .horizontal) {
            HStack(
                spacing: AppSpacing.small
            ) {
                addPointButton
                loadExampleButton
                clearButton
            }

            VStack(
                spacing: AppSpacing.small
            ) {
                addPointButton
                loadExampleButton
                clearButton
            }
        }
    }

    private var addPointButton:
        some View {
        Button {
            pointRows.append(
                RegressionPointDraft()
            )

            clearResult()
        } label: {
            Label(
                "Add Point",
                systemImage: "plus"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var loadExampleButton:
        some View {
        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
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
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result: CurveFittingResult
    ) -> some View {
        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items:
                    resultDisplayItems(
                        result
                    )
            )

            equationCard(result)

            if result.isExtrapolation {
                extrapolationWarning(
                    result
                )
            }

            regressionChart(result)
            coefficientCard(result)
            resultInformationCard(result)
        }
    }

    private func resultDisplayItems(
        _ result: CurveFittingResult
    ) -> [CalculationResultDisplayItem] {
        var items = [
            CalculationResultDisplayItem(
                label:
                    "Coefficient of Determination",
                value:
                    numberFormatter.format(
                        result.rSquared
                    ),
                unit: "R²"
            ),
            CalculationResultDisplayItem(
                label:
                    "Root Mean Square Error",
                value:
                    numberFormatter.format(
                        result.rmse
                    ),
                unit: "RMSE"
            )
        ]

        if
            let predictionX =
                result.predictionX,
            let predictedY =
                result.predictedY {

            items.append(
                CalculationResultDisplayItem(
                    label:
                        "Predicted Value",
                    value:
                        numberFormatter.format(
                            predictedY
                        ),
                    unit:
                        "ŷ(\(numberFormatter.format(predictionX)))"
                )
            )
        }

        return items
    }

    private func equationCard(
        _ result:
            CurveFittingResult
    ) -> some View {
        CalculatorInfoCard(
            tint: .blue
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Fitted Equation")
                    .font(.headline)

                Text(
                    equationText(
                        coefficients:
                            result.coefficients
                    )
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(
                    .center
                )
                .minimumScaleFactor(0.65)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func extrapolationWarning(
        _ result:
            CurveFittingResult
    ) -> some View {
        CalculatorInfoCard(
            tint: .orange
        ) {
            HStack(
                alignment: .top,
                spacing: AppSpacing.small
            ) {
                Image(
                    systemName:
                        "exclamationmark.triangle.fill"
                )
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

                VStack(
                    alignment: .leading,
                    spacing:
                        AppSpacing.xxSmall
                ) {
                    Text("Extrapolation")
                        .font(.headline)

                    Text(
                        "The prediction x value lies outside the experimental range [\(numberFormatter.format(result.lowerBound)), \(numberFormatter.format(result.upperBound))]."
                    )
                    .foregroundStyle(
                        .secondary
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }
            }
        }
    }

    private func regressionChart(
        _ result:
            CurveFittingResult
    ) -> some View {
        Chart {
            ForEach(
                curvePoints,
                id: \.x
            ) { point in
                LineMark(
                    x: .value(
                        "x",
                        point.x
                    ),
                    y: .value(
                        "Fitted y",
                        point.y
                    )
                )
            }

            ForEach(
                Array(
                    plottedPoints.enumerated()
                ),
                id: \.offset
            ) { _, point in
                PointMark(
                    x: .value(
                        "Measured x",
                        point.x
                    ),
                    y: .value(
                        "Measured y",
                        point.y
                    )
                )
                .symbolSize(75)
            }

            if
                let predictionX =
                    result.predictionX,
                let predictedY =
                    result.predictedY {

                RuleMark(
                    x: .value(
                        "Prediction x",
                        predictionX
                    )
                )
                .lineStyle(
                    StrokeStyle(
                        lineWidth: 1,
                        dash: [5, 5]
                    )
                )

                PointMark(
                    x: .value(
                        "Prediction x",
                        predictionX
                    ),
                    y: .value(
                        "Predicted y",
                        predictedY
                    )
                )
                .symbolSize(120)
            }
        }
        .chartXAxisLabel("x")
        .chartYAxisLabel("y")
        .frame(height: 300)
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .fill(
                AppTheme.Colors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .stroke(
                AppTheme.Colors.border,
                lineWidth: 1
            )
        )
        .accessibilityLabel(
            "Regression graph showing experimental data and the fitted curve"
        )
    }

    private func coefficientCard(
        _ result:
            CurveFittingResult
    ) -> some View {
        CalculatorInfoCard(
            tint: .blue
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Regression Coefficients")
                    .font(.headline)

                Divider()

                ForEach(
                    Array(
                        result.coefficients
                            .enumerated()
                    ),
                    id: \.offset
                ) { power, coefficient in
                    informationRow(
                        title: "a\(power)",
                        value:
                            numberFormatter
                                .format(
                                    coefficient
                                )
                    )
                }
            }
        }
    }

    private func resultInformationCard(
        _ result:
            CurveFittingResult
    ) -> some View {
        CalculatorInfoCard(
            tint: .blue
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                informationRow(
                    title: "Model",
                    value:
                        result.method.title
                )

                Divider()

                informationRow(
                    title: "Degree",
                    value:
                        "\(result.degree)"
                )

                informationRow(
                    title: "Data Points",
                    value:
                        "\(result.pointCount)"
                )

                informationRow(
                    title:
                        "Experimental Range",
                    value:
                        "[\(numberFormatter.format(result.lowerBound)), \(numberFormatter.format(result.upperBound))]"
                )

                if result.predictionX != nil {
                    informationRow(
                        title:
                            "Prediction Type",
                        value:
                            result.isExtrapolation
                            ? "Extrapolation"
                            : "Interpolation"
                    )
                }
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack(
            alignment:
                .firstTextBaseline,
            spacing:
                AppSpacing.medium
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

    private func equationText(
        coefficients: [Double]
    ) -> String {
        var equation = "ŷ = "

        for power in
            coefficients.indices {

            let coefficient =
                coefficients[power]

            let absoluteValue =
                abs(coefficient)

            let formattedValue =
                numberFormatter.format(
                    absoluteValue
                )

            let term: String

            switch power {
            case 0:
                term = formattedValue

            case 1:
                term =
                    "\(formattedValue)x"

            default:
                term =
                    "\(formattedValue)x\(superscript(power))"
            }

            if power == 0 {
                equation +=
                    coefficient < 0
                    ? "−\(term)"
                    : term
            } else {
                equation +=
                    coefficient < 0
                    ? " − \(term)"
                    : " + \(term)"
            }
        }

        return equation
    }

    private func superscript(
        _ number: Int
    ) -> String {
        let characters:
            [Character: Character] = [
                "0": "⁰",
                "1": "¹",
                "2": "²",
                "3": "³",
                "4": "⁴",
                "5": "⁵",
                "6": "⁶",
                "7": "⁷",
                "8": "⁸",
                "9": "⁹"
            ]

        return String(number)
            .compactMap {
                characters[$0]
            }
            .reduce("") {
                $0 + String($1)
            }
    }

    private func fitRegression() {
        clearResult()

        do {
            let input = try makeInput()

            let fittedResult =
                try engine.fit(
                    input: input
                )

            result = fittedResult

            plottedPoints =
                input.points.sorted {
                    $0.x < $1.x
                }

            curvePoints =
                makeCurvePoints(
                    result: fittedResult
                )
        } catch let error
            as CalculationError {

            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> CurveFittingInput {
        let points =
            try pointRows
                .enumerated()
                .map { index, row in
                    RegressionPoint(
                        x:
                            try InputValidator
                                .parseNumber(
                                    row.xText,
                                    fieldName:
                                        "x value for point \(index + 1)"
                                ),
                        y:
                            try InputValidator
                                .parseNumber(
                                    row.yText,
                                    fieldName:
                                        "y value for point \(index + 1)"
                                )
                    )
                }

        let trimmedPrediction =
            predictionXInput
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        let predictionX: Double?

        if trimmedPrediction.isEmpty {
            predictionX = nil
        } else {
            predictionX =
                try InputValidator
                    .parseNumber(
                        predictionXInput,
                        fieldName:
                            "Prediction x"
                    )
        }

        return CurveFittingInput(
            method: selectedMethod,
            polynomialDegree:
                polynomialDegree,
            points: points,
            predictionX:
                predictionX
        )
    }

    private func makeCurvePoints(
        result:
            CurveFittingResult
    ) -> [RegressionPoint] {
        let lowerChartBound =
            min(
                result.lowerBound,
                result.predictionX ??
                    result.lowerBound
            )

        let upperChartBound =
            max(
                result.upperBound,
                result.predictionX ??
                    result.upperBound
            )

        let rawRange =
            upperChartBound -
            lowerChartBound

        let padding =
            rawRange > 0
            ? rawRange * 0.05
            : 1

        let lower =
            lowerChartBound -
            padding

        let upper =
            upperChartBound +
            padding

        let sampleCount = 120

        return (0...sampleCount)
            .map { index in
                let fraction =
                    Double(index) /
                    Double(sampleCount)

                let x =
                    lower +
                    (upper - lower) *
                    fraction

                return RegressionPoint(
                    x: x,
                    y:
                        engine
                            .evaluatePolynomial(
                                coefficients:
                                    result.coefficients,
                                at: x
                            )
                )
            }
    }

    private func removePoint(
        _ rowID: UUID
    ) {
        guard pointRows.count >
                minimumPointCount else {
            return
        }

        pointRows.removeAll {
            $0.id == rowID
        }

        clearResult()
    }

    private func ensureMinimumPointCount() {
        while pointRows.count <
                minimumPointCount {
            pointRows.append(
                RegressionPointDraft()
            )
        }
    }

    private func loadExample() {
        switch selectedMethod {
        case .linear:
            pointRows = [
                RegressionPointDraft(
                    xText: "0",
                    yText: "1"
                ),
                RegressionPointDraft(
                    xText: "1",
                    yText: "3"
                ),
                RegressionPointDraft(
                    xText: "2",
                    yText: "5"
                ),
                RegressionPointDraft(
                    xText: "3",
                    yText: "7"
                )
            ]

            predictionXInput = "1.5"

        case .polynomial:
            polynomialDegree = 2

            pointRows = [
                RegressionPointDraft(
                    xText: "0",
                    yText: "1"
                ),
                RegressionPointDraft(
                    xText: "1",
                    yText: "2"
                ),
                RegressionPointDraft(
                    xText: "2",
                    yText: "5"
                ),
                RegressionPointDraft(
                    xText: "3",
                    yText: "10"
                )
            ]

            predictionXInput = "1.5"
        }

        clearResult()
    }

    private func resetInputs() {
        pointRows =
            (0..<minimumPointCount)
                .map { _ in
                    RegressionPointDraft()
                }

        predictionXInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The regression model could not be fitted."

        if let suggestion =
            error.recoverySuggestion {

            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        result = nil
        plottedPoints = []
        curvePoints = []
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CurveFittingView()
    }
}
