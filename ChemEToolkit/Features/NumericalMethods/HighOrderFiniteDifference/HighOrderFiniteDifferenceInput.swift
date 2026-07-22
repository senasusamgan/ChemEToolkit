import Foundation
enum HighOrderFiniteDifferenceFunction: String, CaseIterable, Equatable, Sendable { case cubic, exponential, sine }
struct HighOrderFiniteDifferenceInput: Equatable, Sendable {
 let function: HighOrderFiniteDifferenceFunction; let point: Double; let step: Double
 init(function: HighOrderFiniteDifferenceFunction, point: Double, step: Double = 1e-3) { self.function = function; self.point = point; self.step = step }
}
