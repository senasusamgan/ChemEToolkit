import Foundation
struct NewtonMultivariableOptimizationEngine {
 func solve(_ input:NewtonMultivariableOptimizationInput)throws->NewtonMultivariableOptimizationResult {
  guard input.initialPoint.count==2,input.initialPoint.allSatisfy(\.isFinite) else { throw NewtonMultivariableOptimizationError.invalidInitialPoint }
  guard input.tolerance.isFinite,input.tolerance>0,input.maximumIterations>0 else { throw NewtonMultivariableOptimizationError.invalidControls }
  func data(_ p:[Double])->(Double,[Double],[[Double]]) { let x=p[0],y=p[1]; switch input.objective { case .quadratic:return (pow(x-3,2)+2*pow(y+2,2),[2*(x-3),4*(y+2)],[[2,0],[0,4]]); case .coupledQuartic: let d=x-y; return (pow(x-1,2)+pow(y+1,2)+0.1*pow(d,4),[2*(x-1)+0.4*pow(d,3),2*(y+1)-0.4*pow(d,3)],[[2+1.2*d*d,-1.2*d*d],[-1.2*d*d,2+1.2*d*d]]) } }
  var p=input.initialPoint
  for iteration in 0..<input.maximumIterations { let d=data(p),g=d.1,h=d.2,norm=sqrt(g[0]*g[0]+g[1]*g[1]);if norm<=input.tolerance{return .init(optimum:p,objectiveValue:d.0,gradientNorm:norm,iterations:iteration)};let det=h[0][0]*h[1][1]-h[0][1]*h[1][0];guard abs(det)>1e-14 else{throw NewtonMultivariableOptimizationError.singularHessian};let dx=(h[1][1]*g[0]-h[0][1]*g[1])/det,dy=(-h[1][0]*g[0]+h[0][0]*g[1])/det;p[0]-=dx;p[1]-=dy;guard p.allSatisfy(\.isFinite) else{throw NewtonMultivariableOptimizationError.didNotConverge} }
  throw NewtonMultivariableOptimizationError.didNotConverge
 }
}
