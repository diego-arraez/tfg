//
//  RankingView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct RankingView: View {
    
    let colors: [String: Color] = ["1": .yellow, "2": .gray, "3": Color("cobre")]
        
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
    
    @StateObject var viewModel: RankingViewModel = RankingViewModel()
    

    
    var body: some View {
  
        ZStack {
            NavigationView {
                    HStack {
                        Form {
                            
                            Section() {
                            
                                
                                ForEach(viewModel.ranking, id: \.name) { ranking in
                                                                        
                                    HStack(spacing: 10) {
                                        
                                        VStack(alignment: .leading) {
                                            
                                            Text("\(ranking.position)")
                                                .fontWeight(.black)
                                                .font(.system(size: 18))
                                                .frame(width: 42.0, height: 10.0)
                                                .padding(10)
                                                .foregroundColor(Color.black)
                                            
                                            Text("\(ranking.points) puntos")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color.black)
                                            
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text(ranking.position == "1" ? "👑 \(ranking.name)" : ranking.name)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            
                                            
                                            HStack{
                                                
                                                Text("\(ranking.cobre)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.cobre) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(2)
                                                    .background(
                                                        AngularGradient(
                                                            colors: [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], // Color marrón-naranja
                                                            center: .center,
                                                            startAngle: .degrees(90),
                                                            endAngle: .degrees(360)
                                                        )
                                                    )
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                Text("\(ranking.plata)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.plata) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(2)
                                                    .background(AngularGradient(colors: [.gray, Color("plata"), .gray, Color("plata"), .gray],
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                Text("\(ranking.oro)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.oro) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(2)
                                                    .background(AngularGradient(colors: [.yellow, .brown, .yellow, .brown, .yellow],
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                Text("\(ranking.diamante)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.diamante) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(1)
                                                    .background(AngularGradient(colors: [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
   
                                            }
                                            
                                        }
                                        
                                    }.listRowBackground(usuario == ranking.name ? Color("yellowLight") : Color("filas"))
     
                                }
                            }
                            
                        }.onAppear {
                            viewModel.getRanking()

                        }
                    }.navigationTitle("Ranking 🚀")
                    
                
                
            }
   
        }
        
        
    }

}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
