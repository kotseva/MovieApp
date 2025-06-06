//
//  ContentView.swift
//  MovieApp
//
//  Created by Angela Koceva on 15.5.25.
//

import SwiftUI

struct ContentView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        let tabBarController = HomeTabBarController()
        let navController = UINavigationController(
            rootViewController: tabBarController
        )
        navController.setNavigationBarHidden(true, animated: false)
        navController.overrideUserInterfaceStyle = .light
        navController.delegate = context.coordinator
        
        return navController
    }

    func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UINavigationControllerDelegate {
        func navigationController(
            _ navigationController: UINavigationController,
            willShow viewController: UIViewController,
            animated: Bool
        ) {

            let shouldHide = viewController is HomeTabBarController
            navigationController.setNavigationBarHidden(
                shouldHide,
                animated: animated
            )
        }
    }
}

#Preview {
    ContentView()
}
