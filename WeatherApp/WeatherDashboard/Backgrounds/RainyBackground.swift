//
//  RainyBackground.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI
import SpriteKit

struct RainyBackground: View {
    var body: some View {
        WeatherBackground(
            gradientColors: [Color.rainy1, Color.rainy2],
            lightModeAnimation: { AnyView(LightModeRainyAnimation()) },
            darkModeAnimation: { AnyView(DarkModeRainyAnimation()) }
        )
    }
}

struct LightModeRainyAnimation: View {
    var body: some View {
        ZStack {
            SpriteView(scene: createWeatherScene(cloudColor: .white), options: [.allowsTransparency])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            Image("sun")
                .resizable()
                .frame(width: 138, height: 138)
                .position(x: 80, y: 100)
        }
    }
}

struct DarkModeRainyAnimation: View {
    var body: some View {
        ZStack {
            SpriteView(scene: createWeatherScene(cloudColor: .gray), options: [.allowsTransparency])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            Image("moon")
                .resizable()
                .frame(width: 138, height: 138)
                .position(x: 80, y: 100)
        }
    }
}

func createWeatherScene(cloudColor: UIColor) -> SKScene {
    let scene = RainyWeatherScene(cloudColor: cloudColor)
    scene.size = UIScreen.main.bounds.size
    scene.scaleMode = .resizeFill
    return scene
}

final class RainyWeatherScene: SKScene {
    let cloudColor: UIColor

    init(cloudColor: UIColor) {
        self.cloudColor = cloudColor
        super.init(size: UIScreen.main.bounds.size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sceneDidLoad() {
        super.sceneDidLoad()
        backgroundColor = .clear
        anchorPoint = CGPoint(x: 0.5, y: 1.0)
        if let rainNode = SKEmitterNode(fileNamed: "RainFall.sks") {
            addChild(rainNode)
            rainNode.particlePositionRange.dx = UIScreen.main.bounds.width
        }
        if let cloudNode = SKEmitterNode(fileNamed: "Clouds.sks") {
            cloudNode.particlePositionRange.dx = UIScreen.main.bounds.width
            cloudNode.particleScale = 0.5
            cloudNode.particleScaleRange = 0.5
            cloudNode.particleScaleSpeed = -0.1
            cloudNode.particleColorSequence = nil
            cloudNode.particleColorBlendFactor = 1.0
            cloudNode.particleColor = cloudColor
            addChild(cloudNode)
        }
    }
}

#Preview {
    RainyBackground()
}
