import UIKit


extension URLSession {
    
    func data(for request: URLRequest,
              completion: @escaping Closure.ClosureResultDataError
    ) -> URLSessionTask {
        
        let fullCompletionOnTheMainTread: Closure.ClosureResultDataError = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    fullCompletionOnTheMainTread(.success(data))
                } else {
                    fullCompletionOnTheMainTread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("[data -> dataTask]:[Incorrect DATA]:[Invalid HTTP Status Code:\(NetworkError.httpStatusCode(statusCode))]")
                }
            } else if let error = error {
                fullCompletionOnTheMainTread(.failure(NetworkError.urlRequestError(error)))
                print("[data -> dataTask]:[Incorrect DATA]:[URLRequest error:\(error.localizedDescription)]")
            } else {
                fullCompletionOnTheMainTread(.failure(NetworkError.urlSessionError))
                print("[data -> dataTask]:[Incorrect DATA]:[URLSession error:\(NetworkError.urlSessionError)]")
            }
        })
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                    print("[objectTask -> data]:[Invalid JSON]:[Error:\(error.localizedDescription)], Данные: \(String(data: data, encoding: .utf8) ?? "")")
                }
            case .failure(let error):
                completion(.failure(error))
                print("[objectTask -> data]:[Invalid JSON]:[Error:\(error.localizedDescription)]")
            }
        }
        return task
    }
}


