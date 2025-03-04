//
//  JoyConController.swift
//  GamePad
//
//  Created by Marco Luglio on 06/jun/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class JoyConController {

	// MARK: product ids

	static let VENDOR_ID_NINTENDO:Int64 = 0x057E // 1406

	static let CONTROLLER_ID_JOY_CON_LEFT:Int64  = 0x2006 // 8198
	static let CONTROLLER_ID_JOY_CON_RIGHT:Int64 = 0x2007 // 8199
	static let CONTROLLER_ID_SWITCH_PRO:Int64    = 0x2009 // 8201
	static let CONTROLLER_ID_CHARGING_GRIP:Int64 = 0x200e // 8206
	// 0x0306 Wii Remote Controller RVL-003
	// 0x0337 Wii U GameCube Controller Adapter

	// MARK: hid report ids

	static let INPUT_REPORT_ID_SUBCOMMNAD_REPLY:UInt8 = 0x21 // 33 // Reply to hid output report with subcommand
	static let INPUT_REPORT_ID_BUTTONS:UInt8 = 0x3F // 63 // Simple HID mode. Pushes updates with every button press. Thumbstick is 8 directions only
	static let INPUT_REPORT_ID_BUTTONS_GYRO:UInt8 = 0x30 // 48 // Standard full mode. Pushes current state @60Hz
	static let INPUT_REPORT_ID_BUTTONS_GYRO_NFC_IR:UInt8 = 0x31 // 49 // near field communication reader and infra red camera mode. Pushes large packets @60Hz. Has all zeroes for IR/NFC data if a 11 output report with subcmd 03 00/01/02/03 was not sent before.

	static let OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE:UInt8 = 0x01 // 1
	// OUTPUT 0x03 NFC/IR MCU FW Update packet. // I'm not using this here
	static let OUTPUT_REPORT_ID_RUMBLE:UInt8 = 0x10 // 16
	static let OUTPUT_REPORT_ID_NFC_IR:UInt8 = 0x11 // 17 // Request specific data from the NFC/IR MCU. Can also send rumble. Send with subcmd 03 00/01/02/03??

	// MARK: hid output subreport ids

	static let OUTPUT_REPORT_SUB_ID_SET_INPUT_REPORT_ID:UInt8 = 0x03 // 3

	static let OUTPUT_REPORT_SUB_ID_SPI_FLASH_READ:UInt8  = 0x10 // 16
	static let OUTPUT_REPORT_SUB_ID_SPI_FLASH_WRITE:UInt8 = 0x11 // 17

	// static const u8 JC_SUBCMD_RESET_MCU		= 0x20; // 32
	// static const u8 JC_SUBCMD_SET_MCU_CONFIG	= 0x21; // 33

	static let OUTPUT_REPORT_SUB_ID_TOGGLE_IR_NFC:UInt8       = 0x22 // 34 // Takes one argument:	00 Suspend, 01 Resume, 02 Resume for update

	static let OUTPUT_REPORT_SUB_ID_SET_PLAYER_LIGHTS:UInt8   = 0x30 // 48
	static let OUTPUT_REPORT_SUB_ID_GET_PLAYER_LIGHTS:UInt8   = 0x31 // 49
	static let OUTPUT_REPORT_SUB_ID_SET_HOME_LIGHT:UInt8      = 0x38 // 56

	static let OUTPUT_REPORT_SUB_ID_TOGGLE_IMU:UInt8          = 0x40 // 64
	static let OUTPUT_REPORT_SUB_ID_IMU_SETTINGS:UInt8        = 0x41 // 65
	// 0x42 is write to IMU registers, 0x43 is read from IMU registers. But to read/write calibration data we use the SPI subcommands 0x10 and 0x11
	// static const u8 JC_SUBCMD_WRITE_IMU_REG		= 0x42; // 66
	// static const u8 JC_SUBCMD_READ_IMU_REG		= 0x43; // 67

	static let OUTPUT_REPORT_SUB_ID_TOGGLE_VIBRATION:UInt8    = 0x48 // 72

	static let OUTPUT_REPORT_SUB_ID_BATTERY_VOLTAGE:UInt8     = 0x50 // 80

	// MARK: spi calibration data addresses

	static let IMU_USER_CALIBRATION_FLAG_SPI_ADDRESS:UInt16   = 0x8026; // size 2?
	static let IMU_USER_CALIBRATION_VALUES_SPI_ADDRESS:UInt16 = 0x8028; // size 12?
	static let IMU_FACTORY_CALIBRATION_SPI_ADDRESS:UInt16     = 0x6020; // size 12

	static let LEFT_STICK_USER_CALIBRATION_FLAG_SPI_ADDRESS:UInt16   = 0x8010; // size 2?
	static let LEFT_STICK_USER_CALIBRATION_VALUES_SPI_ADDRESS:UInt16 = 0x8012; // size 6?
	static let LEFT_STICK_FACTORY_CALIBRATION_SPI_ADDRESS:UInt16     = 0x603D; // size 6

	static let RIGHT_STICK_USER_CALIBRATION_FLAG_SPI_ADDRESS:UInt16   = 0x801B; // size 2?
	static let RIGHT_STICK_USER_CALIBRATION_VALUES_SPI_ADDRESS:UInt16 = 0x801D; // size 6
	static let RIGHT_STICK_FACTORY_CALIBRATION_SPI_ADDRESS:UInt16     = 0x6046; // size 6

	/*
	// The raw analog joystick values will be mapped in terms of this magnitude
	static const u16 JC_MAX_STICK_MAG		= 32767;
	static const u16 JC_STICK_FUZZ			= 250;
	static const u16 JC_STICK_FLAT			= 500;

	// Hat values for pro controller's d-pad
	static const u16 JC_MAX_DPAD_MAG		= 1;
	static const u16 JC_DPAD_FUZZ			/*= 0*/;
	static const u16 JC_DPAD_FLAT			/*= 0*/;

	// The accel axes will be mapped in terms of this magnitude
	static const u16 JC_MAX_ACCEL_MAG		= 32767;
	static const u16 JC_ACCEL_RES			= 4096;
	static const u16 JC_ACCEL_FUZZ			= 10;
	static const u16 JC_ACCEL_FLAT			/*= 0*/;

	// The gyro axes will be mapped in terms of this magnitude
	static const u16 JC_MAX_GYRO_MAG		= 32767;
	static const u16 JC_GYRO_RES			= 13371 / 936; /* 14 (14.285) */
	static const u16 JC_GYRO_FUZZ			= 10;
	static const u16 JC_GYRO_FLAT			/*= 0*/;
	*/

	// MARK: Misc static fields

	static let MAX_STICK = 4096 // 2¹² or 2 ^ 12

	static var outputReportIterator:UInt8 = 0

	static var nextId:UInt8 = 0

	// TODO separate these fields into left and right joy-cons?

	var id:UInt8 = 0

	var productID:Int64 = 0
	var transport:String = ""

	var isBluetooth = false

	// MARK: - left joy-con

	var leftDevice:IOHIDDevice? = nil

	/// contains dpad and left side buttons
	var leftMainButtons:UInt8 = 0
	var previousLeftMainButtons:UInt8 = 0

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	var upButton = false
	var previousUpButton = false
	var rightButton = false
	var previousRightButton = false
	var downButton = false
	var previousDownButton = false
	var leftButton = false
	var previousLeftButton = false

	/// SL button on left joy-con
	var backLeftTopButton = false
	var previousBackLeftTopButton = false

	/// SR on left joy-con
	var backLeftBottomButton = false
	var previousBackLeftBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var leftSecondaryButtons:UInt8 = 0
	var previousLeftSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var leftShoulderButton = false
	var previousLeftShoulderButton = false
	var leftTriggerButton = false
	var previousLeftTriggerButton = false

	// other buttons

	var minusButton = false
	var previousMinusButton = false

	var captureButton = false
	var previousCaptureButton = false

	// analog buttons (thumbstick only for joy-cons)
	// notice that the simpified report only gives us 8 directions, not analog data

	var leftStickButton = false
	var previousLeftStickButton = false

	// 8 direction stick data
	var leftStick:UInt8 = 0
	var previousLeftStick:UInt8 = 0

	// analog stick data
	var leftStickX:Int16 = 0
	var previousLeftStickX:Int16 = 0
	var leftStickY:Int16 = 0
	var previousLeftStickY:Int16 = 0

	// MARK: - inertial measurement unit (imu)

	/// pitch is when the nose of a plane goes up or down
	/// think of a dolphin swimming
	var leftGyroPitch:Double = 0
	var previousLeftGyroPitch:Double = 0

	/// yaw is when the nose of a plane goes left or right
	/// think of a shark swimming
	var leftGyroYaw:Double = 0
	var previousLeftGyroYaw:Double = 0

	/// roll is when the tips of the wings of a plane go up or down
	/// think of a penguin walking
	var leftGyroRoll:Double = 0
	var previousLeftGyroRoll:Double = 0

	var leftAccelX:Double = 0
	var previousLeftAccelX:Double = 0
	var leftAccelY:Double = 0
	var previousLeftAccelY:Double = 0
	var leftAccelZ:Double = 0
	var previousLeftAccelZ:Double = 0

	// battery
	//var cableConnected = false
	var batteryLeftCharging = false
	var batteryLeftLevel:UInt16 = 0
	var previousBatteryLeftLevel:UInt16 = 0

	// misc

	// MARK: - right joy-con

	var rightDevice:IOHIDDevice? = nil

	/// contains dpad and left side buttons
	var rightMainButtons:UInt8 = 0
	var previousRightMainButtons:UInt8 = 0

	var faceButtons:UInt8 = 0
	var previousFaceButtons:UInt8 = 0

	var xButton = false
	var previousXButton = false
	var aButton = false
	var previousAButton = false
	var bButton = false
	var previousBButton = false
	var yButton = false
	var previousYButton = false

	/// SR button on right joy-con
	var backRightTopButton = false
	var previousBackRightTopButton = false

	/// SL on right joy-con
	var backRightBottomButton = false
	var previousBackRightBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var rightSecondaryButtons:UInt8 = 0
	var previousRightSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var rightShoulderButton = false
	var previousRightShoulderButton = false
	var rightTriggerButton = false
	var previousRightTriggerButton = false

	// other buttons

	var plusButton = false
	var previousPlusButton = false

	var homeButton = false
	var previousHomeButton = false

	// analog buttons (thumbstick only for joy-cons)
	// notice that the simpified report only gives us 8 directions, not analog data

	var rightStickButton = false
	var previousRightStickButton = false

	// 8 direction stick data
	var rightStick:UInt8 = 0
	var previousRightStick:UInt8 = 0

	// analog stick data
	var rightStickX:Int16 = 0
	var previousRightStickX:Int16 = 0
	var rightStickY:Int16 = 0
	var previousRightStickY:Int16 = 0

	// MARK: - inertial measurement unit (imu)

	/// pitch is when the nose of a plane goes up or down
	/// think of a dolphin swimming
	var rightGyroPitch:Int32 = 0
	var previousRightGyroPitch:Int32 = 0

	/// yaw is when the nose of a plane goes left or right
	/// think of a shark swimming
	var rightGyroYaw:Int32 = 0
	var previousRightGyroYaw:Int32 = 0

	/// roll is when the tips of the wings of a plane go up or down
	/// think of a penguin walking
	var rightGyroRoll:Int32 = 0
	var previousRightGyroRoll:Int32 = 0

	var rightAccelX:Int32 = 0
	var previousRightAccelX:Int32 = 0
	var rightAccelY:Int32 = 0
	var previousRightAccelY:Int32 = 0
	var rightAccelZ:Int32 = 0
	var previousRightAccelZ:Int32 = 0

	// battery
	var batteryRightCharging = false
	var batteryRightLevel:UInt16 = 0
	var previousBatteryRightLevel:UInt16 = 0

	// TODO
	//var cableConnected = false

	// MARK: - methods

	init(device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.id = JoyConController.nextId
		JoyConController.nextId = JoyConController.nextId + 1

		self.setDevice(device:device, productID:productID, transport:transport)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeRumble),
				name: JoyConChangeRumbleNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.setLed),
				name: JoyConChangeLedNotification.Name,
				object: nil
			)

	}

	func setDevice(device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID

		if productID == JoyConController.CONTROLLER_ID_JOY_CON_RIGHT {

			self.rightDevice = device
			IOHIDDeviceOpen(self.rightDevice!, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
			let success = self.sendReport(device: self.rightDevice!, led1On: true)

			if !success {
				print("Error setting LED")
			}

			// ?? TODO send format with 0x11, before enabling accelerometer report
			print("Enabled IMU: \(self.toggleIMU(device: self.rightDevice!, enable: true))")
			print("Enabled Vibration: \(self.toggleVibration(device: self.rightDevice!, enable: true))")
			print("Enabled IMU report: \(self.setInputReportId(device: self.rightDevice!, JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO))")

		} else { // left or pro

			self.leftDevice = device
			IOHIDDeviceOpen(self.leftDevice!, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
			let success = self.sendReport(device: self.leftDevice!, led1On: true)

			if !success {
				print("Error setting LED")
			}

			// ?? TODO send format with 0x11, before enabling accelerometer report
			print("Enabled IMU: \(self.toggleIMU(device: self.leftDevice!, enable: true))") // no report answer
			print("Enabled Vibration: \(self.toggleVibration(device: self.leftDevice!, enable: true))") // no report answer
			print("Enabled IMU report: \(self.setInputReportId(device: self.leftDevice!, JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO))") // replied with report 0x21

			print("Requested IMU calibration: \(self.getIMUCalibration(device: self.leftDevice!))") // replied with report 0x21
			print("Requested battery: \(self.getBattery(device: device))") // ??

			/*
			// Increase data rate for Bluetooth
			if (bluetooth)
			{
				memset(buf, 0x00, 0x400);
				buf[0] = 0x31; // Enabled
				joycon_send_subcommand(handle, 0x1, 0x3, buf, 1);
			}
			*/

		}

	}

	// MARK: - Input reports

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data, controllerType:Int64) {

		// report[0] // the report type

		let bluetoothOffset = self.isBluetooth ? 0 : 10

		if controllerType == JoyConController.CONTROLLER_ID_JOY_CON_LEFT {

			// MARK: left joycon input report

			if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS {

				// MARK: left joycon simple input report

				// MARK: left digital buttons

				self.leftMainButtons = report[1 + bluetoothOffset]

				// self.batteryLeftLevel = UInt16((leftMainButtons & 0b1111_0000) >> 4) // FIXME I don't think this is accurate

				self.directionalPad = leftMainButtons & 0b0000_1111

				self.upButton    = self.directionalPad & 0b0000_0100 == 0b0000_0100
				self.rightButton = self.directionalPad & 0b0000_1000 == 0b0000_1000
				self.downButton  = self.directionalPad & 0b0000_0010 == 0b0000_0010
				self.leftButton  = self.directionalPad & 0b0000_0001 == 0b0000_0001

				self.backLeftTopButton    = leftMainButtons & 0b0001_0000 == 0b0001_0000
				self.backLeftBottomButton = leftMainButtons & 0b0010_0000 == 0b0010_0000

				self.leftSecondaryButtons = report[2 + bluetoothOffset]

				self.leftShoulderButton = leftSecondaryButtons & 0b0100_0000 == 0b0100_0000
				self.leftTriggerButton  = leftSecondaryButtons & 0b1000_0000 == 0b1000_0000

				self.minusButton        = leftSecondaryButtons & 0b0000_0001 == 0b0000_0001
				self.captureButton      = leftSecondaryButtons & 0b0010_0000 == 0b0010_0000

				self.leftStickButton    = leftSecondaryButtons & 0b0000_0100 == 0b0000_0100

				if leftMainButtons != self.previousLeftMainButtons
					|| leftSecondaryButtons != self.previousLeftSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								backLeftTopButton: self.backLeftTopButton,
								backLeftBottomButton: self.backLeftBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								centralButton: false,
								trackPadButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								backRightBottomButton: self.backRightBottomButton,
								backRightTopButton: self.backRightTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousLeftMainButtons = self.leftMainButtons

					self.previousDirectionalPad = self.directionalPad

					self.previousUpButton = self.upButton
					self.previousRightButton = self.rightButton
					self.previousDownButton = self.downButton
					self.previousLeftButton = self.leftButton

					self.previousBackLeftTopButton = self.backLeftTopButton
					self.previousBackLeftBottomButton = self.backLeftBottomButton

					self.previousLeftSecondaryButtons = self.leftSecondaryButtons

					self.previousLeftShoulderButton = self.leftShoulderButton
					self.previousLeftTriggerButton = self.leftTriggerButton

					self.previousMinusButton = self.minusButton
					self.previousCaptureButton = self.captureButton

					self.previousLeftStickButton = self.leftStickButton

				}

				self.leftStick = report[3 + bluetoothOffset]

				// MARK: left analog buttons
				// origin left top for compatibility with other controllers

				if self.leftStick        == JoyConLeftDirection.right.rawValue || self.leftStick == JoyConLeftDirection.rightUp.rawValue || self.leftStick == JoyConLeftDirection.rightDown.rawValue {
					self.leftStickX = 1
				} else if self.leftStick == JoyConLeftDirection.left.rawValue  || self.leftStick == JoyConLeftDirection.leftUp.rawValue  || self.leftStick == JoyConLeftDirection.leftDown.rawValue {
					self.leftStickX = -1
				} else {
					self.leftStickX = 0
				}

				if self.leftStick        == JoyConLeftDirection.down.rawValue || self.leftStick == JoyConLeftDirection.leftDown.rawValue || self.leftStick == JoyConLeftDirection.rightDown.rawValue {
					self.leftStickY = 1
				} else if self.leftStick == JoyConLeftDirection.up.rawValue   || self.leftStick == JoyConLeftDirection.leftUp.rawValue   || self.leftStick == JoyConLeftDirection.rightUp.rawValue {
					self.leftStickY = -1
				} else {
					self.leftStickY = 0
				}

				if self.previousLeftStickX != self.leftStickX
					|| self.previousLeftStickY != self.leftStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: 2,
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousLeftStickX = self.leftStickX
					self.previousLeftStickY = self.leftStickY

				}

			} else if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO {

				// MARK: left joycon gyro input report

				// print(report[1]) // increments in 3
				// print(report[2]) // 0x8E 142

				// MARK: left digital buttons

				// report[3] is only used by right joy-con

				self.leftMainButtons = report[5 + bluetoothOffset] // TODO not sure about bluetooth offset for tihs report

				self.directionalPad = leftMainButtons & 0b0000_1111

				self.upButton    = self.directionalPad & 0b0000_0010 == 0b0000_0010
				self.rightButton = self.directionalPad & 0b0000_0100 == 0b0000_0100
				self.downButton  = self.directionalPad & 0b0000_0001 == 0b0000_0001
				self.leftButton  = self.directionalPad & 0b0000_1000 == 0b0000_1000

				self.backLeftTopButton    = leftMainButtons & 0b0010_0000 == 0b0010_0000
				self.backLeftBottomButton = leftMainButtons & 0b0001_0000 == 0b0001_0000

				self.leftShoulderButton = leftMainButtons & 0b0100_0000 == 0b0100_0000
				self.leftTriggerButton  = leftMainButtons & 0b1000_0000 == 0b1000_0000

				self.minusButton     = self.leftSecondaryButtons & 0b0000_0001 == 0b0000_0001
				self.leftStickButton = self.leftSecondaryButtons & 0b0000_1000 == 0b0000_1000
				self.captureButton   = self.leftSecondaryButtons & 0b0010_0000 == 0b0010_0000

				if leftMainButtons != self.previousLeftMainButtons
					|| leftSecondaryButtons != self.previousLeftSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								backLeftTopButton: self.backLeftTopButton,
								backLeftBottomButton: self.backLeftBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								centralButton: false,
								trackPadButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								backRightBottomButton: self.backRightBottomButton,
								backRightTopButton: self.backRightTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousLeftMainButtons = self.leftMainButtons

					self.previousDirectionalPad = self.directionalPad

					self.previousUpButton = self.upButton
					self.previousRightButton = self.rightButton
					self.previousDownButton = self.downButton
					self.previousLeftButton = self.leftButton

					self.previousBackLeftTopButton = self.backLeftTopButton
					self.previousBackLeftBottomButton = self.backLeftBottomButton

					self.previousLeftSecondaryButtons = self.leftSecondaryButtons

					self.previousLeftShoulderButton = self.leftShoulderButton
					self.previousLeftTriggerButton = self.leftTriggerButton

					self.previousMinusButton = self.minusButton
					self.previousCaptureButton = self.captureButton

					self.previousLeftStickButton = self.leftStickButton

				}

				// print("report[9]:  \(report[9])")  // always 0!?
				// print("report[10]: \(report[10])") // always 0!?
				// print("report[11]: \(report[11])") // always 0!?

				// print("report[12]: \(report[12])") // always 192!?

				// MARK: left analog buttons

				// FIXME review this. Test conversion with UInt and Int with sign bytes

				// integers in little endian format
				// bigger numbers (most significant bytes - msb) stored on bigger memory addresses
				// 384 is stored as 128 256 or 0b1000_0000 0b0000_0001
				// conversion to 32 bits must either go through 16 bits
				// Int32(  Int16(byteArray[1])  << 8 | Int16(byteArray[0])  )
				// or discard the sign bit of all bytes except the most significant one (untested)
				// (  Int32(byteArray[1])  << 8 | Int32(byteArray[0])  ) & 0b1111_1111_0111_1111

				// big endian would be more intuitive IMHO, but are not used here
				// for completeness
				// bigger numbers (most significant bytes - msb) stored on smaller memory addresses
				// 384 is stored as 256 128 or 0b0000_0001 0b1000_0000
				// conversion to 32 bits must either go through 16 bits
				// Int32(  Int16(byteArray[0])  << 8 | Int16(byteArray[1])  )
				// or discard the sign bit of all bytes except the most significant one (untested)
				// (  Int32(byteArray[0])  << 8 | Int32(byteArray[1])  ) & 0b1111_1111_0111_1111

				// TODO calibrate
				self.leftStickX = Int16(report[7] & 0b0000_1111) << 8 | Int16(report[6]) // 12 bits actually
				self.leftStickY = Int16(report[8]) << 4 | Int16(report[7]) >> 4 // 12 bits actually

				if self.previousLeftStickX != self.leftStickX
					|| self.previousLeftStickY != self.leftStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: UInt16(JoyConController.MAX_STICK), // 12 bits
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousLeftStickX = self.leftStickX
					self.previousLeftStickY = self.leftStickY

				}

				// MARK: left inertial movement unit (imu)

				// TODO x, y, z, pitch, yaw, and roll will depend upon the joy-con being used vertically in pair, or horizontally as standalone, debug this later

				// The controller sends the sensor data 3 times with a little bit different values
				// report IDs x30, x31, x32, x33
				// 6-Axis data. 3 frames of 2 groups of 3 Int16LE each. Group is Acc followed by Gyro.
				// 13-21 group 1
				// 25-36 group 2
				// 37-48 group 3

				// here I'm just getting 1 sample, maybe I should average the values? Or send a notification for each?

				// ?? accelerometer data is in m/s²
				var rawLeftAccelX = Int32(report[14 + bluetoothOffset]) << 8 | Int32(report[13 + bluetoothOffset]) // TODO calibrate
				var rawLeftAccelY = Int32(report[16 + bluetoothOffset]) << 8 | Int32(report[15 + bluetoothOffset]) // TODO calibrate
				var rawLeftAccelZ = Int32(report[18 + bluetoothOffset]) << 8 | Int32(report[17 + bluetoothOffset]) // TODO calibrate

				// ?? gyroscope data is in rad/s
                // self.leftGyroPitch = Int32(report[20 + bluetoothOffset]) << 8 | Int32(report[19 + bluetoothOffset]) // TODO calibrate
                // self.leftGyroYaw   = Int32(report[22 + bluetoothOffset]) << 8 | Int32(report[21 + bluetoothOffset]) // TODO calibrate
                // self.leftGyroRoll  = Int32(report[24 + bluetoothOffset]) << 8 | Int32(report[23 + bluetoothOffset]) // TODO calibrate

				/*
				jc->accel.x = (float)(uint16_to_int16(packet[13] | (packet[14] << 8) & 0xFF00)) * jc->acc_cal_coeff[0];
				jc->gyro.roll	= (float)((uint16_to_int16(packet[19] | (packet[20] << 8) & 0xFF00)) - jc->sensor_cal[1][0]) * jc->gyro_cal_coeff[0];

				// offsets:
				{
					jc->setGyroOffsets();

					jc->gyro.roll	-= jc->gyro.offset.roll;
					jc->gyro.pitch	-= jc->gyro.offset.pitch;
					jc->gyro.yaw	-= jc->gyro.offset.yaw;

					//tracker.counter1++;
					//if (tracker.counter1 > 10) {
					//	tracker.counter1 = 0;
					//	printf("%.3f %.3f %.3f\n", abs(jc->gyro.roll), abs(jc->gyro.pitch), abs(jc->gyro.yaw));
					//}
				}
				*/

				if self.previousLeftGyroPitch != self.leftGyroPitch
					|| self.previousLeftGyroYaw != self.leftGyroYaw
					|| self.previousLeftGyroRoll != self.leftGyroRoll
					|| self.previousLeftAccelX != self.leftAccelX
					|| self.previousLeftAccelY != self.leftAccelY
					|| self.previousLeftAccelZ != self.leftAccelZ
				{

					self.previousLeftGyroPitch = self.leftGyroPitch
					self.previousLeftGyroYaw   = self.leftGyroYaw
					self.previousLeftGyroRoll  = self.leftGyroRoll

					self.previousLeftAccelX = self.leftAccelX
					self.previousLeftAccelY = self.leftAccelY
					self.previousLeftAccelZ = self.leftAccelZ

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadIMUChangedNotification.Name,
							object: GamepadIMUChangedNotification(
								gyroPitch: self.leftGyroPitch,
								gyroYaw:   self.leftGyroYaw,
								gyroRoll:  self.leftGyroRoll,
								accelX: self.leftAccelX,
								accelY: self.leftAccelY,
								accelZ: self.leftAccelZ
							)
						)
					}

				}

				/*
				12 	x70, xC0, xB0 	Vibrator input report. Decides if next vibration pattern should be sent.
				13 (report ID x21) 	x00, x80, x90, x82 	ACK byte for subcmd reply. ACK: MSB is 1, NACK: MSB is 0. If reply is ACK and has data, byte12 & 0x7F gives as the type of data. If simple ACK or NACK, the data type portion is x00
				14 (report ID x21) 	x02, x10, x03 	Reply-to subcommand ID. The subcommand ID is used as-is.
				15-49 (report ID x21) 	-- 	Subcommand reply data. Max 35 bytes (excludes 2 byte subcmd ack above).
				13-49 (report ID x23) 	-- 	NFC/IR MCU FW update input report. Max 37 bytes.

				49-361 (report ID x31) 	-- 	NFC/IR data input report. Max 313 bytes.
				*/

				/*
				// all zeroes
				print("report[25]: \(report[25])")
				print("report[26]: \(report[26])")
				print("report[27]: \(report[27])")
				print("report[28]: \(report[28])")
				print("report[29]: \(report[29])")

				print("report[30]: \(report[30])")
				print("report[31]: \(report[31])")
				print("report[32]: \(report[32])")
				print("report[33]: \(report[33])")
				print("report[34]: \(report[34])")
				print("report[35]: \(report[35])")
				print("report[36]: \(report[36])")
				print("report[37]: \(report[37])")
				print("report[38]: \(report[38])")
				print("report[39]: \(report[39])")

				print("report[40]: \(report[40])")
				print("report[41]: \(report[41])")
				print("report[42]: \(report[42])")
				print("report[43]: \(report[43])")
				print("report[44]: \(report[44])")
				print("report[45]: \(report[45])")
				print("report[46]: \(report[46])")
				print("report[47]: \(report[47])")
				print("report[48]: \(report[48])")
				*/

			} else if report[0] == JoyConController.INPUT_REPORT_ID_SUBCOMMNAD_REPLY {

				/*
				spi serial pehipheral interface
				Subcommand 0x10: SPI flash read

				Little-endian int32 address, int8 size, max size is x1D. Replies with x9010 ack and echoes the request info, followed by size bytes of data.

				Request:
				[01 .. .. .. .. .. .. .. .. .. 10 80 60 00 00 18]
											   ^ subcommand
												  ^~~~~~~~~~~ address x6080
															  ^ length = 0x18 bytes
				Response: INPUT 21
				[xx .E .. .. .. .. .. .. .. .. .. .. 0. 90 80 60 00 00 18 .. .. .. ....]
														^ subcommand reply
															  ^~~~~~~~~~~ address
																	   ^ length = 0x18 bytes
																		  ^~~~~ data

				Subcommand 0x11: SPI flash Write

				Little-endian int32 address, int8 size. Max size x1D data to write. Replies with x8011 ack and a uint8 status. x00 = success, x01 = write protected.
				*/

				if report[13] & 0b1000_0000 != 0b1000_0000 {
					print("output report not acknowledged")
					return
				}

				if report[13] == 0x90 && report[14] == 0x10 {

					print("read spi report")

					let spiAddress = UInt16(report[15]) | (UInt16(report[16]) << 8) // | (UInt32(report[17]) << 16) | (UInt32(report[18]) << 24) // none of the addresses I use exceeed 16 bits

					switch spiAddress {

					case JoyConController.IMU_USER_CALIBRATION_FLAG_SPI_ADDRESS:
						// TODO check flag and request user or factory report
						break

					case JoyConController.IMU_USER_CALIBRATION_VALUES_SPI_ADDRESS:
						break

					case JoyConController.IMU_FACTORY_CALIBRATION_SPI_ADDRESS:
						self.parseIMUCalibration(report: report)
						break

					case JoyConController.LEFT_STICK_USER_CALIBRATION_FLAG_SPI_ADDRESS:
						// TODO check flag and request user or factory report
						break

					case JoyConController.LEFT_STICK_USER_CALIBRATION_VALUES_SPI_ADDRESS:
						break

					case JoyConController.LEFT_STICK_FACTORY_CALIBRATION_SPI_ADDRESS:
						self.parseStickCalibration(report: report)
						break

					case JoyConController.RIGHT_STICK_USER_CALIBRATION_FLAG_SPI_ADDRESS:
						// TODO check flag and request user or factory report
						break

					case JoyConController.RIGHT_STICK_USER_CALIBRATION_VALUES_SPI_ADDRESS:
						break

					case JoyConController.RIGHT_STICK_FACTORY_CALIBRATION_SPI_ADDRESS:
						self.parseStickCalibration(report: report)
						break

					default:
						print("Unknown 0x21 reply report")
						print("report[13]: 0x\(String(report[13], radix: 16)) \(report[13])")
						print("report[14]: 0x\(String(report[14], radix: 16)) \(report[14])")
						return

					}

				} else if report[13] == 0xD0 && report[14] == 0x50 {

					self.batteryLeftLevel = UInt16(report[16]) << 8 | UInt16(report[15]) // Internally, the values come from 1000mV - 1800mV regulated voltage samples, that are translated to 1320-1680 values.
					print("\nleft battery: \(self.batteryLeftLevel)")

					if self.previousBatteryLeftLevel != self.batteryLeftLevel {

						self.previousBatteryLeftLevel = self.batteryLeftLevel

						let battery = (Float64(self.batteryLeftLevel) * 256.0) / 360

						DispatchQueue.main.async {
							NotificationCenter.default.post(
								name: GamepadBatteryChangedNotification.Name,
								object: GamepadBatteryChangedNotification(
									battery: UInt8(battery),
									batteryMin: 0,
									batteryMax: 255,
									isConnected: false, // TODO
									isCharging: false // TODO
								)
							)
						}

					}

					return

				}

				print("\nreport 0x21 size: \(report.count)")

				// address, compare with what I sent
				print("report[1]: 0x\(String(report[1], radix: 16)) \(report[1])")
				print("report[2]: 0x\(String(report[2], radix: 16)) \(report[2])")
				print("report[3]: 0x\(String(report[3], radix: 16)) \(report[3])")
				print("report[4]: 0x\(String(report[4], radix: 16)) \(report[4])")

				print("report[5]: 0x\(String(report[5], radix: 16)) \(report[5])") // zero for left imu factory

				// data
				print("report[6]: 0x\(String(report[6], radix: 16)) \(report[6])")
				print("report[7]: 0x\(String(report[7], radix: 16)) \(report[7])")
				print("report[8]: 0x\(String(report[8], radix: 16)) \(report[8])")
				print("report[9]: 0x\(String(report[9], radix: 16)) \(report[9])") // zero

				// all zeroes for left imu factory
				print("report[10]: 0x\(String(report[10], radix: 16)) \(report[10])")
				print("report[11]: 0x\(String(report[11], radix: 16)) \(report[11])")

				// 13 would be the subcommand reply, then 32 bits address, then length of data

				// data
				print("report[12]: 0x\(String(report[12], radix: 16)) \(report[12])")
				print("report[13]: 0x\(String(report[13], radix: 16)) \(report[13])")
				print("report[14]: 0x\(String(report[14], radix: 16)) \(report[14])")

				// all zeroes for left imu factory
				print("report[15]: 0x\(String(report[15], radix: 16)) \(report[15])")
				print("report[16]: 0x\(String(report[16], radix: 16)) \(report[16])")
				print("report[17]: 0x\(String(report[17], radix: 16)) \(report[17])")
				print("report[18]: 0x\(String(report[18], radix: 16)) \(report[18])")
				print("report[19]: 0x\(String(report[19], radix: 16)) \(report[19])")

				print("report[20]: 0x\(String(report[20], radix: 16)) \(report[20])")
				print("report[21]: 0x\(String(report[21], radix: 16)) \(report[21])")
				print("report[22]: 0x\(String(report[22], radix: 16)) \(report[22])")
				print("report[23]: 0x\(String(report[23], radix: 16)) \(report[23])")
				print("report[24]: 0x\(String(report[24], radix: 16)) \(report[24])")
				print("report[25]: 0x\(String(report[25], radix: 16)) \(report[25])")
				print("report[26]: 0x\(String(report[26], radix: 16)) \(report[26])")
				print("report[27]: 0x\(String(report[27], radix: 16)) \(report[27])")
				print("report[28]: 0x\(String(report[28], radix: 16)) \(report[28])")
				print("report[29]: 0x\(String(report[29], radix: 16)) \(report[29])")

				print("report[30]: 0x\(String(report[30], radix: 16)) \(report[30])")
				print("report[31]: 0x\(String(report[31], radix: 16)) \(report[31])")
				print("report[32]: 0x\(String(report[32], radix: 16)) \(report[32])")
				print("report[33]: 0x\(String(report[33], radix: 16)) \(report[33])")
				print("report[34]: 0x\(String(report[34], radix: 16)) \(report[34])")
				print("report[35]: 0x\(String(report[35], radix: 16)) \(report[35])")
				print("report[36]: 0x\(String(report[36], radix: 16)) \(report[36])")
				print("report[37]: 0x\(String(report[37], radix: 16)) \(report[37])")
				print("report[38]: 0x\(String(report[38], radix: 16)) \(report[38])")
				print("report[39]: 0x\(String(report[39], radix: 16)) \(report[39])")

				print("report[40]: 0x\(String(report[40], radix: 16)) \(report[40])")
				print("report[41]: 0x\(String(report[41], radix: 16)) \(report[41])")
				print("report[42]: 0x\(String(report[42], radix: 16)) \(report[42])")
				print("report[43]: 0x\(String(report[43], radix: 16)) \(report[43])")
				print("report[44]: 0x\(String(report[44], radix: 16)) \(report[44])")
				print("report[45]: 0x\(String(report[45], radix: 16)) \(report[45])")
				print("report[46]: 0x\(String(report[46], radix: 16)) \(report[46])")
				print("report[47]: 0x\(String(report[47], radix: 16)) \(report[47])")
				print("report[48]: 0x\(String(report[48], radix: 16)) \(report[48])")

			} else if report.count > 0 {

				// input 21 is a response for spi subcommands apparently, treat that here
				print("unsupported report: \(report[0]) 0x\(String(report[0], radix:16))")

			}

		} else if controllerType == JoyConController.CONTROLLER_ID_JOY_CON_RIGHT {


			// MARK: right joycon input report

			if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS {

				// MARK: right joycon simple input report

				// MARK: right digital buttons

				self.rightMainButtons = report[1 + bluetoothOffset]

				// self.batteryRightLevel = UInt16((rightMainButtons & 0b1111_0000) >> 4) // FIXME I don't think this is accurate

				self.faceButtons = rightMainButtons & 0b0000_1111

				self.xButton = self.faceButtons & 0b0000_0010 == 0b0000_0010
				self.aButton = self.faceButtons & 0b0000_0001 == 0b0000_0001
				self.bButton = self.faceButtons & 0b0000_0100 == 0b0000_0100
				self.yButton = self.faceButtons & 0b0000_1000 == 0b0000_1000

				self.backRightTopButton    = rightMainButtons & 0b0010_0000 == 0b0010_0000
				self.backRightBottomButton = rightMainButtons & 0b0001_0000 == 0b0001_0000

				self.rightSecondaryButtons = report[2 + bluetoothOffset]

				self.rightShoulderButton = rightSecondaryButtons & 0b0100_0000 == 0b0100_0000
				self.rightTriggerButton  = rightSecondaryButtons & 0b1000_0000 == 0b1000_0000

				//print(String(rightSecondaryButtons, radix: 2))

				self.plusButton          = rightSecondaryButtons & 0b0000_0010 == 0b0000_0010
				self.homeButton          = rightSecondaryButtons & 0b0001_0000 == 0b0001_0000

				self.rightStickButton    = rightSecondaryButtons & 0b0000_1000 == 0b0000_1000

				if rightMainButtons != self.previousRightMainButtons
					|| rightSecondaryButtons != self.previousRightSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								backLeftTopButton: self.backLeftTopButton,
								backLeftBottomButton: self.backLeftBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								centralButton: false,
								trackPadButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								backRightBottomButton: self.backRightBottomButton,
								backRightTopButton: self.backRightTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousRightMainButtons = self.rightMainButtons

					self.previousFaceButtons = self.faceButtons

					self.previousXButton = self.xButton
					self.previousAButton = self.aButton
					self.previousBButton = self.bButton
					self.previousYButton = self.yButton

					self.previousBackRightTopButton = self.backRightTopButton
					self.previousBackRightBottomButton = self.backRightBottomButton

					self.previousRightSecondaryButtons = self.rightSecondaryButtons

					self.previousRightShoulderButton = self.rightShoulderButton
					self.previousRightTriggerButton = self.rightTriggerButton

					self.previousPlusButton = self.plusButton
					self.previousHomeButton = self.homeButton

					self.previousRightStickButton = self.rightStickButton

				}

				self.rightStick = report[3 + bluetoothOffset]

				// MARK: right analog buttons
				// origin left top for compatibility with other controllers

				if self.rightStick        == JoyConRightDirection.right.rawValue || self.rightStick == JoyConRightDirection.rightUp.rawValue || self.rightStick == JoyConRightDirection.rightDown.rawValue {
					self.rightStickX = 1
				} else if self.rightStick == JoyConRightDirection.left.rawValue  || self.rightStick == JoyConRightDirection.leftUp.rawValue  || self.rightStick == JoyConRightDirection.leftDown.rawValue {
					self.rightStickX = -1
				} else {
					self.rightStickX = 0
				}

				if self.rightStick        == JoyConRightDirection.down.rawValue || self.rightStick == JoyConRightDirection.leftDown.rawValue || self.rightStick == JoyConRightDirection.rightDown.rawValue {
					self.rightStickY = 1
				} else if self.rightStick == JoyConRightDirection.up.rawValue   || self.rightStick == JoyConRightDirection.leftUp.rawValue   || self.rightStick == JoyConRightDirection.rightUp.rawValue {
					self.rightStickY = -1
				} else {
					self.rightStickY = 0
				}

				if self.previousRightStickX != self.rightStickX
					|| self.previousRightStickY != self.rightStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: 2,
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousRightStickX = self.rightStickX
					self.previousRightStickY = self.rightStickY

				}

			} else if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO {

				// MARK: right joycon gyro input report

				// print(report[1]) // increments in 3 (Increments very fast. Can be used to estimate excess Bluetooth latency.)

				// print(report[2])
				/*
				2 high nibble 	0 - 9 	Battery level. 8=full, 6=medium, 4=low, 2=critical, 0=empty. LSB=Charging.
				2 low nibble 	x0, x1, xE 	Connection info. (con_info >> 1) & 3 - 3=JC, 0=Pro/ChrGrip. con_info & 1 - 1=Switch/USB powered.
				*/

				// MARK: right digital buttons

				self.rightMainButtons = report[3 + bluetoothOffset] // TODO not sure about bluetooth offset for this report

				self.faceButtons = rightMainButtons & 0b0000_1111

				// TODO check these
				self.yButton = self.faceButtons & 0b0000_0010 == 0b0000_0010
				self.xButton = self.faceButtons & 0b0000_0100 == 0b0000_0100
				self.aButton = self.faceButtons & 0b0000_0001 == 0b0000_0001
				self.bButton = self.faceButtons & 0b0000_1000 == 0b0000_1000

				self.backRightTopButton    = rightMainButtons & 0b0010_0000 == 0b0010_0000
				self.backRightBottomButton = rightMainButtons & 0b0001_0000 == 0b0001_0000

				self.rightShoulderButton = rightMainButtons & 0b0100_0000 == 0b0100_0000
				self.rightTriggerButton  = rightMainButtons & 0b1000_0000 == 0b1000_0000

				self.rightSecondaryButtons = report[4 + bluetoothOffset] // I can | with the leftSecondaryButtons to get a merged status of the buttons

				self.plusButton       = self.rightSecondaryButtons & 0b0000_0010 == 0b0000_0010
				self.rightStickButton = self.rightSecondaryButtons & 0b0000_0100 == 0b0000_0100
				self.homeButton       = self.rightSecondaryButtons & 0b0001_0000 == 0b0001_0000

				// charging grip 0b1000_0000

				// report[5] is only used by left joy-con

				if rightMainButtons != self.previousRightMainButtons
					|| rightSecondaryButtons != self.previousRightSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								backLeftTopButton: self.backLeftTopButton,
								backLeftBottomButton: self.backLeftBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								centralButton: false,
								trackPadButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								backRightBottomButton: self.backRightBottomButton,
								backRightTopButton: self.backRightTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousRightMainButtons = self.rightMainButtons

					self.previousFaceButtons = self.faceButtons

					self.previousXButton = self.xButton
					self.previousAButton = self.aButton
					self.previousBButton = self.bButton
					self.previousYButton = self.yButton

					self.previousBackRightTopButton = self.backRightTopButton
					self.previousBackRightBottomButton = self.backRightBottomButton

					self.previousRightSecondaryButtons = self.rightSecondaryButtons

					self.previousRightShoulderButton = self.rightShoulderButton
					self.previousRightTriggerButton = self.rightTriggerButton

					self.previousPlusButton = self.plusButton
					self.previousHomeButton = self.homeButton

					self.previousRightStickButton = self.rightStickButton

				}

				// print("report[9]:  \(report[9])")  // always 0!? before specifying format 94
				// print("report[10]: \(report[10])") // always 0!? before specifying format 72
				// print("report[11]: \(report[11])") // always 0!? before specifying format 111

				// print("report[12]: \(report[12])") // always 192!? before specifying format 9

				// MARK: right analog buttons

				// TODO calibrate
				self.rightStickX = Int16(report[10] & 0b0000_1111) << 8 | Int16(report[9]) // 12 bits actually
				self.rightStickY = Int16(report[11]) << 4 | Int16(report[10]) >> 4 // 12 bits actually

				if self.previousRightStickX != self.rightStickX
					|| self.previousRightStickY != self.rightStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: UInt16(JoyConController.MAX_STICK), // 12 bits
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousRightStickX = self.rightStickX
					self.previousRightStickY = self.rightStickY

				}

				/*
				print("report[0]: \(report[0])")
				print("report[1]: \(report[1])")
				print("report[2]: \(report[2])")
				print("report[3]: \(report[3])")
				print("report[4]: \(report[4])")
				print("report[5]: \(report[5])")
				print("report[6]: \(report[6])")
				print("report[7]: \(report[7])")
				print("report[8]: \(report[8])")
				print("report[9]: \(report[9])")

				print("report[10]: \(report[10])")
				print("report[11]: \(report[11])")
				print("report[12]: \(report[12])")
				print("report[13]: \(report[13])")
				print("report[14]: \(report[14])")
				print("report[15]: \(report[15])")
				print("report[16]: \(report[16])")
				print("report[17]: \(report[17])")
				print("report[18]: \(report[18])")
				print("report[19]: \(report[19])")

				print("report[20]: \(report[20])")
				print("report[21]: \(report[21])")
				print("report[22]: \(report[22])")
				print("report[23]: \(report[23])")
				print("report[24]: \(report[24])")
				print("report[25]: \(report[25])")
				print("report[26]: \(report[26])")
				print("report[27]: \(report[27])")
				print("report[28]: \(report[28])")
				print("report[29]: \(report[29])")

				print("report[30]: \(report[30])")
				print("report[31]: \(report[31])")
				print("report[32]: \(report[32])")
				print("report[33]: \(report[33])")
				print("report[34]: \(report[34])")
				print("report[35]: \(report[35])")
				print("report[36]: \(report[36])")
				print("report[37]: \(report[37])")
				print("report[38]: \(report[38])")
				print("report[39]: \(report[39])")

				print("report[40]: \(report[40])")
				print("report[41]: \(report[41])")
				print("report[42]: \(report[42])")
				print("report[43]: \(report[43])")
				print("report[44]: \(report[44])")
				print("report[45]: \(report[45])")
				print("report[46]: \(report[46])")
				print("report[47]: \(report[47])")
				print("report[48]: \(report[48])")
				*/

			} else if report[0] == JoyConController.INPUT_REPORT_ID_SUBCOMMNAD_REPLY {

				print("report 0x21 size: \(report.count)")

				// address, compare with what I sent
				print("report[1]: \(report[1])")
				print("report[2]: \(report[2])")
				print("report[3]: \(report[3])")
				print("report[4]: \(report[4])")

				// all zeroes for right imu factory
				print("report[5]: \(report[5])")
				print("report[6]: \(report[6])")
				print("report[7]: \(report[7])")
				print("report[8]: \(report[8])")
				print("report[9]: \(report[9])")

				// data
				print("report[10]: \(report[10])")
				print("report[11]: \(report[11])")
				print("report[12]: \(report[12])")
				print("report[13]: \(report[13])")
				print("report[14]: \(report[14])")

				// all zeroes for right imu factory
				print("report[15]: \(report[15])")
				print("report[16]: \(report[16])")
				print("report[17]: \(report[17])")
				print("report[18]: \(report[18])")
				print("report[19]: \(report[19])")

				print("report[20]: \(report[20])")
				print("report[21]: \(report[21])")
				print("report[22]: \(report[22])")
				print("report[23]: \(report[23])")
				print("report[24]: \(report[24])")
				print("report[25]: \(report[25])")
				print("report[26]: \(report[26])")
				print("report[27]: \(report[27])")
				print("report[28]: \(report[28])")
				print("report[29]: \(report[29])")

				print("report[30]: \(report[30])")
				print("report[31]: \(report[31])")
				print("report[32]: \(report[32])")
				print("report[33]: \(report[33])")
				print("report[34]: \(report[34])")
				print("report[35]: \(report[35])")
				print("report[36]: \(report[36])")
				print("report[37]: \(report[37])")
				print("report[38]: \(report[38])")
				print("report[39]: \(report[39])")

				print("report[40]: \(report[40])")
				print("report[41]: \(report[41])")
				print("report[42]: \(report[42])")
				print("report[43]: \(report[43])")
				print("report[44]: \(report[44])")
				print("report[45]: \(report[45])")
				print("report[46]: \(report[46])")
				print("report[47]: \(report[47])")
				print("report[48]: \(report[48])")

			} else if report.count > 0 {

				// input 21 is a response for spi subcommands apparently, treat that here
				print("unsupported report: \(report[0]) 0x\(String(report[0], radix:16))")

			}

			// TODO IR

			// TODO NFC

		}

		// 4-7 (Pro Con) 	x40 8A 4F 8A 	Left analog stick data
		// 8-11 (Pro Con) 	xD0 7E DF 7F 	Right analog stick data
		// for joy-cons this can be ignored

	}

	// MARK: - hid output report methods

	@objc func changeRumble(_ notification:Notification) {

		let o = notification.object as! JoyConChangeRumbleNotification

		/*sendRumbleReport(
			leftHeavySlowRumble: o.leftHeavySlowRumble,
			rightLightFastRumble: o.rightLightFastRumble,
			leftTriggerRumble: o.leftTriggerRumble,
			rightTriggerRumble: o.rightTriggerRumble
		)*/

	}

	@objc func setLed(_ notification:Notification) {

		let o = notification.object as! JoyConChangeLedNotification

		/*self.sendReport(
			device: self.leftDevice!, // FIXME
			led1On: o.led1On,
			led2On: o.led2On,
			led3On: o.led3On,
			led4On: o.led4On,
			blinkLed1: o.blinkLed1,
			blinkLed2: o.blinkLed2,
			blinkLed3: o.blinkLed3,
			blinkLed4: o.blinkLed4
			// TODO home led...
		)*/

	}

	func toggleVibration(device:IOHIDDevice, enable:Bool) -> Bool {

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_TOGGLE_VIBRATION

		// sub report type parameter 1
		buffer[11] = enable ? 0x01 : 0x00

		let success = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

	func getStickCalibration(device:IOHIDDevice) -> Bool {

		var success = false

		if self.leftDevice != nil {
			// TODO check for user calibration, and then choose between factory and user
			// success = self.readSpiFlash(device:device, startAddress: JoyConController.LEFT_STICK_USER_CALIBRATION_FLAG_SPI_ADDRESS, size: 2) // TODO check size
			// success = self.readSpiFlash(device:device, startAddress: JoyConController.LEFT_STICK_USER_CALIBRATION_VALUES_SPI_ADDRESS, size: 6) // TODO check size
			success = self.readSpiFlash(device:device, startAddress: JoyConController.LEFT_STICK_FACTORY_CALIBRATION_SPI_ADDRESS, size: 6)
		}

		if self.rightDevice != nil {
			// TODO check for user calibration, and then choose between factory and user
			// success = self.readSpiFlash(device:device, startAddress: JoyConController.RIGHT_STICK_USER_CALIBRATION_FLAG_SPI_ADDRESS, size: 2) // TODO check size
			// success = self.readSpiFlash(device:device, startAddress: JoyConController.RIGHT_STICK_USER_CALIBRATION_VALUES_SPI_ADDRESS, size: 6) // TODO check size
			success = self.readSpiFlash(device:device, startAddress: JoyConController.RIGHT_STICK_FACTORY_CALIBRATION_SPI_ADDRESS, size: 6)
		}

		return success

	}

	func parseStickCalibration(report:Data) { // TODO check the best way to tell if this is the left or right calibration data

		// TODO

	}

	// TODO
	func getBattery(device:IOHIDDevice) -> Bool {

		/*
		Subcommand 0x50: Get regulated voltage

		Replies with ACK xD0 x50 and a little-endian uint16. Raises when charging a Joy-Con.
		Internally, the values come from 1000mV - 1800mV regulated voltage samples, that are translated to 1320-1680 values.
		These follow a curve between 3.3V and 4.2V (tested with multimeter). So a 2.5x multiplier can get us the real battery voltage in mV.

		Based on this info, we have the following table:

		Range # 	Range 	Range in mV 	Reported battery
		x0528 - x059F 	1320 - 1439 	3300 - 3599 	2 - Critical
		x05A0 - x05DF 	1440 - 1503 	3600 - 3759 	4 - Low
		x05E0 - x0617 	1504 - 1559 	3760 - 3899 	6 - Medium
		x0618 - x0690 	1560 - 1680 	3900 - 4200 	8 - Full

		Tests showed charging stops at 1680 and the controller turns off at 1320.
		*/

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_BATTERY_VOLTAGE

		let toggleSuccess = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if toggleSuccess != kIOReturnSuccess {
			return false
		}

		return true

	}

	// MARK: - imu hid output report methods

	func toggleIMU(device:IOHIDDevice, enable:Bool) -> Bool {

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_TOGGLE_IMU

		// sub report type parameter 1
		buffer[11] = enable ? 0x01 : 0x00

		let toggleSuccess = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		/*
		Enabling IMU if it was previously disabled
		resets your configuration to Acc: 1.66 kHz (high perf), ±8G, 100 Hz Anti-aliasing filter bandwidth
		and Gyro: 208 Hz (high performance), ±2000dps..

		So I'm resetting to my own settings. That are more similar to DualShock 4
		*/

		let settingsSuccess = self.imuSettings(device:device)

		// TODO load calibration data from Serial Peripheral Interface (SPI)

		if toggleSuccess != kIOReturnSuccess && !settingsSuccess {
			return false
		}

		return true

	}

	func imuSettings(device:IOHIDDevice) -> Bool {

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_IMU_SETTINGS

		// gyro sensivity
		// 00 ±250°/s
		// 01 ±500°/s
		// 02 ±1000°/s
		// 03 ±2000°/s (default) same as DualShock4 I believe
		buffer[11] = 0x03

		// accel G range
		// 00 ±8G (default)
		// 01 ±4G
		// 02 ±2G
		// 03 ±16G
		buffer[12] = 0x02 // 2G

		// gyro sampling frequency??
		// 00 833Hz (high perf)
		// 01 208Hz (high perf, default)
		buffer[13] = 0x01

		// accel anti-aliasing filter bandwidth
		// 00 200Hz
		// 01 100Hz (default)
		buffer[14] = 0x01

		let success = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

	func getIMUCalibration(device:IOHIDDevice) -> Bool {

		var success = false

		// TODO check for user calibration, and then choose between factory and user
		// success = self.readSpiFlash(device:device, startAddress: JoyConController.IMU_USER_CALIBRATION_FLAG_SPI_ADDRESS, size: 2) // TODO check size
		// success = self.readSpiFlash(device:device, startAddress: JoyConController.IMU_USER_CALIBRATION_VALUES_SPI_ADDRESS, size: 12) // TODO check size
		success = self.readSpiFlash(device:device, startAddress: JoyConController.IMU_FACTORY_CALIBRATION_SPI_ADDRESS, size: 12) // was 10 TODO magic constant 12, give a name...

		return success

	}

	func parseIMUCalibration(report:Data) {

		// TODO

		/*
		// report type
		report[0]: 0x21 33

		// read spi ack
		report[13]: 0x90 144
		report[14]: 0x10 16

		echoes the request info, followed by size bytes of data.

		// 32 bits address little endian
		report[15]: 0x20 32
		report[16]: 0x60 96
		report[17]: 0x0 0
		report[18]: 0x0 0

		// length
		report[19]: 0xa 12

		// imu calibration data uses 12 bits!?

		0 - 2 	FFB0 FEB9 00E0 	Acc XYZ origin position when completely horizontal and stick is upside
		report[20]: 0xab 171
		report[21]: 0xfe 254
		report[22]: 0x11 17

		3 - 5 	4000 4000 4000 	Acc XYZ sensitivity special coeff, for default sensitivity: ±8G.
		report[23]: 0xff 255
		report[24]: 0xee 238
		report[25]: 0x0 0

		6 - 8 	000E FFDF FFD0 	Gyro XYZ origin position when still
		report[26]: 0x0 0
		report[27]: 0x40 64
		report[28]: 0x0 0

		9 - 11 	343B 343B 343B 	Gyro XYZ sensitivity special coeff, for default sensitivity: ±2000dps.
		report[29]: 0x40 64
		report[30]: 0x0 0
		report[31]: 0x0 0

		Reference code for converting from uint16_t to int16_t for doing the above calculations:

		int16_t uint16_to_int16(uint16_t a) {
			int16_t b;
			char* aPointer = (char*)&a, *bPointer = (char*)&b;
			memcpy(bPointer, aPointer, sizeof(a));
			return b;
		}
		*/

	}

	// MARK: - lower level hid output report methods

	/*
	static const s16 DFLT_ACCEL_OFFSET /*= 0*/;
	static const s16 DFLT_ACCEL_SCALE = 16384;
	static const s16 DFLT_GYRO_OFFSET /*= 0*/;
	static const s16 DFLT_GYRO_SCALE  = 13371;

		for (i = 0; i < 3; i++) {
			ctlr->accel_cal.offset[i] = DFLT_ACCEL_OFFSET;
			ctlr->accel_cal.scale[i] = DFLT_ACCEL_SCALE;
			ctlr->gyro_cal.offset[i] = DFLT_GYRO_OFFSET;
			ctlr->gyro_cal.scale[i] = DFLT_GYRO_SCALE;
		}

		for (i = 0; i < 3; i++) {
			int j = i * 2;

			ctlr->accel_cal.offset[i] = raw_cal[j + 0] |
							((s16)raw_cal[j + 1] << 8);
			ctlr->accel_cal.scale[i] = raw_cal[j + 6] |
							((s16)raw_cal[j + 7] << 8);
			ctlr->gyro_cal.offset[i] = raw_cal[j + 12] |
							((s16)raw_cal[j + 13] << 8);
			ctlr->gyro_cal.scale[i] = raw_cal[j + 18] |
							((s16)raw_cal[j + 19] << 8);


	// Magic value denoting presence of user calibration
	static const u16 JC_CAL_USR_MAGIC_0		= 0xB2;
	static const u16 JC_CAL_USR_MAGIC_1		= 0xA1;
	static const u8 JC_CAL_USR_MAGIC_SIZE		= 2;



	u8 factory_stick_cal[0x12];
    u8 user_stick_cal[0x16];
    u8 sensor_model[0x6];
    u8 stick_model[0x24];
    u8 factory_sensor_cal[0x18];
    u8 user_sensor_cal[0x1A];
    s16 sensor_cal[0x2][0x3];
    u16 stick_cal_x_l[0x3];
    u16 stick_cal_y_l[0x3];
    u16 stick_cal_x_r[0x3];
    u16 stick_cal_y_r[0x3];
    memset(factory_stick_cal, 0, 0x12);
    memset(user_stick_cal, 0, 0x16);
    memset(sensor_model, 0, 0x6);
    memset(stick_model, 0, 0x12);
    memset(factory_sensor_cal, 0, 0x18);
    memset(user_sensor_cal, 0, 0x1A);
    memset(sensor_cal, 0, sizeof(sensor_cal));
    memset(stick_cal_x_l, 0, sizeof(stick_cal_x_l));
    memset(stick_cal_y_l, 0, sizeof(stick_cal_y_l));
    memset(stick_cal_x_r, 0, sizeof(stick_cal_x_r));
    memset(stick_cal_y_r, 0, sizeof(stick_cal_y_r));
    get_spi_data(0x6020, 0x18, factory_sensor_cal); // JC_IMU_CAL_FCT_DATA_ADDR
    get_spi_data(0x603D, 0x12, factory_stick_cal); // JC_CAL_FCT_DATA_LEFT_ADDR
    get_spi_data(0x6080, 0x6, sensor_model);
    get_spi_data(0x6086, 0x12, stick_model);
    get_spi_data(0x6098, 0x12, &stick_model[0x12]);
    get_spi_data(0x8010, 0x16, user_stick_cal); // JC_CAL_USR_LEFT_MAGIC_ADDR
    get_spi_data(0x8026, 0x1A, user_sensor_cal); // JC_IMU_CAL_USR_MAGIC_ADDR
	*/

	func setInputReportId(device:IOHIDDevice, _ inputReportId:UInt8) -> Bool {

		// TODO

		/*
		// Set input report mode (to push at 60hz)
		// x00	Used with cmd x11. Active polling for NFC/IR camera data. 0x31 data format must be set first. Answers with more than 300 bytes ID 31 packet
		// x01	Same as 00. Active polling mode for NFC/IR MCU configuration data.
		// x02	Same as 00. Active polling mode for NFC/IR data and configuration. For specific NFC/IR modes. Active polling mode for IR camera data. Special IR mode or before configuring it ?
		// x03 	Same as 00. Active polling mode for IR camera data. For specific IR modes.

		// x21	Unknown. An input report with this ID has pairing or mcu data or serial flash data or device info
		// x23	MCU update input report ?

		x33 	Unknown mode.
		x35 	Unknown mode.
		*/

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_SET_INPUT_REPORT_ID

		// sub report type parameter 1
		buffer[11] = inputReportId

		let success = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

	func readSpiFlash(device:IOHIDDevice, startAddress:UInt16, size:UInt8) -> Bool {

		if size > 29 {
			print("Unsupported theoretycally. TODO throw error?")
			return false
		}

		var buffer = [UInt8](repeating: 0, count: Int(49))

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_SPI_FLASH_READ

		// 4 bytes for an UInt32 address, but none of the values I use exceeed 16 bits
		// Trying to avoid using pointers here to get the bytes...
		buffer[11] = 0 // UInt8(clamping: 0x000000FF & startAddress)
		buffer[12] = 0 // UInt8(clamping: 0x000000FF & (startAddress >> 8))
		buffer[13] = UInt8(clamping: 0x00FF & startAddress) // UInt8(clamping: 0x000000FF & (startAddress >> 16))
		buffer[14] = UInt8(clamping: 0x00FF & (startAddress >> 8)) // UInt8(clamping: 0x000000FF & (startAddress >> 24))

		// 1 byte for an UInt8 size
		buffer[15] = size

		let success = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true






		/*

		int get_spi_data(u32 offset, const u16 read_len, u8 *test_buf) {

			int res;
			u8 buf[49];

			while (1) {
				memset(buf, 0, sizeof(buf));
				auto hdr = (brcm_hdr *)buf;
				auto pkt = (brcm_cmd_01 *)(hdr + 1);
				hdr->cmd = 1;
				hdr->timer = timming_byte & 0xF;
				timming_byte++;
				pkt->subcmd = 0x10;
				pkt->spi_data.offset = offset;
				pkt->spi_data.size = read_len;
				res = hid_write(handle, buf, sizeof(buf));

				int retries = 0;
				while (1) {
					res = hid_read_timeout(handle, buf, sizeof(buf), 64);
					if ((*(u16*)&buf[0xD] == 0x1090) && (*(uint32_t*)&buf[0xF] == offset))
						goto check_result;

					retries++;
					if (retries > 8 || res == 0)
						break;
				}
				error_reading++;
				if (error_reading > 20)
					return 1;
			}
			check_result:
			if (res >= 0x14 + read_len) {
					for (int i = 0; i < read_len; i++) {
						test_buf[i] = buf[0x14 + i];
					}
			}

			return 0;
		}



		private void dump_calibration_data() {
            if (isSnes || thirdParty)
                return;
            HIDapi.hid_set_nonblocking(handle, 0);
            byte[] buf_ = ReadSPI(0x80, (isLeft ? (byte)0x12 : (byte)0x1d), 9); // get user calibration data if possible
            bool found = false;
            for (int i = 0; i < 9; ++i) {
                if (buf_[i] != 0xff) {
                    form.AppendTextBox("Using user stick calibration data.\r\n");
                    found = true;
                    break;
                }
            }
            if (!found) {
                form.AppendTextBox("Using factory stick calibration data.\r\n");
                buf_ = ReadSPI(0x60, (isLeft ? (byte)0x3d : (byte)0x46), 9); // get user calibration data if possible
            }
            stick_cal[isLeft ? 0 : 2] = (UInt16)((buf_[1] << 8) & 0xF00 | buf_[0]); // X Axis Max above center
            stick_cal[isLeft ? 1 : 3] = (UInt16)((buf_[2] << 4) | (buf_[1] >> 4));  // Y Axis Max above center
            stick_cal[isLeft ? 2 : 4] = (UInt16)((buf_[4] << 8) & 0xF00 | buf_[3]); // X Axis Center
            stick_cal[isLeft ? 3 : 5] = (UInt16)((buf_[5] << 4) | (buf_[4] >> 4));  // Y Axis Center
            stick_cal[isLeft ? 4 : 0] = (UInt16)((buf_[7] << 8) & 0xF00 | buf_[6]); // X Axis Min below center
            stick_cal[isLeft ? 5 : 1] = (UInt16)((buf_[8] << 4) | (buf_[7] >> 4));  // Y Axis Min below center

            PrintArray(stick_cal, len: 6, start: 0, format: "Stick calibration data: {0:S}");

            if (isPro) {
                buf_ = ReadSPI(0x80, (!isLeft ? (byte)0x12 : (byte)0x1d), 9); // get user calibration data if possible
                found = false;
                for (int i = 0; i < 9; ++i) {
                    if (buf_[i] != 0xff) {
                        form.AppendTextBox("Using user stick calibration data.\r\n");
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    form.AppendTextBox("Using factory stick calibration data.\r\n");
                    buf_ = ReadSPI(0x60, (!isLeft ? (byte)0x3d : (byte)0x46), 9); // get user calibration data if possible
                }
                stick2_cal[!isLeft ? 0 : 2] = (UInt16)((buf_[1] << 8) & 0xF00 | buf_[0]); // X Axis Max above center
                stick2_cal[!isLeft ? 1 : 3] = (UInt16)((buf_[2] << 4) | (buf_[1] >> 4));  // Y Axis Max above center
                stick2_cal[!isLeft ? 2 : 4] = (UInt16)((buf_[4] << 8) & 0xF00 | buf_[3]); // X Axis Center
                stick2_cal[!isLeft ? 3 : 5] = (UInt16)((buf_[5] << 4) | (buf_[4] >> 4));  // Y Axis Center
                stick2_cal[!isLeft ? 4 : 0] = (UInt16)((buf_[7] << 8) & 0xF00 | buf_[6]); // X Axis Min below center
                stick2_cal[!isLeft ? 5 : 1] = (UInt16)((buf_[8] << 4) | (buf_[7] >> 4));  // Y Axis Min below center

                PrintArray(stick2_cal, len: 6, start: 0, format: "Stick calibration data: {0:S}");

                buf_ = ReadSPI(0x60, (!isLeft ? (byte)0x86 : (byte)0x98), 16);
                deadzone2 = (UInt16)((buf_[4] << 8) & 0xF00 | buf_[3]);
            }

            buf_ = ReadSPI(0x60, (isLeft ? (byte)0x86 : (byte)0x98), 16);
            deadzone = (UInt16)((buf_[4] << 8) & 0xF00 | buf_[3]);

            buf_ = ReadSPI(0x80, 0x28, 10);
            acc_neutral[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
            acc_neutral[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
            acc_neutral[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

            buf_ = ReadSPI(0x80, 0x2E, 10);
            acc_sensiti[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
            acc_sensiti[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
            acc_sensiti[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

            buf_ = ReadSPI(0x80, 0x34, 10);
            gyr_neutral[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
            gyr_neutral[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
            gyr_neutral[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

            buf_ = ReadSPI(0x80, 0x3A, 10);
            gyr_sensiti[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
            gyr_sensiti[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
            gyr_sensiti[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

            PrintArray(gyr_neutral, len: 3, d: DebugType.IMU, format: "User gyro neutral position: {0:S}");

            // This is an extremely messy way of checking to see whether there is user stick calibration data present, but I've seen conflicting user calibration data on blank Joy-Cons. Worth another look eventually.
            if (gyr_neutral[0] + gyr_neutral[1] + gyr_neutral[2] == -3 || Math.Abs(gyr_neutral[0]) > 100 || Math.Abs(gyr_neutral[1]) > 100 || Math.Abs(gyr_neutral[2]) > 100) {
                buf_ = ReadSPI(0x60, 0x20, 10);
                acc_neutral[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
                acc_neutral[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
                acc_neutral[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

                buf_ = ReadSPI(0x60, 0x26, 10);
                acc_sensiti[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
                acc_sensiti[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
                acc_sensiti[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

                buf_ = ReadSPI(0x60, 0x2C, 10);
                gyr_neutral[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
                gyr_neutral[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
                gyr_neutral[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

                buf_ = ReadSPI(0x60, 0x32, 10);
                gyr_sensiti[0] = (Int16)(buf_[0] | ((buf_[1] << 8) & 0xff00));
                gyr_sensiti[1] = (Int16)(buf_[2] | ((buf_[3] << 8) & 0xff00));
                gyr_sensiti[2] = (Int16)(buf_[4] | ((buf_[5] << 8) & 0xff00));

                PrintArray(gyr_neutral, len: 3, d: DebugType.IMU, format: "Factory gyro neutral position: {0:S}");
            }
            HIDapi.hid_set_nonblocking(handle, 1);
        }
		*/

	}

	func sendReport(
		device:IOHIDDevice,
		led1On:Bool = false,
		led2On:Bool = false,
		led3On:Bool = false,
		led4On:Bool = false,
		blinkLed1:Bool = false,
		blinkLed2:Bool = false,
		blinkLed3:Bool = false,
		blinkLed4:Bool = false
		// TODO home led...
	) -> Bool {

		/*
		OUTPUT 0x01

		Rumble and subcommand.

		The OUTPUT 1 report is how all normal subcommands are sent. It also includes rumble data.

		Sample C code for sending a subcommand:

		uint8_t buf[0x40]; bzero(buf, 0x40);
		buf[0] = 1; // 0x10 for rumble only
		buf[1] = GlobalPacketNumber; // Increment by 1 for each packet sent. It loops in 0x0 - 0xF range.
		memcpy(buf + 2, rumbleData, 8);
		buf[10] = subcommandID;
		memcpy(buf + 11, subcommandData, subcommandDataLen);
		hid_write(handle, buf, 0x40);

		You can send rumble data and subcommand with x01 command, otherwise only rumble with x10 command.

		See "Rumble data" below.

		OUTPUT 0x10
		Rumble only. See OUTPUT 0x01 and "Rumble data" below.





		Subcommand 0x38: Set HOME Light

		25 bytes argument that control 49 elements.
		Byte #, Nibble 	Remarks
		x00, High 	Number of Mini Cycles. 1-15. If number of cycles is > 0 then x0 = x1
		x00, Low 	Global Mini Cycle Duration. 8ms - 175ms. Value x0 = 0ms/OFF
		x01, High 	LED Start Intensity. Value x0=0% - xF=100%
		x01, Low 	Number of Full Cycles. 1-15. Value x0 is repeat forever, but if also Byte x00 High nibble is set to x0, it does the 1st Mini Cycle and then the LED stays on with LED Start Intensity.

		When all selected Mini Cycles play and then end, this is a full cycle.

		The Mini Cycle configurations are grouped in two (except the 15th):
		Byte #, Nibble 	Remarks
		x02, High 	Mini Cycle 1 LED Intensity
		x02, Low 	Mini Cycle 2 LED Intensity
		x03, High 	Fading Transition Duration to Mini Cycle 1 (Uses PWM). Value is a Multiplier of Global Mini Cycle Duration
		x03, Low 	LED Duration Multiplier of Mini Cycle 1. x0 = x1 = x1
		x04, High 	Fading Transition Duration to Mini Cycle 2 (Uses PWM). Value is a Multiplier of Global Mini Cycle Duration
		x04, Low 	LED Duration Multiplier of Mini Cycle 1. x0 = x1 = x1

		The Fading Transition uses a PWM to increment the transition to the Mini Cycle.

		The LED Duration Multiplier and the Fading Multiplier use the same algorithm: Global Mini Cycle Duration ms * Multiplier value.

		Example: GMCD is set to xF = 175ms and LED Duration Multiplier is set to x4. The Duration that the LED will stay on it's configured intensity is then 175 * 4 = 700ms.

		Unused Mini Cycles can be skipped from the output packet.

		Table of Mini Cycle configuration:
		Byte #, Nibble 	Remarks
		x02, High 	Mini Cycle 1 LED Intensity
		x02, Low 	Mini Cycle 2 LED Intensity
		x03 High/Low 	Fading/LED Duration Multipliers for MC 1
		x04 High/Low 	Fading/LED Duration Multipliers for MC 2
		x05, High 	Mini Cycle 3 LED Intensity
		x05, Low 	Mini Cycle 4 LED Intensity
		x06 High/Low 	Fading/LED Duration Multipliers for MC 3
		x06 High/Low 	Fading/LED Duration Multipliers for MC 4
		... 	...
		x20, High 	Mini Cycle 13 LED Intensity
		x20, Low 	Mini Cycle 14 LED Intensity
		x21 High/Low 	Fading/LED Duration Multipliers for MC 13
		x22 High/Low 	Fading/LED Duration Multipliers for MC 14
		x23, High 	Mini Cycle 15 LED Intensity
		x23, Low 	Unused
		x24 High/Low 	Fading/LED Duration Multipliers for MC 15
		*/

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_SET_PLAYER_LIGHTS

		/*
		Subcommand Get player lights
		Replies with ACK xB0 x31 and one byte that uses the same bitfield with x30 subcommand
		The initial LED trail effects is 10110001 (xB1), but it cannot be set via x30. subcommand
		*/

		var leds:UInt8 = 0b0000_0000

		if led1On {
			leds = leds | 0b0000_0001
		}

		if led2On {
			leds = leds | 0b0000_0010
		}

		if led3On {
			leds = leds | 0b0000_0100
		}

		if led4On {
			leds = leds | 0b0000_1000
		}

		// "on" bits override "flash" bits. When on USB, "flash" bits work like "on" bits.

		if blinkLed1 {
			leds = leds | 0b0001_0000
		}
		if blinkLed2 {
			leds = leds | 0b0010_0000
		}
		if blinkLed3 {
			leds = leds | 0b0100_0000
		}
		if blinkLed4 {
			leds = leds | 0b1000_0000
		}

		// sub report type parameter 1
		buffer[11] = leds

		let success = IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

}
