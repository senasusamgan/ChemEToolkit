import Foundation
import SwiftUI
struct HighOrderFiniteDifferenceView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("High-Order Finite Difference").font(.largeTitle.bold())
  Text("Five-point derivatives of exp(x) at x = 1; variables are dimensionless.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try HighOrderFiniteDifferenceEngine().solve(.init(function:.exponential,point:1));output=String(format:"f′ %.8g, f″ %.8g",r.firstDerivative,r.secondDerivative);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
