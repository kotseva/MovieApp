//
//  ContentView.swift
//  MovieApp
//
//  Created by Angela Koceva on 15.5.25.
//

import SwiftUI

struct ContentView: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        //
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let tabBarController = HomeTabBarController(viewContext)
        let navController = UINavigationController(rootViewController: tabBarController)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
}

#Preview {
    ContentView()
}
