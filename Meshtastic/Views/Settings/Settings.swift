//
//  Settings.swift
//  MeshtasticApple
//
//  Copyright (c) Garth Vander Houwen 6/9/22.
//

import SwiftUI
import OSLog
import TipKit

struct Settings: View {
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	@FetchRequest(
		sortDescriptors: [
			NSSortDescriptor(key: "favorite", ascending: false),
			NSSortDescriptor(key: "user.pkiEncrypted", ascending: false),
			NSSortDescriptor(key: "viaMqtt", ascending: true),
			NSSortDescriptor(key: "user.longName", ascending: true)
		],
		animation: .default
	)
	private var nodes: FetchedResults<NodeInfoEntity>

	@State private var selectedNode: Int = 0
	@State private var preferredNodeNum: Int = 0

	@ObservedObject
	var router: Router

	// MARK: Views

	var radioConfigurationSection: some View {
		Section("radio.configuration") {
			let node = nodes.first(where: { $0.num == preferredNodeNum })
			if let node,
				let loRaConfig = node.loRaConfig,
			    let rc = RegionCodes(rawValue: Int(loRaConfig.regionCode)),
				let user = node.user,
				!user.isLicensed,
			    rc.dutyCycle > 0 && rc.dutyCycle < 100 {
				Label {
					Text("Hourly Duty Cycle")
				} icon: {
					Image(systemName: "clock.arrow.circlepath")
						.symbolRenderingMode(.hierarchical)
						.foregroundColor(.red)
				}
				Text("Your region has a \(rc.dutyCycle)% hourly duty cycle, your radio will stop sending packets when it reaches the hourly limit.")
					.foregroundColor(.orange)
					.font(.caption)
				Text("Limit all periodic broadcast intervals especially telemetry and position. If you need to increase hops, do it on nodes at the edges, not the ones in the middle. MQTT is not advised when you are duty cycle restricted because the gateway node is then doing all the work.")
					.font(.caption2)
					.foregroundColor(.gray)
			}

			NavigationLink(value: SettingsNavigationState.lora) {
				Label {
					Text("lora")
				} icon: {
					Image(systemName: "dot.radiowaves.left.and.right")
						.rotationEffect(.degrees(-90))
				}
			}

			NavigationLink(value: SettingsNavigationState.channels) {
				Label {
					Text("channels")
				} icon: {
					Image(systemName: "fibrechannel")
				}
			}
			.disabled(selectedNode > 0 && selectedNode != preferredNodeNum)

			NavigationLink(value: SettingsNavigationState.security) {
				Label {
					Text("Security")
				} icon: {
					Image(systemName: "lock.shield")
				}
			}

			NavigationLink(value: SettingsNavigationState.shareQRCode) {
				Label {
					Text("share.channels")
				} icon: {
					Image(systemName: "qrcode")
				}
			}
			.disabled(selectedNode > 0 && selectedNode != preferredNodeNum)
		}
	}

	var deviceConfigurationSection: some View {
		Section("device.configuration") {
			NavigationLink(value: SettingsNavigationState.user) {
				Label {
					Text("user")
				} icon: {
					Image(systemName: "person.crop.rectangle.fill")
				}
			}

			NavigationLink(value: SettingsNavigationState.bluetooth) {
				Label {
					Text("Bluetooth")
				} icon: {
					Image(systemName: "antenna.radiowaves.left.and.right")
				}
			}

			NavigationLink(value: SettingsNavigationState.device) {
				Label {
					Text("device")
				} icon: {
					Image(systemName: "flipphone")
				}
			}

			NavigationLink(value: SettingsNavigationState.display) {
				Label {
					Text("Display")
				} icon: {
					Image(systemName: "display")
				}
			}

			NavigationLink(value: SettingsNavigationState.network) {
				Label {
					Text("network")
				} icon: {
					Image(systemName: "network")
				}
			}

			NavigationLink(value: SettingsNavigationState.position) {
				Label {
					Text("position")
				} icon: {
					Image(systemName: "location")
				}
			}

			NavigationLink(value: SettingsNavigationState.power) {
				Label {
					Text("config.power.settings")
				} icon: {
					Image(systemName: "bolt.fill")
				}
			}
		}
	}

	var legalDocumentsSection: some View {
		Section("Legal Documents") {
			NavigationLink {
				TermOfServiceView()
			} label: {
				Label("Terms of Service", systemImage: "doc.text")
			}
			
			NavigationLink {
				PrivacyPolicyView()
			} label: {
				Label("Privacy Policy", systemImage: "hand.raised.fill")
			}
			
			NavigationLink {
				LicenceAndAttributionView()
			} label: {
				Label("License & Attribution", systemImage: "doc.badge.gearshape")
			}
		}
	}

