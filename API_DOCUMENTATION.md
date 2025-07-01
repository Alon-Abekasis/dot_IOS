# Meshtastic Apple Client - Comprehensive API Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Architecture Overview](#architecture-overview)
3. [Core Components](#core-components)
4. [Public APIs](#public-apis)
5. [Data Models](#data-models)
6. [Views and UI Components](#views-and-ui-components)
7. [Extensions and Helpers](#extensions-and-helpers)
8. [App Intents and Shortcuts](#app-intents-and-shortcuts)
9. [Usage Examples](#usage-examples)
10. [Development Guidelines](#development-guidelines)

## Introduction

The Meshtastic Apple Client is a SwiftUI-based application for iOS, iPadOS, and macOS that provides a comprehensive interface for interacting with Meshtastic mesh networks. Built on modern Apple frameworks, it enables users to communicate through Bluetooth Low Energy (BLE) with Meshtastic devices, manage mesh networks, send messages, and monitor device telemetry.

### Key Features
- **Cross-platform Support**: Runs on iOS, iPadOS, and macOS
- **Bluetooth Low Energy Communication**: Direct connection to Meshtastic devices
- **Mesh Network Management**: Node discovery, configuration, and monitoring
- **Real-time Messaging**: Channel and direct messaging capabilities
- **Location Services**: GPS tracking and mapping functionality
- **Device Configuration**: Remote device settings management
- **Data Persistence**: Core Data integration for local storage
- **App Intents Integration**: Siri Shortcuts and automation support

## Architecture Overview

The application follows a modern SwiftUI architecture with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────┐ │
│  │   Views     │ │   Widgets   │ │ App Intents │ │ Sheets │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Business Logic                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────┐ │
│  │ BLEManager  │ │   Router    │ │  AppState   │ │Helpers │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────┐ │
│  │ Core Data   │ │ Protobufs   │ │Persistence  │ │ MQTT   │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Core Architectural Principles

1. **SwiftUI-First**: Modern declarative UI framework
2. **MVVM Pattern**: Clear separation between views and business logic
3. **Reactive Programming**: Uses Combine framework for state management
4. **Protocol-Oriented Design**: Extensive use of Swift protocols
5. **Core Data Integration**: Robust data persistence layer
6. **Modular Structure**: Well-organized component hierarchy

## Core Components

### AppState
The central state management component that coordinates global application state.

```swift
class AppState: ObservableObject {
    @Published var router: Router
    @Published var unreadChannelMessages: Int
    @Published var unreadDirectMessages: Int
    
    var totalUnreadMessages: Int {
        unreadChannelMessages + unreadDirectMessages
    }
}
```

**Key Responsibilities:**
- Global state coordination
- Message count management
- Router integration
- Badge count synchronization

### Router
Navigation management system that handles deep linking and tab-based navigation.

```swift
@MainActor
class Router: ObservableObject {
    @Published var navigationState: NavigationState
    
    func route(url: URL)
    private func routeMessages(_ components: URLComponents)
    private func routeNodes(_ components: URLComponents)
    private func routeMap(_ components: URLComponents)
    private func routeSettings(_ components: URLComponents)
}
```

**Supported URL Schemes:**
- `meshtastic:///messages?channelId=1&messageId=123`
- `meshtastic:///nodes?nodenum=123456789`
- `meshtastic:///map?nodenum=123456789`
- `meshtastic:///settings/channels`

### BLEManager
The core Bluetooth Low Energy management component responsible for device discovery, connection, and communication.

```swift
class BLEManager: NSObject, CBPeripheralDelegate, ObservableObject {
    static var shared: BLEManager!
    
    @Published var peripherals: [Peripheral] = []
    @Published var connectedPeripheral: Peripheral!
    @Published var lastConnectionError: String
    @Published var isSwitchedOn: Bool = false
    @Published var automaticallyReconnect: Bool = true
    
    // Core BLE Operations
    func startScanning()
    func stopScanning()
    func connectTo(peripheral: CBPeripheral)
    func disconnectPeripheral(reconnect: Bool = true)
    
    // Meshtastic Protocol
    func sendWantConfig()
    func sendTraceRouteRequest(destNum: Int64, wantResponse: Bool) -> Bool
    func requestDeviceMetadata(fromUser: UserEntity, toUser: UserEntity, 
                              adminIndex: Int32, context: NSManagedObjectContext) -> Int64
}
```

**Key Features:**
- Automatic device discovery and reconnection
- Meshtastic protocol implementation
- Error handling and recovery
- Connection state management
- Protocol buffer message handling

### PersistenceController
Core Data stack management for local data storage.

```swift
class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    func clearDatabase()
    func copyPersistentStores(to destinationURL: URL, overwriting: Bool = false) throws
    func restorePersistentStore(from backupURL: URL) throws
}
```

## Public APIs

### BLEManager Public Interface

#### Connection Management
```swift
// Start scanning for nearby Meshtastic devices
func startScanning()

// Stop device scanning
func stopScanning()

// Connect to a specific peripheral
func connectTo(peripheral: CBPeripheral)

// Disconnect from current device
func disconnectPeripheral(reconnect: Bool = true)

// Cancel connection attempt
func cancelPeripheralConnection()
```

#### Device Communication
```swift
// Request device configuration
func sendWantConfig()

// Send trace route request
func sendTraceRouteRequest(destNum: Int64, wantResponse: Bool) -> Bool

// Request device metadata
func requestDeviceMetadata(fromUser: UserEntity, toUser: UserEntity, 
                          adminIndex: Int32, context: NSManagedObjectContext) -> Int64
```

#### State Properties
```swift
@Published var peripherals: [Peripheral]        // Available devices
@Published var connectedPeripheral: Peripheral  // Currently connected device
@Published var isSwitchedOn: Bool              // Bluetooth availability
@Published var isConnected: Bool               // Connection status
@Published var lastConnectionError: String     // Last error message
@Published var automaticallyReconnect: Bool    // Auto-reconnect preference
```

### Router Public Interface

#### Navigation Methods
```swift
// Route to specific URL
func route(url: URL)

// Navigation state management
@Published var navigationState: NavigationState
```

#### Supported Routes
- **Messages**: `/messages?channelId=<id>&messageId=<id>`
- **Nodes**: `/nodes?nodenum=<number>`
- **Map**: `/map?nodenum=<number>&waypointId=<id>`
- **Settings**: `/settings/<section>`

### AppState Public Interface

#### State Management
```swift
@Published var router: Router
@Published var unreadChannelMessages: Int
@Published var unreadDirectMessages: Int

var totalUnreadMessages: Int { get }
```

## Data Models

### Core Data Entities

#### NodeInfoEntity
Represents a mesh network node with comprehensive device information.

```swift
extension NodeInfoEntity {
    var num: Int64                    // Node number
    var lastHeard: Date?             // Last communication timestamp
    var snr: Float                   // Signal-to-noise ratio
    var rssi: Int32                  // Received signal strength
    var hopsAway: Int32              // Network hops from current device
    var hasPositions: Bool           // GPS capability
    var user: UserEntity?            // Associated user information
    var deviceMetrics: NSSet?        // Device telemetry data
    var environmentMetrics: NSSet?   // Environmental sensor data
}
```

#### UserEntity
User profile information for mesh network participants.

```swift
extension UserEntity {
    var num: Int64                   // User number
    var userId: String              // Unique user identifier
    var longName: String            // Display name
    var shortName: String           // Abbreviated name
    var isLicensed: Bool            // Amateur radio license status
    var role: Int32                 // User role in network
    var publicKey: Data?            // Encryption key
}
```

#### MessageEntity
Represents messages in the mesh network.

```swift
extension MessageEntity {
    var messageId: Int64            // Unique message identifier
    var messageTimestamp: Int32     // Timestamp
    var messagePayload: Data?       // Message content
    var messagePayloadText: String? // Text content
    var channel: Int32              // Channel number
    var fromUser: UserEntity?       // Sender
    var toUser: UserEntity?         // Recipient
    var isEmoji: Bool              // Emoji-only message flag
    var read: Bool                 // Read status
}
```

#### PositionEntity
GPS position and location data.

```swift
extension PositionEntity {
    var time: Date                  // Position timestamp
    var latitude: Double            // Latitude coordinate
    var longitude: Double           // Longitude coordinate
    var altitude: Int32             // Altitude in meters
    var satsInView: Int32          // Visible satellites
    var speed: Int32               // Speed in knots
    var heading: Int32             // Compass heading
}
```

## Views and UI Components

### Main Navigation Views

#### ContentView
The root view that manages tab-based navigation.

```swift
struct ContentView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var router: Router
    
    var body: some View {
        TabView(selection: $appState.router.navigationState.selectedTab) {
            Messages(...)
            Connect()
            NodeList(...)
            MeshMap(...)
            Settings(...)
        }
    }
}
```

### Message Views

#### Messages
Main messaging interface supporting both channel and direct messages.

```swift
struct Messages: View {
    let router: Router
    @Binding var unreadChannelMessages: Int
    @Binding var unreadDirectMessages: Int
}
```

#### ChannelMessageList
Channel-specific message display with real-time updates.

```swift
struct ChannelMessageList: View {
    let channel: ChannelEntity
    @Binding var messageId: Int64?
}
```

#### UserMessageList
Direct message interface between users.

```swift
struct UserMessageList: View {
    let user: UserEntity
    @Binding var messageId: Int64?
}
```

### Node Management Views

#### NodeList
Comprehensive node listing with status indicators.

```swift
struct NodeList: View {
    let router: Router
    @State private var searchText = ""
    @State private var sort: NodeSortOrder = .lastHeard
}
```

#### NodeMap
Interactive map showing node locations and network topology.

```swift
struct MeshMap: View {
    let router: Router
    @State private var mapStyle: MapStyle = .standard
    @State private var showNodeHistory = false
}
```

### Bluetooth Views

#### Connect
Bluetooth device discovery and connection management.

```swift
struct Connect: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var showSeparateMode = false
}
```

### Settings Views

#### Settings
Comprehensive application and device configuration.

```swift
struct Settings: View {
    let router: Router
    @State private var columnVisibility = NavigationSplitViewVisibility.all
}
```

## Extensions and Helpers

### Core Data Extensions

#### NSManagedObjectContext Extensions
```swift
extension NSManagedObjectContext {
    func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws
}
```

#### UserDefaults Extensions
```swift
extension UserDefaults {
    static var preferredPeripheralId: String { get set }
    static var meshNetworkWideChannel: Int { get set }
    static var provideLocationToMesh: Bool { get set }
}
```

### Foundation Extensions

#### String Extensions
```swift
extension String {
    var localized: String { get }
    func isValidEmail() -> Bool
    func sanitizeString() -> String
}
```

#### Date Extensions
```swift
extension Date {
    var formattedDate: String { get }
    var relative: String { get }
    func timeAgo() -> String
}
```

#### Data Extensions
```swift
extension Data {
    var hexString: String { get }
    func compressed() -> Data?
}
```

### Helper Classes

#### LocationHelper
GPS and location services management.

```swift
class LocationHelper: NSObject, CLLocationManagerDelegate {
    func requestLocation()
    func startLocationUpdates()
    func stopLocationUpdates()
}
```

#### MeshLogger
Centralized logging system for debugging and monitoring.

```swift
class MeshLogger {
    static func log(_ message: String, category: String = "default")
    static func error(_ message: String, category: String = "error")
}
```

## App Intents and Shortcuts

### Available Intents

#### MessageNodeIntent
Send message to a specific node via Siri.

```swift
struct MessageNodeIntent: AppIntent {
    @Parameter(title: "Node")
    var node: NodeEntity
    
    @Parameter(title: "Message")
    var message: String
    
    func perform() async throws -> some IntentResult
}
```

#### NavigateToNodeIntent
Navigate to node details or map location.

```swift
struct NavigateToNodeIntent: AppIntent {
    @Parameter(title: "Node")
    var node: NodeEntity
    
    func perform() async throws -> some IntentResult
}
```

#### SaveChannelSettingsIntent
Save and share channel configuration.

```swift
struct SaveChannelSettingsIntent: AppIntent {
    @Parameter(title: "Channel Settings")
    var channelSettings: String
    
    func perform() async throws -> some IntentResult
}
```

### Usage Examples

#### Siri Commands
- "Send message to [Node Name] using Meshtastic"
- "Navigate to [Node Name] in Meshtastic"
- "Show node position for [Node Name]"
- "Restart [Node Name] device"

## Usage Examples

### Basic BLE Connection

```swift
import SwiftUI

struct ExampleBLEConnection: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var selectedPeripheral: Peripheral?
    
    var body: some View {
        VStack {
            // Start scanning
            Button("Start Scanning") {
                bleManager.startScanning()
            }
            .disabled(!bleManager.isSwitchedOn)
            
            // Device list
            List(bleManager.peripherals, id: \.id) { peripheral in
                Button(peripheral.name) {
                    bleManager.connectTo(peripheral: peripheral.peripheral)
                }
            }
            
            // Connection status
            if bleManager.isConnected {
                Text("Connected to: \(bleManager.connectedPeripheral.name)")
                    .foregroundColor(.green)
            }
        }
    }
}
```

### Message Sending

```swift
import CoreData

class MessageManager {
    let context: NSManagedObjectContext
    let bleManager: BLEManager
    
    func sendMessage(to user: UserEntity, text: String) {
        // Create message entity
        let message = MessageEntity(context: context)
        message.messagePayloadText = text
        message.toUser = user
        message.messageTimestamp = Int32(Date().timeIntervalSince1970)
        
        // Send via BLE
        // Implementation depends on BLEManager protocol methods
        
        // Save to Core Data
        try? context.save()
    }
}
```

### Router Navigation

```swift
struct ExampleNavigation: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Button("Navigate to Messages") {
                appState.router.navigationState.selectedTab = .messages
            }
            
            Button("Navigate to Specific Node") {
                let url = URL(string: "meshtastic:///nodes?nodenum=123456789")!
                appState.router.route(url: url)
            }
            
            Button("Open Channel Messages") {
                let url = URL(string: "meshtastic:///messages?channelId=1")!
                appState.router.route(url: url)
            }
        }
    }
}
```

### Core Data Queries

```swift
import CoreData

extension PersistenceController {
    func fetchNodes() -> [NodeInfoEntity] {
        let request: NSFetchRequest<NodeInfoEntity> = NodeInfoEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \NodeInfoEntity.lastHeard, ascending: false)
        ]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching nodes: \(error)")
            return []
        }
    }
    
    func fetchRecentMessages(limit: Int = 50) -> [MessageEntity] {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MessageEntity.messageTimestamp, ascending: false)
        ]
        request.fetchLimit = limit
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching messages: \(error)")
            return []
        }
    }
}
```

## Development Guidelines

### Code Standards

1. **SwiftUI Best Practices**
   - Use `@StateObject` for view-owned observable objects
   - Use `@ObservedObject` for objects passed from parent views
   - Prefer `@Published` properties for reactive state
   - Use proper view modifiers for accessibility

2. **Core Data Guidelines**
   - Always save on main context for UI updates
   - Use background contexts for heavy operations
   - Implement proper error handling
   - Use batch operations for bulk updates

3. **BLE Communication**
   - Handle connection timeouts gracefully
   - Implement proper error recovery
   - Use background queues for heavy operations
   - Follow Meshtastic protocol specifications

4. **Error Handling**
   - Use proper error types and messages
   - Implement user-friendly error display
   - Log errors for debugging
   - Provide recovery options when possible

### Testing Strategies

#### Unit Testing
```swift
import XCTest
@testable import Meshtastic

class BLEManagerTests: XCTestCase {
    var bleManager: BLEManager!
    
    override func setUp() {
        super.setUp()
        // Setup test environment
    }
    
    func testConnectionFlow() {
        // Test BLE connection logic
    }
    
    func testMessageSending() {
        // Test message transmission
    }
}
```

#### UI Testing
```swift
import XCTest

class MeshtasticUITests: XCTestCase {
    func testTabNavigation() {
        let app = XCUIApplication()
        app.launch()
        
        // Test tab switching
        app.tabBars.buttons["messages"].tap()
        XCTAssertTrue(app.navigationBars["Messages"].exists)
    }
}
```

### Performance Considerations

1. **Memory Management**
   - Use weak references for delegates
   - Properly dispose of timers and observers
   - Implement efficient Core Data fetching

2. **Battery Optimization**
   - Minimize background BLE scanning
   - Use efficient location services
   - Implement proper sleep/wake handling

3. **Network Efficiency**
   - Batch BLE operations when possible
   - Implement proper retry logic
   - Use compression for large payloads

### Accessibility Support

The application supports comprehensive accessibility features:

- VoiceOver navigation
- Dynamic Type scaling
- High contrast support
- Voice Control compatibility
- Switch Control support

### Localization

The app supports multiple languages through:
- String localization files
- Right-to-left language support
- Cultural formatting considerations
- Accessibility label localization

This documentation provides a comprehensive overview of the Meshtastic Apple client architecture, APIs, and usage patterns. For specific implementation details, refer to the source code and inline documentation.