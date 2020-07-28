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
            
            Text(app.museum.description)
                .font(.custom("PT Sans", size: 16))
                .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                .fontWeight(.bold)
                .kerning(-0.75)
                .lineSpacing(-5)
                .padding(.top, 5.0)
                .frame(width: UIScreen.main.bounds.width-50, height: 80)
            
            RoundedRectangle(cornerRadius: 10.0)
                .frame(width: 200, height: 5)
                .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                .padding(.top, 5.0)
            
            HStack(alignment: .center, spacing: 20) {
                Button(action: { self.openMapForPlace() }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                        .padding(.horizontal, 17)
                        .padding(.vertical, 17)
                }.background((RoundedRectangle(cornerRadius: 50).foregroundColor(.white)))

                NavigationLink(destination: PlaygroundView().environmentObject(self.app)) {
                    Text("Start Explore")
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.3101347089, green: 0.2808781564, blue: 1, alpha: 1)))
                        .kerning(-2.3)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }.background((RoundedRectangle(cornerRadius: 50).foregroundColor(.white)))
            }.padding(.top, 20).shadow(radius: 20)
            Spacer()
        }
        .padding(.all, 100)
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

struct MuseumView_Previews: PreviewProvider {
    static var previews: some View {
        MuseumView()
    }
}