	var moduleConfigurationSection: some View {
		Section("module.configuration") {
			NavigationLink(value: SettingsNavigationState.ambientLighting) {
				Label {
					Text("Ambient Lighting")
				} icon: {
					Image(systemName: "light.max")
				}
			}

			NavigationLink(value: SettingsNavigationState.cannedMessages) {
				Label {
					Text("Canned Messages")
				} icon: {
					Image(systemName: "list.bullet.rectangle.fill")
				}
			}

			NavigationLink(value: SettingsNavigationState.detectionSensor) {
				Label {
					Text("detection.sensor")
				} icon: {
					Image(systemName: "sensor")
				}
			}

			NavigationLink(value: SettingsNavigationState.externalNotification) {
				Label {
					Text("external.notification")
				} icon: {
					Image(systemName: "megaphone")
				}
			}

			NavigationLink(value: SettingsNavigationState.mqtt) {
				Label {
					Text("mqtt")
				} icon: {
					Image(systemName: "dot.radiowaves.up.forward")
				}
			}

			NavigationLink(value: SettingsNavigationState.rangeTest) {
				Label {
					Text("range.test")
				} icon: {
					Image(systemName: "point.3.connected.trianglepath.dotted")
				}
			}

			if let node = nodes.first(where: { $0.num == preferredNodeNum }),
				node.metadata?.hasWifi ?? false {
				NavigationLink(value: SettingsNavigationState.paxCounter) {
					Label {
						Text("config.module.paxcounter.settings")
					} icon: {
						Image(systemName: "figure.walk.motion")
					}
				}
			}

			NavigationLink(value: SettingsNavigationState.ringtone) {
				Label {
					Text("ringtone")
				} icon: {
					Image(systemName: "music.note.list")
				}
			}

			NavigationLink(value: SettingsNavigationState.serial) {
				Label {
					Text("serial")
				} icon: {
					Image(systemName: "terminal")
				}
			}

			NavigationLink(value: SettingsNavigationState.storeAndForward) {
				Label {
					Text("Store & Forward")
				} icon: {
					Image(systemName: "envelope.arrow.triangle.branch")
				}
			}

			NavigationLink(value: SettingsNavigationState.telemetry) {
				Label {
					Text("telemetry")
				} icon: {
					Image(systemName: "chart.xyaxis.line")
				}
			}
		}
	}

	var loggingSection: some View {
		Section(header: Text("logging")) {
			NavigationLink(value: SettingsNavigationState.debugLogs) {
				Label {
					Text("Logs")
				} icon: {
					Image(systemName: "scroll")
				}
			}
		}
	}

	var developersSection: some View {
		Section(header: Text("Developers")) {
			NavigationLink(value: SettingsNavigationState.meshLog) {
				Label {
					Text("mesh.log")
				} icon: {
					Image(systemName: "list.bullet.rectangle")
				}
			}
			NavigationLink(value: SettingsNavigationState.appFiles) {
				Label {
					Text("App Files")
				} icon: {
					Image(systemName: "folder")
				}
			}
		}
	}

	var firmwareSection: some View {
		Section(header: Text("Firmware")) {
			NavigationLink(value: SettingsNavigationState.firmwareUpdates) {
				Label {
					Text("Firmware Updates")
				} icon: {
					Image(systemName: "arrow.up.arrow.down.square")
				}
			}
			.disabled(selectedNode > 0 && selectedNode != preferredNodeNum)
		}
	}

