import Foundation

enum MassBalanceUnknown: String, CaseIterable, Identifiable, Codable, Hashable {
    case outletFlow
    case outletComposition
    case inletFlow1
    case inletFlow2

    var id: String {
        rawValue
    }

    var symbol: String {
        switch self {
        case .outletFlow:
            return "F₃"

        case .outletComposition:
            return "x₃"

        case .inletFlow1:
            return "F₁"

        case .inletFlow2:
            return "F₂"
        }
    }

    var title: String {
        switch self {
        case .outletFlow:
            return "Outlet Flow"

        case .outletComposition:
            return "Outlet Composition"

        case .inletFlow1:
            return "Inlet Flow 1"

        case .inletFlow2:
            return "Inlet Flow 2"
        }
    }
}

enum CompositionFormat: String, CaseIterable, Identifiable, Codable, Hashable {
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
            return "Enter a value between 0 and 1"

        case .percentage:
            return "Enter a value between 0 and 100"
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

struct MassBalanceInput: Equatable {
    let flow1: Double?
    let flow2: Double?
    let composition1: Double?
    let composition2: Double?
    let outletComposition: Double?
}

enum MassBalanceResultVariable: String, Identifiable, Codable, Hashable {
    case inletFlow1
    case inletFlow2
    case outletFlow
    case outletComposition

    var id: String {
        rawValue
    }

    var label: String {
        switch self {
        case .inletFlow1:
            return "Inlet Flow 1"

        case .inletFlow2:
            return "Inlet Flow 2"

        case .outletFlow:
            return "Outlet Flow"

        case .outletComposition:
            return "Outlet Composition"
        }
    }

    var symbol: String {
        switch self {
        case .inletFlow1:
            return "F₁"

        case .inletFlow2:
            return "F₂"

        case .outletFlow:
            return "F₃"

        case .outletComposition:
            return "x₃"
        }
    }

    var isComposition: Bool {
        self == .outletComposition
    }
}

struct MassBalanceResultItem: Identifiable, Equatable {
    let variable: MassBalanceResultVariable
    let value: Double

    var id: MassBalanceResultVariable {
        variable
    }

    var displayLabel: String {
        "\(variable.label) (\(variable.symbol))"
    }
}

struct MassBalanceSolution: Equatable {
    let unknownVariable: MassBalanceUnknown
    let items: [MassBalanceResultItem]
}
