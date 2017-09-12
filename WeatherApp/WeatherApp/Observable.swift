import Foundation

class Observable<T> {
	private var instance : T? = nil
	
	var value: T? {
		get{
			return instance;
		}
		set (newItem) {
			instance = newItem
			for listener in listeners {
				listener(instance)
			}
		}
	}
	
	private var listeners = [(T?) -> Void]()
	
	func addListener(handler: @escaping (T?) -> Void){
		listeners.append(handler)
	}
}
