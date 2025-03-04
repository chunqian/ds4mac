//
//  GamePadIMUChangedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 15/07/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class GamepadIMUChangedNotification {

	static let Name = Notification.Name("GamePadIMUChangedNotification")

	let gyroPitch:Double
	let gyroYaw:Double
	let gyroRoll:Double
	let accelX:Double
	let accelY:Double
	let accelZ:Double

	init(
		gyroPitch:Double,
		gyroYaw:Double,
		gyroRoll:Double,
		accelX:Double,
		accelY:Double,
		accelZ:Double
	) {

		self.gyroPitch = gyroPitch
		self.gyroYaw = gyroYaw
		self.gyroRoll = gyroRoll
		self.accelX = accelX
		self.accelY = accelY
		self.accelZ = accelZ

	}

}
