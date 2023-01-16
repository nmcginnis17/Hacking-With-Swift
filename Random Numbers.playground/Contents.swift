import GameplayKit
import UIKit


let int1 = Int.random(in: 0...10)
let int2 = Int.random(in: 0..<10)
let double1 = Double.random(in: 1000...10000)
let double2 = Double.random(in: -100...100)

func randonInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

// GameplayKit Random
/// Randome number from -2,147,483,648 to 2,147,483,647
print(GKRandomSource.sharedRandom().nextInt())

/// Random number from 0 to 5
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))

/// Random true or false
print(GKRandomSource.sharedRandom().nextBool())

/// Random floating-point number between 0 and 1
print(GKRandomSource.sharedRandom().nextUniform())

/// GKLinearCongruentialRandomSource - high performanacebut slowest
/// GKMersenneTwisterRandomSource - high randomness but lowest performance
/// GKARC4RandomSource - good randomness and good performance

// Generate a number between 0 and 19
let arc4 = GKARC4RandomSource()
arc4.nextInt(upperBound: 20)

// maximum possible randomness using Mersenne Twister
let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

// force flush ARC4 values
arc4.dropValues(1024)

// 6 sided dice
let d6 = GKRandomDistribution.d6()
d6.nextInt()
let dice6 = GKRandomDistribution(forDieWithSideCount: 6)
dice6.nextInt()

// 20 sided dice
let d20 = GKRandomDistribution.d20()
d20.nextInt()
let dice20 = GKRandomDistribution(forDieWithSideCount: 20)
dice20.nextInt()

// 11,539 sided dice?
let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
crazy.nextInt()
let crazy2 = GKRandomDistribution(forDieWithSideCount: 11539)
crazy2.nextInt()

