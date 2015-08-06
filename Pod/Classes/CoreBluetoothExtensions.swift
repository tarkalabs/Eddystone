import CoreBluetooth

extension CBCentralManager {
    var stateString: String {
        get {
            switch (self.state) {
            case .PoweredOn:
                return "Powered On"
            case .PoweredOff:
                return "Powered Off"
            case .Resetting:
                return "Resetting"
            case .Unauthorized:
                return "Unauthorized"
            case .Unknown:
                return "Unknown"
            case .Unsupported:
                return "Unsupported"
            }
            
        }
    }
}

extension CBPeripheralManager {
    var stateString: String {
        get {
            switch (self.state) {
            case .PoweredOn:
                return "Powered On"
            case .PoweredOff:
                return "Powered Off"
            case .Resetting:
                return "Resetting"
            case .Unauthorized:
                return "Unauthorized"
            case .Unknown:
                return "Unknown"
            case .Unsupported:
                return "Unsupported"
            }
            
        }
    }
}