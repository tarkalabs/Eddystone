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
    var beaconTimers = [NSUUID: NSTimer]()
    
    
    //MARK: Class
    public class func start(delegate: ScannerDelegate) {
        
        self.shared.centralManager = CBCentralManager(delegate: self.shared, queue: nil)
        self.shared.delegate = delegate
        
    }
    
    public class var urls: [Url] {
        get {
            var urls: [Url] = []
            
            
            for beacon in self.beacons {
                if let beacon = beacon as? UrlBeacon {
                    var url = Url(url: beacon.url, signalStrength: beacon.signalStrength)
                    urls.append(url)
                }
            }
            
            return urls
        }
    }
    
    class var beacons: [Beacon] {
        get {
            var orderedBeacons = [Beacon]()
            
            for (identifier, beacon) in self.shared.discoveredBeacons {
                orderedBeacons.append(beacon)
            }
            
            orderedBeacons.sort { beacon1, beacon2 in
                return beacon1.accuracy < beacon2.accuracy
            }
            
            return orderedBeacons
        }
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
        
        self.beaconTimers[peripheral.identifier]?.invalidate()
        self.beaconTimers[peripheral.identifier] = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("beaconTimerExpire:"), userInfo: peripheral.identifier, repeats: false)
    }
    
    @objc func beaconTimerExpire(timer: NSTimer) {
        if let identifier = timer.userInfo as? NSUUID {
            log("Beacon lost")
            
            self.discoveredBeacons.removeValueForKey(identifier)
            self.delegate?.eddystoneUrlsDidChange()
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