	var body: some View {
		NavigationStack(
			path: Binding<[SettingsNavigationState]>(
				get: {
					[router.navigationState.settings].compactMap { $0 }
				},
				set: { newPath in
					router.navigationState.settings = newPath.first
				}
			)
		) {
			let node = nodes.first(where: { $0.num == preferredNodeNum })
			List {
				NavigationLink(value: SettingsNavigationState.about) {
					Label {
						Text("About dot SAGA")
					} icon: {
						Image(systemName: "questionmark.app")
					}
				}

				NavigationLink(value: SettingsNavigationState.appSettings) {
					Label {
						Text("App Settings")
					} icon: {
						Image(systemName: "gearshape")
					}
				}
				NavigationLink(value: SettingsNavigationState.routes) {
					Label {
						Text("Routes")
					} icon: {
						Image(systemName: "road.lanes.curved.right")
					}
				}

				NavigationLink(value: SettingsNavigationState.routeRecorder) {
					Label {
						Text("Route Recorder")
					} icon: {
						Image(systemName: "record.circle")
							.foregroundColor(.red)
					}
				}

				if !(node?.deviceConfig?.isManaged ?? false) {
					if bleManager.connectedPeripheral != nil {
						Section("Configure") {
							if node?.canRemoteAdmin ?? false {
								Picker("Node", selection: $selectedNode) {
									if selectedNode == 0 {
										Text("Connect to a Node").tag(0)
									}
									ForEach(nodes) { node in
										/// Connected Node
										if node.num == bleManager.connectedPeripheral?.num ?? 0 {
											Label {
												Text("BLE: \(node.user?.longName ?? "unknown".localized)")
											} icon: {
												Image(systemName: "antenna.radiowaves.left.and.right")
											}
											.tag(Int(node.num))
										} else if node.canRemoteAdmin && UserDefaults.enableAdministration && node.sessionPasskey != nil { /// Nodes using the new PKI system
											Label {
												Text("Remote PKI Admin: \(node.user?.longName ?? "unknown".localized)")
											} icon: {
												Image(systemName: "av.remote")
											}
											.font(.caption2)
											.tag(Int(node.num))
										} else if  !UserDefaults.enableAdministration && node.metadata != nil { /// Nodes using the old admin system
											Label {
												Text("Remote Legacy Admin: \(node.user?.longName ?? "unknown".localized)")
											} icon: {
												Image(systemName: "av.remote")
											}
											.tag(Int(node.num))
										} else if UserDefaults.enableAdministration && node.user?.pkiEncrypted ?? false {
											Label {
												Text("Request PKI Admin: \(node.user?.longName ?? "unknown".localized)")
											} icon: {
												Image(systemName: "rectangle.and.hand.point.up.left")
											}
											.tag(Int(node.num))
										} else if !UserDefaults.enableAdministration {
											Label {
												Text("Request Legacy Admin: \(node.user?.longName ?? "unknown".localized)")
											} icon: {
												Image(systemName: "rectangle.and.hand.point.up.left")
											}
											.tag(Int(node.num))
										}
									}
								}
								.pickerStyle(.navigationLink)
								.onChange(of: selectedNode) { _, newValue in
									if selectedNode > 0 {
										let node = nodes.first(where: { $0.num == newValue })
										let connectedNode = nodes.first(where: { $0.num == preferredNodeNum })
										preferredNodeNum = Int(connectedNode?.num ?? 0)// Int(bleManager.connectedPeripheral != nil ? bleManager.connectedPeripheral?.num ?? 0 : 0)
										if connectedNode != nil && connectedNode?.user != nil && connectedNode?.myInfo != nil && node?.user != nil {// && node?.metadata == nil {
											let adminMessageId =  bleManager.requestDeviceMetadata(fromUser: connectedNode!.user!, toUser: node!.user!, adminIndex: connectedNode!.myInfo!.adminIndex, context: context)
											if adminMessageId > 0 {
												Logger.mesh.info("Sent node metadata request from node details")
											}
										}
									}
								}
								TipView(AdminChannelTip(), arrowEdge: .top)
							} else {
								if bleManager.connectedPeripheral != nil {
									Text("Connected Node \(node?.user?.longName ?? "unknown".localized)")
								}
							}
						}
					}
					radioConfigurationSection
					deviceConfigurationSection
					legalDocumentsSection
					moduleConfigurationSection
					loggingSection
#if DEBUG
					developersSection
#endif
					firmwareSection
				}
			}
			.navigationDestination(for: SettingsNavigationState.self) { destination in
				let node = nodes.first(where: { $0.num == preferredNodeNum })
				switch destination {
				case .about:
					AboutMeshtastic()
				case .appSettings:
					AppSettings()
				case .routes:
					Routes()
				case .routeRecorder:
					RouteRecorder()
				case .lora:
					LoRaConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .channels:
					Channels(node: node)
				case .shareQRCode:
					ShareChannels(node: node)
				case .user:
					UserConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .bluetooth:
					BluetoothConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .device:
					DeviceConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .display:
					DisplayConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .network:
					NetworkConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .position:
					PositionConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .power:
					PowerConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .ambientLighting:
					AmbientLightingConfig(node: node)
				case .cannedMessages:
					CannedMessagesConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .detectionSensor:
					DetectionSensorConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .externalNotification:
					ExternalNotificationConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .mqtt:
					MQTTConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .rangeTest:
					RangeTestConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .paxCounter:
					PaxCounterConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .ringtone:
					RtttlConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .security:
					SecurityConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .serial:
					SerialConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .storeAndForward:
					StoreForwardConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .telemetry:
					TelemetryConfig(node: nodes.first(where: { $0.num == selectedNode }))
				case .meshLog:
					MeshLog()
				case .debugLogs:
					AppLog()
				case .appFiles:
					AppData()
				case .firmwareUpdates:
					Firmware(node: node)
				}
			}
			.onChange(of: UserDefaults.preferredPeripheralNum ) { _, newConnectedNode in
				preferredNodeNum = newConnectedNode
				if nodes.count > 1 {
					if selectedNode == 0 {
						self.selectedNode = Int(bleManager.connectedPeripheral != nil ? newConnectedNode : 0)
					}
				} else {
					self.selectedNode = Int(bleManager.connectedPeripheral != nil ? newConnectedNode: 0)
				}
			}
			.onAppear {
				if self.preferredNodeNum <= 0 {
					self.preferredNodeNum = UserDefaults.preferredPeripheralNum
					if nodes.count > 1 {
						if selectedNode == 0 {
							self.selectedNode = Int(bleManager.connectedPeripheral != nil ? UserDefaults.preferredPeripheralNum : 0)
						}
					} else {
						self.selectedNode = Int(bleManager.connectedPeripheral != nil ? UserDefaults.preferredPeripheralNum : 0)
					}
				}
			}
			.navigationTitle("settings")
			.navigationBarItems(
				leading: MeshtasticLogo()
			)
		}
	}
}
