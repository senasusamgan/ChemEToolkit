import Foundation
struct NumericalJacobianEngine {
 func solve(_ input: NumericalJacobianInput) throws -> NumericalJacobianResult {
  guard input.point.count == 2, input.point.allSatisfy(\.isFinite) else { throw NumericalJacobianError.invalidPoint }
  guard input.step.isFinite, input.step > 0 else { throw NumericalJacobianError.invalidStep }
  func f(_ p:[Double]) -> [Double] { let x=p[0], y=p[1]; switch input.system { case .linear:return [2*x+3*y,x-y]; case .nonlinear:return [x*x+y*y,x*y+sin(x)] } }
  let base=f(input.point); var j=Array(repeating:Array(repeating:0.0,count:2),count:2)
  for column in 0..<2 { var plus=input.point, minus=input.point; plus[column] += input.step; minus[column] -= input.step; let fp=f(plus), fm=f(minus); for row in 0..<2 { j[row][column]=(fp[row]-fm[row])/(2*input.step) } }
  return .init(values:base,jacobian:j,step:input.step)
 }
}
