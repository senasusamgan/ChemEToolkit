import Foundation
import SwiftUI
struct AdamsBashforthMoultonView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Adams-Bashforth-Moulton ODE").font(.largeTitle.bold())
  Text("Solves y′ = y from x = 0 to 1 using a fourth-order predictor-corrector.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try AdamsBashforthMoultonEngine().solve(.init(equation:.exponentialGrowth,initialX:0,initialY:1,finalX:1));output=String(format:"%.10g",r.finalValue);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
