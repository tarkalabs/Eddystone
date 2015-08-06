import CoreBluetooth

public class Scanner: NSObject {
    
    //MARK: Singleton
    static let shared = Scanner()
    
    //MARK: Constants
    static let eddystoneServiceUUID = CBUUID(string: "FEAA")
    
    //MARK: Properties
    var centralManager = CBCentralManager()
    var discoveredBeacons = [NSUUID: Beacon]()
    var delegate: ScannerDelegate?
    
    //MARK: Class
    public class func start(delegate: ScannerDelegate) {
        
        self.shared.centralManager = CBCentralManager(delegate: self.shared, queue: nil)
        self.shared.delegate = delegate
        
    }
    
    class func beacons() -> [Beacon] {
        var orderedBeacons = [Beacon]()
        
        for (identifier, beacon) in self.shared.discoveredBeacons {
            orderedBeacons.append(beacon)
        }
        
        orderedBeacons.sort { beacon1, beacon2 in
            return beacon1.rssi > beacon2.rssi
        }
        
        return orderedBeacons
    }
    
    public class func urls() -> [Url] {
        
        var urls: [Url] = []
    
        
        for beacon in self.beacons() {
            if let beacon = beacon as? UrlBeacon {
                var url = Url(url: beacon.url, signalStrength: beacon.signalStrength)
                urls.append(url)
            }
        }
        
        return urls
    }
    
}

extension Scanner: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(central: CBCentralManager!) {
        if central.state == .PoweredOn {
            central.scanForPeripheralsWithServices([Scanner.eddystoneServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        } else {
            
        }
    }
    
    public func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var change = false
        
        if let beacon = self.discoveredBeacons[peripheral.identifier] {
            change = beacon.updateRssi(RSSI.doubleValue)
        } else {
            if let beacon = Beacon.beaconWithAdvertisementData(advertisementData, rssi: RSSI.doubleValue) {
                beacon.delegate = self
                self.discoveredBeacons[peripheral.identifier] = beacon
            }
        }
    }
    
}

extension Scanner: BeaconDelegate {
    
    func beaconDidChange() {
        self.delegate?.eddystoneUrlsDidChange()
    }
    
}

//MARK: Protocol
public protocol ScannerDelegate {
    
    func eddystoneUrlsDidChange()
    
}