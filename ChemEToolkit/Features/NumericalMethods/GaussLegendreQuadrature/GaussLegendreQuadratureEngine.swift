import Foundation
struct GaussLegendreQuadratureEngine {
 func solve(_ input: GaussLegendreQuadratureInput) throws -> GaussLegendreQuadratureResult {
  guard input.lowerBound.isFinite,input.upperBound.isFinite,input.lowerBound != input.upperBound else { throw GaussLegendreQuadratureError.invalidBounds }
  let nw:([Double],[Double]); switch input.order {
  case 2: nw=([-0.5773502691896257,0.5773502691896257],[1,1])
  case 3: nw=([-0.7745966692414834,0,0.7745966692414834],[0.5555555555555556,0.8888888888888888,0.5555555555555556])
  case 4: nw=([-0.8611363115940526,-0.3399810435848563,0.3399810435848563,0.8611363115940526],[0.3478548451374538,0.6521451548625461,0.6521451548625461,0.3478548451374538])
  case 5: nw=([-0.9061798459386640,-0.5384693101056831,0,0.5384693101056831,0.9061798459386640],[0.2369268850561891,0.4786286704993665,0.5688888888888889,0.4786286704993665,0.2369268850561891])
  default: throw GaussLegendreQuadratureError.unsupportedOrder }
  func f(_ x:Double)->Double { switch input.function { case .square:return x*x; case .exponentialDecay:return exp(-x); case .gaussian:return exp(-x*x) } }
  let mid=(input.lowerBound+input.upperBound)/2, half=(input.upperBound-input.lowerBound)/2
  let value=zip(nw.0,nw.1).reduce(0.0){$0+$1.1*f(mid+half*$1.0)}*half
  return .init(integral:value,nodesUsed:input.order)
 }
}
