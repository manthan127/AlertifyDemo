//
//  ContentView.swift
//  tv
//
//  Created by PC on 12/02/24.
//

import SwiftUI
import AlertifySwift

struct ContentView: View {
    @Environment(\.alertify) var alertify
    let apiHandler = ApiHandler()
    @State var joke: DoubleJoke?

    var body: some View {
        List {
            jokesSection

            alertSection

            sheetSection

            processSection
        }
        .buttonStyle(.borderedProminent)
    }

    var jokesSection: some View {
        Section("Jokes from API") {
            Text("If you think Joke is offensive, blame the API")
                .font(.caption)

            if let joke = joke {
                Text(joke.setup)
                Text(joke.delivery)
            }

            Button("fetch Joke"){
                apiHandler.fetchJoke() { joke in
                    self.joke = joke
                }
            }

            Button("Show Joke in Alert") {
                apiHandler.showJoke()
            }
        }
    }

    var alertSection: some View {
        Section("Alert") {
            Button("Alert") {
                alertify.alert(title: "Alert", message: "Ta da!!")
            }

            Button("Alert without animation") {
                alertify.alert(
                    title: "Alert without Animation",
                    message: "without animation this looks weird",
                    animated: false
                )
            }

            Button("Action Sheet") {
                alertify.alert(
                    title: "Action Sheet",
                    message: "Action Sheet message here",
                    style: .actionSheet
                )
            }

            Button("Multiple Buttons"){
                alertify.alert(
                    title: "More Buttons",
                    message: "There are more buttons in here",
                    actions: [
                        UIAlertAction(title: "OK"),
                        UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                            print("Canceled somthing")
                        })
                    ])
            }

            Button("using AlertController") {
                let alert = UIAlertController(title: "Alert using AlertController", message: "customise it however you wish", preferredStyle: .alert)
                alertify.display(alert: alert)
            }
        }
    }

    var sheetSection: some View {
        Section("Sheet") {
            Button("Sheet") {
                alertify.present(view: SecondView(message: "Sheet Presented"))
            }

            Button("Stop dismiss on swipe-down") {
                alertify.present(
                    view: SecondView(message: "Only way out is that back on top of the screen"),
                    dismissOnSwipe: false
                )
            }

            Button("Without animation") {
                alertify.present(
                    view: SecondView(message: "Sheet Presented without animation"),
                    animated: false
                )
            }

            Button("Sheet from ViewController") {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let vc = storyboard.instantiateViewController(withIdentifier: "Viewcontroller")

                alertify.present(viewController: vc)
            }
        }
    }

    var processSection: some View {
        Section("Process") {
            Button("Process View for 2 seconds") {
                alertify.showProcessView()
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    alertify.removeProcessView()
                }
            }
        }
    }
}

struct SecondView: View {
    let message: String
    var body: some View {
        VStack {
            Button("< Back"){
                Alertify.shared.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])

            Spacer()
            Text(message)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
