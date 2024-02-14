import UIKit
import AlertifySwift

class ApiHandler {
    let alertify = Alertify.shared
    let singleURL = URL(string: "https://v2.jokeapi.dev/joke/Programming?type=single")
    let twopartURL = URL(string: "https://v2.jokeapi.dev/joke/Programming?type=twopart")

    func fetchJoke(complition: @escaping (DoubleJoke)-> Void)  {
        guard let url = twopartURL else {return}
        alertify.showProcessView()

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.presentAlert(withError: error, complition: complition)
                return
            }
            guard let jokeData = data else {return}
            do {
                let joke = try JSONDecoder().decode(DoubleJoke.self, from: jokeData)
                complition(joke)
                self.alertify.removeProcessView()
            } catch {
                self.alertify.alert(message: "could not decode data")
            }
        }.resume()
    }

    func showJoke() {
        guard let url = singleURL else {return}
        alertify.showProcessView()

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.alertify.alert(title: "Error occurred", error: error)
                return
            }
            guard let jokeData = data else {return}
            do {
                let joke = try JSONDecoder().decode(SingleJoke.self, from: jokeData)

                self.alertify.alert(message: joke.joke)
                self.alertify.removeProcessView()
            } catch {
                self.alertify.alert(message: "could not decode data")
            }

        }.resume()
    }

    func presentAlert(withError error: Error, complition: @escaping (DoubleJoke)-> Void) {
        print(error.localizedDescription)
        alertify.alert(
            title: "Error occurred",
            error: error,
            actions: [
                UIAlertAction(title: "Retry", handler: { [weak self] _  in
                    self?.fetchJoke(complition: complition)
                    self?.alertify.removeProcessView()
                }),
                UIAlertAction(title: "OK")
            ]
        )
    }
}

struct SingleJoke: Codable {
    var joke: String
}

struct DoubleJoke: Codable {
    var setup: String
    var delivery: String
}
