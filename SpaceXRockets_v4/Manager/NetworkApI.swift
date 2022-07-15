import Foundation

enum NetworkManagerError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}

class NetworkAPI {

    let cachedImage = NSCache<NSString, NSData>()
    let decoder = JSONDecoder()
    let session: URLSession
    static let shared = NetworkAPI()

    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    func getRockets<T: Decodable>(dataType: T.Type, completion: @escaping(T) -> Void) {
        guard let urlString = URL(string: "https://api.spacexdata.com/v4/rockets") else { return }

        URLSession.shared.dataTask(with: urlString) { data, _, error in
            guard let data = data else {
                print(error ?? "error getting data")
                return
            }
            do {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                let rocketData = try self.decoder.decode(T.self, from: data)
                completion(rocketData)
            } catch {
                print("Error fetching data - \(error.localizedDescription)")
            }
        }.resume()
    }

    func getLaunches(completion: @escaping (Result<[LaunchDates], Error>) -> Void) {
        let urlString = "https://api.spacexdata.com/v4/launches"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let launches = try self.decoder.decode([LaunchDates].self, from: data)
                    completion(.success(launches))
                } catch let jsonError {
                    print(jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }

    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
      if let imageData = cachedImage.object(forKey: imageURL.absoluteString as NSString) {
        print("using cached images")
        completion(imageData as Data, nil)
        return
      }

      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
        if let error = error {
          completion(nil, error)
          return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          completion(nil, NetworkManagerError.badResponse(response))
          return
        }

        guard let localUrl = localUrl else {
          completion(nil, NetworkManagerError.badLocalUrl)
          return
        }

        do {
          let data = try Data(contentsOf: localUrl)
          self.cachedImage.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
          completion(data, nil)
        } catch let error {
          completion(nil, error)
        }
      }

      task.resume()
    }

    func image(post: RocketModel, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: post.flickrImages.randomElement()!)!
      download(imageURL: url, completion: completion)
    }
}