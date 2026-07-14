import Foundation

enum ReactorType: String, CaseIterable, Identifiable, Codable, Hashable {
    case batch
    case cstr
    case pfr

    var id: String {
        rawValue
    }

    var pickerTitle: String {
        switch self {
        case .batch:
            return "Batch"

        case .cstr:
            return "CSTR"

        case .pfr:
            return "PFR"
        }
    }

    var title: String {
        switch self {
        case .batch:
            return "Batch Reactor"

        case .cstr:
            return "Continuous Stirred-Tank Reactor"

        case .pfr:
            return "Plug Flow Reactor"
        }
    }

    var subtitle: String {
        switch self {
        case .batch:
            return "Closed, unsteady-state reactor"

        case .cstr:
            return "Steady-state, perfectly mixed reactor"

        case .pfr:
            return "Steady-state tubular reactor"
        }
    }

    var icon: String {
        switch self {
        case .batch:
            return "flask.fill"

        case .cstr:
            return "arrow.triangle.2.circlepath"

        case .pfr:
            return "arrow.right.to.line"
        }
    }

    var equation: String {
        switch self {
        case .batch:
            return "X = 1 − e^(−kt)"

        case .cstr:
            return "X = kτ / (1 + kτ)"

        case .pfr:
            return "X = 1 − e^(−kτ)"
        }
    }
}

enum ReactorCalculation: String, Identifiable, Codable, Hashable {
    case conversion
    case time
    case rateConstant
    case spaceTime
    case volume

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .conversion:
            return "Conversion"

        case .time:
            return "Reaction Time"

        case .rateConstant:
            return "Rate Constant"

        case .spaceTime:
            return "Space Time"

        case .volume:
            return "Reactor Volume"
        }
    }

    var shortTitle: String {
        switch self {
        case .conversion:
            return "X"

        case .time:
            return "t"

        case .rateConstant:
            return "k"

        case .spaceTime:
            return "τ"

        case .volume:
            return "V"
        }
    }

    static func options(
        for reactorType: ReactorType
    ) -> [ReactorCalculation] {
        switch reactorType {
        case .batch:
            return [
                .conversion,
                .time,
                .rateConstant
            ]

        case .cstr, .pfr:
            return [
                .conversion,
                .spaceTime,
                .volume
            ]
        }
    }
}

enum ReactorConversionFormat: String, CaseIterable, Identifiable, Codable, Hashable {
    case fraction
    case percentage

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .fraction:
            return "Fraction"

        case .percentage:
            return "Percentage"
        }
    }

    var unit: String {
        switch self {
        case .fraction:
            return "0 – 1"

        case .percentage:
            return "%"
        }
    }

    var placeholder: String {
        switch self {
        case .fraction:
            return "Enter a value from 0 to less than 1"

        case .percentage:
            return "Enter a value from 0 to less than 100"
        }
    }

    func fractionValue(
        from enteredValue: Double
    ) -> Double {
        switch self {
        case .fraction:
            return enteredValue

        case .percentage:
            return enteredValue / 100
        }
    }

    func displayValue(
        from fraction: Double
    ) -> Double {
        switch self {
        case .fraction:
            return fraction

        case .percentage:
            return fraction * 100
        }
    }
}

struct ReactorInput: Equatable {
    let rateConstant: Double?
    let conversion: Double?
    let time: Double?
    let spaceTime: Double?
    let flowRate: Double?
}

enum ReactorResultVariable: String, Identifiable, Codable, Hashable {
    case conversion
    case time
    case rateConstant
    case spaceTime
    case volume

    var id: String {
        rawValue
    }

    var displayLabel: String {
        switch self {
        case .conversion:
            return "Conversion (X)"

        case .time:
            return "Reaction Time (t)"

        case .rateConstant:
            return "Rate Constant (k)"

        case .spaceTime:
            return "Space Time (τ)"

        case .volume:
            return "Reactor Volume (V)"
        }
    }
}

struct ReactorResultItem: Identifiable, Equatable {
    let variable: ReactorResultVariable
    let value: Double

    var id: ReactorResultVariable {
        variable
    }
}

struct ReactorSolution: Equatable {
    let reactorType: ReactorType
    let calculation: ReactorCalculation
    let items: [ReactorResultItem]
}
