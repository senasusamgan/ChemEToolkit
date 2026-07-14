import Foundation

enum ComparisonConversionFormat: String, CaseIterable, Identifiable, Codable, Hashable {
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
            return "Enter a value greater than 0 and less than 1"

        case .percentage:
            return "Enter a value greater than 0 and less than 100"
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
}

enum ComparedReactor: String, Identifiable, Codable, Hashable {
    case pfr = "PFR"
    case cstr = "CSTR"

    var id: String {
        rawValue
    }
}

struct ReactorComparisonInput: Equatable {
    let rateConstant: Double?
    let conversion: Double?
    let flowRate: Double?
}

struct ReactorVolumeData: Identifiable, Equatable {
    let reactor: ComparedReactor
    let volume: Double

    var id: ComparedReactor {
        reactor
    }
}

struct ReactorComparisonResult: Equatable {
    let conversion: Double

    let pfrSpaceTime: Double
    let cstrSpaceTime: Double

    let pfrVolume: Double
    let cstrVolume: Double

    let volumeDifference: Double
    let volumeRatio: Double

    var chartData: [ReactorVolumeData] {
        [
            ReactorVolumeData(
                reactor: .pfr,
                volume: pfrVolume
            ),
            ReactorVolumeData(
                reactor: .cstr,
                volume: cstrVolume
            )
        ]
    }
}
