import Foundation

enum CryptoError: Error {
    case serverError
    case parsingError
}

class WebService {
    
    func downloadCurrencies(url: URL, completionHandler: @escaping (Result<[Crypto], CryptoError>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completionHandler(.failure(.serverError))
            } else if let data = data {
                do {
                    let cryptoList = try JSONDecoder().decode([Crypto].self, from: data)
                    completionHandler(.success(cryptoList))
                } catch {
                    completionHandler(.failure(.parsingError))
                }
            } else {
                completionHandler(.failure(.serverError))
            }
            
        }.resume()
    }
    
}


