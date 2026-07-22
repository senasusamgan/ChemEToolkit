import Foundation
enum NumericalJacobianSystem: String, CaseIterable, Equatable, Sendable { case linear, nonlinear }
struct NumericalJacobianInput: Equatable, Sendable { let system: NumericalJacobianSystem; let point: [Double]; let step: Double
 init(system: NumericalJacobianSystem, point: [Double], step: Double = 1e-5) { self.system=system; self.point=point; self.step=step }
}
