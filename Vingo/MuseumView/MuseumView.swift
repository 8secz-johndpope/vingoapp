//
//  MuseumView.swift
//  HelloWorld
//
//  Created by Andrey Zhevlakov on 18.07.2020.
//

import Foundation
import SwiftUI
import UIKit
import MapKit

struct MuseumView: View {
    @EnvironmentObject var app: AppStore
    
    func openMapForPlace() {
        let lat1 : NSString = "37.2"
        let lng1 : NSString = "22.9"

        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Hermitage"
        mapItem.openInMaps(launchOptions: options)

    }


    var body: some View {
        ZStack(alignment: .center) {
            VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(app.museum.title)
                            .font(.custom("Futura", size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                            .kerning(-2.3)

                        Text(app.museum.subtitle)
                            .font(.custom("Futura", size: 25))
                            .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                            .fontWeight(.bold)
                            .kerning(-1.55)
                            .padding(.top, -12.0)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(self.app.getMuseumProgress())%")
                                 .font(.custom("Futura", size: 20))
                                 .fontWeight(.bold)
                                 .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                                 .kerning(-1)

                        Text("Explored")
                                 .font(.custom("Futura", size: 14))
                                 .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                                 .fontWeight(.bold)
                                 .kerning(-0.75)
                                 .padding(.top, -5.0)
                    }
                }

                
                Text(app.museum.description)
                    .font(.custom("PT Sans", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .fontWeight(.black)
                    .kerning(-0.86)
                    .lineSpacing(-5)
                    .padding(.top, 5.0)
                    .frame(width: UIScreen.main.bounds.width-50, height: 90)
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: { self.openMapForPlace() }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 17)
                            .background(Circle().foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1))))
                    }
                    .buttonStyle(MuseumButtonStyle())

                    NavigationLink(destination: PlaygroundView().environmentObject(self.app)) {
                        Text("Start Explore")
                            .font(.custom("Futura", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .kerning(-2.3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color(#colorLiteral(red: 0.9953433871, green: 0, blue: 0.5229544044, alpha: 1))))
                    }.buttonStyle(MuseumButtonStyle())
                }.padding(.top, 5)
            }
            .padding(.all, 20)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Achievements")
                           .font(.custom("Futura", size: 22))
                           .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                           .fontWeight(.bold)
                           .kerning(-1.55)
                    
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 120, height: 3)
                        .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                        .padding(.top, -10.0)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(self.app.getAchivFullProgress())%")
                             .font(.custom("Futura", size: 20))
                             .fontWeight(.bold)
                             .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                             .kerning(-1)

                    Text("Completed")
                             .font(.custom("Futura", size: 14))
                             .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                             .fontWeight(.bold)
                             .kerning(-0.75)
                             .padding(.top, -5.0)
                }
            }.padding(.horizontal, 20)
                
            AchievementView(achievements: self.app.museum.achievements)
                .frame(width: UIScreen.main.bounds.width)
                .offset(y: -20)
                .environmentObject(self.app)
            }
        }
    
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}
