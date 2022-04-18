

import Foundation

struct NetworkService {
    
    
    static func fetchURLTask(_ address: String) {
        guard let rURL = URL(string: address) else {
            print("Cannot create URL")
            return
        }
        URLSession.shared.dataTask(with: rURL) { data, response, error in
            if let unwrappedData =  data {
                if let converted = String(data: unwrappedData, encoding: .utf8) {
                    print(converted)
                }
            }
            if let httpResponse = response  as? HTTPURLResponse {
                print(httpResponse.statusCode)
                print(httpResponse.allHeaderFields)
            }
            if error != nil {
                
                print(error!.localizedDescription)
            }
        }.resume()
    }
    
}
