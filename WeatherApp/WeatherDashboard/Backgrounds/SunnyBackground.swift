//
//  SunnyBackground.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI
import SpriteKit

struct SunnyBackground: View {
    var body: some View {
        WeatherBackground(
            gradientColors: [Color.sunny1, Color.sunny2],
            lightModeAnimation: { AnyView(LightModeBirdAnimation()) },
            darkModeAnimation: { AnyView(DarkModeStarAnimation()) }
        )
    }
}

struct LightModeBirdAnimation: View {
    @State private var birdPosition: CGFloat = 168
    @State private var birdPosition1: CGFloat = 118
    @State private var birdPosition2: CGFloat = 156

    var body: some View {
        ZStack {
            Image("sun")
                .resizable()
                .frame(width: 138, height: 138)
                .position(x: 80, y: 100)

            birdImage(position: $birdPosition, y: 70)
            birdImage(position: $birdPosition1, y: 90)
            birdImage(position: $birdPosition2, y: 110)
        }
    }

    private func birdImage(position: Binding<CGFloat>, y: CGFloat) -> some View {
        Image("bird1")
            .resizable()
            .frame(width: 30, height: 30)
            .position(x: position.wrappedValue, y: y)
            .onAppear {
                withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: true)) {
                    position.wrappedValue = UIScreen.main.bounds.width + 30
                }
            }
    }
}

struct DarkModeStarAnimation: View {
    var body: some View {
        ZStack {
            SpriteView(scene: StarFall(), options: [.allowsTransparency])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            Image("moon")
                .resizable()
                .frame(width: 138, height: 138)
                .position(x: 80, y: 100)
        }
    }
}

final class StarFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        createBlinkingStars(count: 120)
    }

    func createBlinkingStars(count: Int) {
        for _ in 0..<count {
            let star = SKSpriteNode(imageNamed: "starIcon")
            let position = generateRandomPosition()
            star.position = position
            let randomScale = CGFloat.random(in: 0.2...1)
            star.xScale = randomScale
            star.yScale = randomScale

            if !doesOverlap(star: star, with: self.children) {
                addChild(star)
                addBlinkingAnimation(to: star)
            }
        }
    }

    func generateRandomPosition() -> CGPoint {
        let randomX = CGFloat.random(in: -size.width / 2...size.width / 2)
        let randomY = CGFloat.random(in: -size.height...size.height)
        return CGPoint(x: randomX, y: randomY)
    }

    func doesOverlap(star: SKSpriteNode, with nodes: [SKNode]) -> Bool {
        for node in nodes where node.intersects(star) {
            return true
        }
        return false
    }

    func addBlinkingAnimation(to node: SKSpriteNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 2.0)
        let fadeIn = SKAction.fadeIn(withDuration: 2.0)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        let blinkForever = SKAction.repeatForever(blink)
        node.run(blinkForever)
    }
}

#Preview {
    SunnyBackground()
}
