//
//  MainView.swift
//  WeatherApp
//
//  Created by Yoseph Feseha on 3/4/23.
//

import SwiftUI

struct MainView: View {
    @State private var isPresentingWeatherView = false
    
    var body: some View {
        VStack {
            Image("chase ")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
            
            VStack {
                Text("Weather App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("iOS Assessment\nby\nYoseph Feseha")
                    .font(.title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
                
            }
            
            
            Spacer()
            
            Button( "Start", action: {
                isPresentingWeatherView = true
                
                
            })
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(10)
            
            Spacer()
            
            Text("@trademark by chase")
                .font(.footnote)
        }
        .padding()
        .fullScreenCover(isPresented: $isPresentingWeatherView, content: {
            WeatherView()
        })
    }
}

struct WeatherView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WeatherViewController {
        let weatherVC = WeatherViewController()
        return weatherVC
    }
    
    func updateUIViewController(_ uiViewController: WeatherViewController, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
