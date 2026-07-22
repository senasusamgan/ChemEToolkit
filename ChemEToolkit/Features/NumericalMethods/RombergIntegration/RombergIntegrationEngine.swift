import Foundation
struct RombergIntegrationEngine {
 func solve(_ input: RombergIntegrationInput) throws -> RombergIntegrationResult {
  guard input.lowerBound.isFinite,input.upperBound.isFinite,input.lowerBound != input.upperBound else { throw RombergIntegrationError.invalidBounds }
  guard (2...12).contains(input.levels) else { throw RombergIntegrationError.invalidLevels }
  func f(_ x: Double)->Double { switch input.function { case .square:return x*x; case .exponentialDecay:return exp(-x); case .gaussian:return exp(-x*x) } }
  let a=input.lowerBound,b=input.upperBound; var table=[[Double]](); table.append([(b-a)*(f(a)+f(b))/2])
  for i in 1..<input.levels { var row=Array(repeating:0.0,count:i+1); let intervals=1<<i, h=(b-a)/Double(intervals); var sum=0.0
   for k in stride(from:1,to:intervals,by:2){ sum += f(a+Double(k)*h) }
   row[0]=0.5*table[i-1][0]+h*sum
   for j in 1...i { let p=pow(4.0,Double(j)); row[j]=(p*row[j-1]-table[i-1][j-1])/(p-1) }
   table.append(row)
  }
  let value=table.last!.last!, prior=table[table.count-2].last!
  return .init(integral:value,table:table,estimatedError:abs(value-prior))
 }
}
