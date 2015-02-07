import Foundation
import HealthKit

extension ThisDeviceSession {
    
    class HealthKit {
        let store: HKHealthStore!
        var heartRateQuery: HKObserverQuery?
        
        init() {
            let readTypes: NSSet = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate))
            let shareTypes: NSSet = NSSet()
            let store = HKHealthStore()
            let hr = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            store.requestAuthorizationToShareTypes(shareTypes, readTypes: readTypes) { (x, err) in
                store.enableBackgroundDeliveryForType(hr, frequency: HKUpdateFrequency.Immediate, withCompletion: { (x, err) in
                    self.heartRateQuery = HKObserverQuery(sampleType: hr, predicate: NSPredicate(), updateHandler: self.heartRateUpdateHandler)
                    self.store.executeQuery(self.heartRateQuery!)
                })
            }
        }
        
        func stop() {
            store.stopQuery(heartRateQuery?)
        }
        
        func heartRateUpdateHandler(query: HKObserverQuery!, completion: HKObserverQueryCompletionHandler!, error: NSError!) {
            NSLog("Got HR")
        }
        
    }
    
}