//: Playground - noun: a place where people can play

import GameplayKit
import UIKit

print(arc4random())
print(arc4random())
print(arc4random())
print(arc4random())

print(arc4random() % 6)
print(arc4random_uniform(6))

func RandomInt(min: Int, max: Int) -> Int {
	if max < min { return min }
	return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

print(RandomInt(min: 0, max: 6))

print(GKRandomSource.sharedRandom().nextInt())
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))

let arc4 = GKARC4RandomSource()
arc4.dropValues(1024)
arc4.nextInt(upperBound: 20)

let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)


let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d20 = GKRandomDistribution.d20()
d20.nextInt()

let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
crazy.nextInt()

// the below will cause a crash because we request a random number outside the range!
//let distribution = GKRandomDistribution(lowestValue: 10, highestValue: 20)
//print(distribution.nextInt(upperBound: 9))


let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())


let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())



extension Array {
	mutating func shuffle() {
		for i in 0..<(count - 1) {
			let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
		}
	}
}



let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])


let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])
