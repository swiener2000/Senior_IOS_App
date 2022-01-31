//
//  TrendsViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/29/22.
//

import UIKit

class TrendsViewController: UIViewController {

    var dates: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dates = getDates()
        // Do any additional setup after loading the view.
    }
    @IBAction func backToHome2(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }

    func getDates() -> [String]{
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var dateArray = [String]()
        for i in 1 ... 7 {
            let day = cal.component(.day, from: date)
            let month = cal.component(.month, from: date)
            let year = cal.component(.year, from: date)
            let dates = "\(month)/\(day)/\(year)"
            dateArray.append(dates)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        dateArray.reverse()
        print(dateArray)
        return dateArray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
