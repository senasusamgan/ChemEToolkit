import Foundation
struct CubicHermiteInterpolationEngine {
 func solve(_ q:CubicHermiteInterpolationInput)throws->CubicHermiteInterpolationResult { let all=[q.x0,q.x1,q.y0,q.y1,q.slope0,q.slope1,q.query]; guard all.allSatisfy(\.isFinite) else{throw CubicHermiteInterpolationError.nonFiniteInput}; guard q.x1>q.x0 else{throw CubicHermiteInterpolationError.invalidInterval}; guard q.query>=q.x0,q.query<=q.x1 else{throw CubicHermiteInterpolationError.queryOutOfRange}
  let h=q.x1-q.x0,t=(q.query-q.x0)/h,h00=2*t*t*t-3*t*t+1,h10=t*t*t-2*t*t+t,h01 = -2*t*t*t+3*t*t,h11=t*t*t-t*t
  let value=h00*q.y0+h10*h*q.slope0+h01*q.y1+h11*h*q.slope1
  let derivative=((6*t*t-6*t)*q.y0+(3*t*t-4*t+1)*h*q.slope0+(-6*t*t+6*t)*q.y1+(3*t*t-2*t)*h*q.slope1)/h
  return .init(value:value,firstDerivative:derivative,normalizedCoordinate:t)
 }
}
