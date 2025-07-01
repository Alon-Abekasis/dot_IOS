# Meshtastic Apple Client - Component Reference Guide

## Table of Contents
1. [Bluetooth Components](#bluetooth-components)
2. [Messaging System](#messaging-system)
3. [Node Management](#node-management)
4. [Map and Location](#map-and-location)
5. [Settings and Configuration](#settings-and-configuration)
6. [Data Persistence](#data-persistence)
7. [Widgets and Extensions](#widgets-and-extensions)
8. [Protocol Buffers](#protocol-buffers)

## Bluetooth Components

### BLEManager
**File**: `Meshtastic/Helpers/BLEManager.swift`

The BLEManager is the core component responsible for all Bluetooth Low Energy operations.

#### Key Properties
```swift
class BLEManager: NSObject, CBPeripheralDelegate, ObservableObject {
    // Singleton instance
    static var shared: BLEManager!
    
    // Core state
    @Published var peripherals: [Peripheral] = []
    @Published var connectedPeripheral: Peripheral!
    @Published var isSwitchedOn: Bool = false
    @Published var isConnected: Bool = false
    @Published var isConnecting: Bool = false
    @Published var isSubscribed: Bool = false
    
    // Error handling
    @Published var lastConnectionError: String
    @Published var invalidVersion = false
    
    // Configuration
    @Published var automaticallyReconnect: Bool = true
    public var minimumVersion = "2.3.15"
    public var connectedVersion: String
    
    // Meshtastic-specific UUIDs
    let meshtasticServiceCBUUID = CBUUID(string: "0x6BA1B218-15A8-461F-9FA8-5DCAE273EAFD")
    let TORADIO_UUID = CBUUID(string: "0xF75C76D2-129E-4DAD-A1DD-7866124401E7")
    let FROMRADIO_UUID = CBUUID(string: "0x2C55E69E-4993-11ED-B878-0242AC120002")
    let FROMNUM_UUID = CBUUID(string: "0xED9DA18C-A800-4F66-A670-AA7547E34453")
}
```

#### Core Methods

##### Device Discovery
```swift
func startScanning() {
    // Scans for devices with Meshtastic service UUID
    // Only starts if Bluetooth is enabled
}

func stopScanning() {
    // Stops active scanning operations
    // Called automatically when connecting to a device
}
```

##### Connection Management
```swift
func connectTo(peripheral: CBPeripheral) {
    // Initiates connection to specified peripheral
    // Sets up timeout timer for connection monitoring
    // Disconnects from current device if necessary
}

func disconnectPeripheral(reconnect: Bool = true) {
    // Disconnects current peripheral
    // Optionally enables automatic reconnection
    // Cleans up connection state
}

func cancelPeripheralConnection() {
    // Cancels connection attempt
    // Disables automatic reconnection
    // Restarts scanning
}
```

##### Protocol Communication
```swift
func sendWantConfig() {
    // Initiates configuration request to connected device
    // Required first step after BLE connection
}

func sendTraceRouteRequest(destNum: Int64, wantResponse: Bool) -> Bool {
    // Sends trace route request to specific node
    // Creates TraceRouteEntity in Core Data
    // Returns success status
}

func requestDeviceMetadata(fromUser: UserEntity, toUser: UserEntity, 
                          adminIndex: Int32, context: NSManagedObjectContext) -> Int64 {
    // Requests comprehensive device metadata
    // Uses admin message protocol
    // Returns message ID for tracking
}
```

#### Error Handling

The BLEManager implements comprehensive error handling for various connection scenarios:

```swift
// Error codes and meanings:
// 6 - CBError.Code.connectionTimeout: Device manually reset/powered off
// 7 - CBError.Code.peripheralDisconnected: Device went to sleep
// 14 - Peer removed pairing information: Requires Bluetooth settings reset
```

### Peripheral Model
**File**: `Meshtastic/Model/PeripheralModel.swift`

Represents discovered and connected Bluetooth peripherals:

```swift
class Peripheral: NSObject, ObservableObject, Identifiable {
    var id = UUID()
    var num: Int64 = 0
    var name: String = "Unknown"
    var shortName: String = "UNK"
    var longName: String = "Unknown"
    var firmwareVersion: String = "0.0.0"
    var peripheral: CBPeripheral
    var lastUpdate: Date = Date()
    var rssi: Int = 0
}
```

## Messaging System

### Message Views

#### Messages
**File**: `Meshtastic/Views/Messages/Messages.swift`

Main messaging interface that manages both channel and direct message navigation:

```swift
struct Messages: View {
    let router: Router
    @Binding var unreadChannelMessages: Int
    @Binding var unreadDirectMessages: Int
    
    // Navigation state
    @State private var selectedTab: MessagesTab = .channels
    @State private var columnVisibility = NavigationSplitViewVisibility.all
}

enum MessagesTab: String, CaseIterable {
    case channels = "Channels"
    case directMessages = "Direct Messages"
}
```

#### ChannelMessageList
**File**: `Meshtastic/Views/Messages/ChannelMessageList.swift`

Displays messages for a specific channel with real-time updates:

```swift
struct ChannelMessageList: View {
    let channel: ChannelEntity
    @Binding var messageId: Int64?
    
    // State management
    @State private var replyMessageId: Int64 = 0
    @State private var showingMessageDetails = false
    @State private var scrollToBottom = false
    
    // Core Data integration
    @FetchRequest var messages: FetchedResults<MessageEntity>
    
    init(channel: ChannelEntity, messageId: Binding<Int64?>) {
        self.channel = channel
        self._messageId = messageId
        
        // Setup Core Data fetch request
        self._messages = FetchRequest(
            entity: MessageEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \MessageEntity.messageTimestamp, ascending: true)],
            predicate: NSPredicate(format: "channel == %d", channel.index),
            animation: .default
        )
    }
}
```

#### UserMessageList
**File**: `Meshtastic/Views/Messages/UserMessageList.swift`

Handles direct messages between users:

```swift
struct UserMessageList: View {
    let user: UserEntity
    @Binding var messageId: Int64?
    
    // Message management
    @State private var replyMessageId: Int64 = 0
    @State private var showingMessageDetails = false
    
    // Filtering and display
    @State private var chatMessages: [MessageEntity] = []
    @State private var myInfo = MyInfoEntity()
}
```

### Message Components

#### MessageText
**File**: `Meshtastic/Views/Messages/MessageText.swift`

Renders individual message content with rich formatting:

```swift
struct MessageText: View {
    let message: MessageEntity
    let tapBackDestination: TapBackDestination
    
    // Display customization
    @State private var showDetection = false
    @State private var isTapBackResponse = false
    
    var body: some View {
        // Handles different message types:
        // - Regular text messages
        // - Detection sensor data
        // - Position reports
        // - Tap-back responses
    }
}
```

#### TapbackResponses
**File**: `Meshtastic/Views/Messages/TapbackResponses.swift`

Manages emoji reactions to messages:

```swift
struct TapbackResponses: View {
    let message: MessageEntity
    let tapBackDestination: TapBackDestination
    
    // Available tap-back emojis
    private let tapbacks = ["👍", "👎", "😂", "😍", "😢", "😮"]
}
```

## Node Management

### NodeList
**File**: `Meshtastic/Views/Nodes/NodeList.swift`

Comprehensive node management interface:

```swift
struct NodeList: View {
    let router: Router
    
    // Search and filtering
    @State private var searchText = ""
    @State private var sort: NodeSortOrder = .lastHeard
    @State private var filteredMqttConnected = false
    
    // Core Data integration
    @FetchRequest(
        entity: NodeInfoEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \NodeInfoEntity.lastHeard, ascending: false)]
    ) 
    var nodes: FetchedResults<NodeInfoEntity>
}

enum NodeSortOrder: String, CaseIterable {
    case lastHeard = "Last Heard"
    case alpha = "Alphabetical"
    case distance = "Distance"
    case role = "Role"
    case hopsAway = "Hops Away"
    case channel = "Channel"
    case batteryLevel = "Battery Level"
    case voltage = "Voltage"
}
```

### Node Detail Views

#### DeviceMetricsLog
**File**: `Meshtastic/Views/Nodes/DeviceMetricsLog.swift`

Displays comprehensive device telemetry:

```swift
struct DeviceMetricsLog: View {
    let node: NodeInfoEntity
    
    // Chart data management
    @State private var chartSelection: Set<String> = ["Battery Level"]
    @State private var chartRange: ChartRange = .lastHour
    
    // Metrics display
    var batteryLevel: Float { /* Battery percentage calculation */ }
    var voltage: Float { /* Voltage reading */ }
    var channelUtilization: Float { /* Channel usage percentage */ }
    var airUtilTx: Float { /* Transmission air time */ }
}
```

#### EnvironmentMetricsLog
**File**: `Meshtastic/Views/Nodes/EnvironmentMetricsLog.swift`

Environmental sensor data visualization:

```swift
struct EnvironmentMetricsLog: View {
    let node: NodeInfoEntity
    
    // Sensor data
    var temperature: Float { /* Temperature in configured units */ }
    var humidity: Float { /* Relative humidity percentage */ }
    var pressure: Float { /* Barometric pressure */ }
    var gasResistance: Float { /* Air quality sensor reading */ }
}
```

#### TraceRouteLog
**File**: `Meshtastic/Views/Nodes/TraceRouteLog.swift`

Network routing analysis and visualization:

```swift
struct TraceRouteLog: View {
    let node: NodeInfoEntity
    
    // Route analysis
    @State private var traceRoutes: [TraceRouteEntity] = []
    @State private var isRequesting = false
    
    // Network topology
    func analyzeRoute(_ route: TraceRouteEntity) -> [RouteHop] {
        // Processes route data to show network path
        // Calculates hop-by-hop signal strength
        // Identifies potential network issues
    }
}
```

## Map and Location

### MeshMap
**File**: `Meshtastic/Views/Nodes/MeshMap.swift`

Interactive map component showing node locations and network topology:

```swift
struct MeshMap: View {
    let router: Router
    
    // Map configuration
    @State private var mapStyle: MapStyle = .standard
    @State private var position: MapCameraPosition = .automatic
    @State private var showNodeHistory = false
    @State private var selectedMapLayer: MapLayer = .offline
    
    // Location tracking
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var mapSelection: String?
    
    enum MapLayer: String, CaseIterable {
        case offline = "Offline"
        case satellite = "Satellite"
        case hybrid = "Hybrid"
    }
}
```

### Location Services

#### LocationHelper
**File**: `Meshtastic/Helpers/LocationHelper.swift`

GPS and location management:

```swift
class LocationHelper: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    func requestLocation() {
        // Requests one-time location update
    }
    
    func startLocationUpdates() {
        // Begins continuous location monitoring
        // Configures for optimal battery usage
    }
    
    func stopLocationUpdates() {
        // Stops location monitoring
    }
}
```

#### LocationsHandler
**File**: `Meshtastic/Helpers/LocationsHandler.swift`

Manages location data integration with mesh network:

```swift
class LocationsHandler: ObservableObject {
    @Published var locations: [PositionEntity] = []
    
    func handleLocationUpdate(_ location: CLLocation, for node: NodeInfoEntity) {
        // Processes incoming location data
        // Updates Core Data with position information
        // Triggers map updates
    }
    
    func shareLocation(to nodeNum: Int64) -> Bool {
        // Shares current device location to mesh network
        // Respects privacy settings
        // Returns success status
    }
}
```

## Settings and Configuration

### Settings
**File**: `Meshtastic/Views/Settings/Settings.swift`

Main settings interface with hierarchical navigation:

```swift
struct Settings: View {
    let router: Router
    
    // Navigation state
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var settingsSelection: SettingsNavigationState?
    
    // Settings categories
    enum SettingsCategory: String, CaseIterable {
        case user = "User"
        case channels = "Channels"
        case moduleConfig = "Module Config"
        case deviceConfig = "Device Config"
        case app = "App"
    }
}
```

### Configuration Views

#### UserConfig
**File**: `Meshtastic/Views/Settings/UserConfig.swift`

User profile and identity management:

```swift
struct UserConfig: View {
    @ObservedObject var node: NodeInfoEntity
    
    // User data
    @State private var longName = ""
    @State private var shortName = ""
    @State private var isLicensed = false
    @State private var macAddress = ""
    
    // Validation
    private func validateUserData() -> Bool {
        // Ensures required fields are populated
        // Validates name length constraints
        // Checks for reserved characters
    }
}
```

#### Channels
**File**: `Meshtastic/Views/Settings/Channels.swift`

Channel configuration and management:

```swift
struct Channels: View {
    @ObservedObject var node: NodeInfoEntity
    
    // Channel management
    @State private var channels: [ChannelEntity] = []
    @State private var selectedChannel: ChannelEntity?
    @State private var showingQRCode = false
    
    // QR code generation
    func generateChannelQR(for channel: ChannelEntity) -> String {
        // Creates shareable QR code data
        // Includes encryption keys and settings
        // Generates meshtastic.org URL format
    }
}
```

## Data Persistence

### PersistenceController
**File**: `Meshtastic/Persistence/Persistence.swift`

Core Data stack management:

```swift
class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Meshtastic")
        
        // Configuration
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Database management
    func clearDatabase() {
        // Safely truncates all data
        // Recreates persistent store
        // Handles errors gracefully
    }
    
    // Backup and restore
    func copyPersistentStores(to destinationURL: URL, overwriting: Bool = false) throws {
        // Creates backup copy of database
        // Preserves referential integrity
        // Validates destination path
    }
    
    func restorePersistentStore(from backupURL: URL) throws {
        // Restores from backup file
        // Invalidates existing managed objects
        // Requires app state reset
    }
}
```

### Core Data Extensions

#### Entity Extensions
**File**: `Meshtastic/Extensions/CoreData/*.swift`

Comprehensive extensions for Core Data entities:

```swift
// UserEntityExtension.swift
extension UserEntity {
    var displayName: String {
        // Returns appropriate display name
        // Falls back to shortened versions
    }
    
    var initials: String {
        // Generates user initials for avatars
    }
    
    func updateFromUser(_ user: User) {
        // Updates entity from protobuf data
        // Preserves local modifications
    }
}

// NodeInfoEntityExtension.swift
extension NodeInfoEntity {
    var batteryLevel: Int32 {
        // Calculates current battery percentage
    }
    
    var signalStrength: String {
        // Returns formatted signal strength
    }
    
    var lastHeardDescription: String {
        // Human-readable time since last contact
    }
}

// MessageEntityExtension.swift
extension MessageEntity {
    var isFromCurrentUser: Bool {
        // Determines if message was sent by current user
    }
    
    var formattedTimestamp: String {
        // Returns formatted message time
    }
}
```

### Query Helpers
**File**: `Meshtastic/Persistence/QueryCoreData.swift`

Common Core Data query patterns:

```swift
class QueryCoreData {
    static func fetchNode(num: Int64, context: NSManagedObjectContext) -> NodeInfoEntity? {
        // Fetches specific node by number
    }
    
    static func fetchRecentMessages(limit: Int, context: NSManagedObjectContext) -> [MessageEntity] {
        // Returns recent messages across all channels
    }
    
    static func fetchChannelMessages(channel: Int32, context: NSManagedObjectContext) -> [MessageEntity] {
        // Returns messages for specific channel
    }
}
```

## Widgets and Extensions

### WidgetsBundle
**File**: `Widgets/WidgetsBundle.swift`

Widget configuration and entry point:

```swift
@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        BatteryLevel()
        WidgetsLiveActivity()
    }
}
```

### BatteryLevel Widget
**File**: `Widgets/BatteryLevel.swift`

Home screen widget showing connected device battery:

```swift
struct BatteryLevel: Widget {
    let kind: String = "BatteryLevel"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BatteryLevelEntryView(entry: entry)
        }
        .configurationDisplayName("Battery Level")
        .description("Shows the battery level of your connected Meshtastic device")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
```

### Live Activities
**File**: `Widgets/WidgetsLiveActivity.swift`

Dynamic Island and Live Activity integration:

```swift
struct WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeshActivityAttributes.self) { context in
            // Live Activity content
            LiveActivityView(state: context.state)
        } dynamicIsland: { context in
            // Dynamic Island presentation
            DynamicIslandView(state: context.state)
        }
    }
}
```

## Protocol Buffers

### Meshtastic Protobufs
**File**: `MeshtasticProtobufs/Sources/meshtastic/*.pb.swift`

Generated Swift code from Meshtastic protocol definitions:

#### Key Message Types

```swift
// Core messaging
public struct MeshPacket {
    public var id: UInt32
    public var to: UInt32
    public var from: UInt32
    public var channel: UInt32
    public var decoded: DataMessage
    public var wantAck: Bool
}

public struct DataMessage {
    public var payload: Data
    public var portnum: PortNum
    public var wantResponse: Bool
}

// User and node information
public struct User {
    public var id: String
    public var longName: String
    public var shortName: String
    public var macaddr: Data
    public var role: HardwareModel
}

public struct NodeInfo {
    public var num: UInt32
    public var user: User
    public var position: Position
    public var snr: Float
    public var lastHeard: UInt32
}

// Configuration messages
public struct Config {
    public var device: Config.DeviceConfig
    public var position: Config.PositionConfig
    public var power: Config.PowerConfig
    public var network: Config.NetworkConfig
    public var display: Config.DisplayConfig
    public var lora: Config.LoRaConfig
    public var bluetooth: Config.BluetoothConfig
}

// Module configurations
public struct ModuleConfig {
    public var mqtt: ModuleConfig.MQTTConfig
    public var serial: ModuleConfig.SerialConfig
    public var externalNotification: ModuleConfig.ExternalNotificationConfig
    public var storeForward: ModuleConfig.StoreForwardConfig
    public var rangeTest: ModuleConfig.RangeTestConfig
    public var telemetry: ModuleConfig.TelemetryConfig
    public var cannedMessage: ModuleConfig.CannedMessageConfig
}
```

#### Protocol Integration

```swift
// Message encoding
extension BLEManager {
    func sendMessage(_ message: DataMessage, to nodeNum: UInt32) -> Bool {
        var meshPacket = MeshPacket()
        meshPacket.to = nodeNum
        meshPacket.decoded = message
        meshPacket.id = UInt32.random(in: UInt32(UInt8.max)..<UInt32.max)
        
        var toRadio = ToRadio()
        toRadio.packet = meshPacket
        
        guard let data = try? toRadio.serializedData() else { return false }
        
        connectedPeripheral.peripheral.writeValue(
            data, 
            for: TORADIO_characteristic, 
            type: .withResponse
        )
        
        return true
    }
}

// Message decoding
extension BLEManager {
    func handleFromRadio(_ data: Data) {
        guard let fromRadio = try? FromRadio(serializedData: data) else { return }
        
        switch fromRadio.payloadVariant {
        case .packet(let meshPacket):
            processMeshPacket(meshPacket)
        case .myInfo(let myInfo):
            processMyInfo(myInfo)
        case .nodeInfo(let nodeInfo):
            processNodeInfo(nodeInfo)
        case .config(let config):
            processConfig(config)
        default:
            break
        }
    }
}
```

This component reference provides detailed implementation information for developers working with the Meshtastic Apple client codebase. Each component includes its key responsibilities, public interfaces, and integration patterns with other system components.