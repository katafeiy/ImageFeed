import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func data(for request: URLRequest, completion: @escaping Closure.ClosureResultDataError) -> URLSessionTask {
    
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
                }
            } else if let error = error {
                fullCompletionOnTheMainTread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fullCompletionOnTheMainTread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}




