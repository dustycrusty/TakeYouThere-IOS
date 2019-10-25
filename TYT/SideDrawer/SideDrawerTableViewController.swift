//
//  SideDrawerTableViewController.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 10..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit
import Stripe
import Firebase

class SideDrawerTableViewController: UITableViewController, STPPaymentMethodsViewControllerDelegate, STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let card = paymentContext.selectedPaymentMethod as? STPCard {
            let token = card.stripeID
//            card.allResponseFields
            User.get(Auth.auth().currentUser!.uid) { (user, error) in
                let doc = user?.reference.collection("tokens").document()
                doc?.setData(card.allResponseFields as! [String : Any], merge: true)
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {

    }
    
    
    
    
    var user:User?
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        print(error)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        print("IM HERE")
//        paymentMethodsViewController.navigationController?.popViewController(animated: true)
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
//        dismiss(animated: true)
    }
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                self.user = user
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        if cell.textLabel!.text == "Payment"{
            print("OK")
            User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                else{
                    let config = STPPaymentConfiguration()
                    //            config.requiredBillingAddressFields = .full
                    config.requiredBillingAddressFields = .none
                    config.requiredShippingAddressFields = nil
                    config.publishableKey = "pk_test_H97aLUMq6WNCjTxKFK32nrbk"
                    let client = TYTAPIClient.sharedClient
                    client.baseURLString = "https://us-central1-tytproject-7850d.cloudfunctions.net"
//                    print("CUSTOMER ID: ", user?.stripe_userId)
                    config.appleMerchantIdentifier = "dummy-merchant-id"
                    config.createCardSources = false
                    let paymentContext = STPPaymentContext(customerContext: STPCustomerContext(keyProvider: client), configuration: config, theme: STPTheme())
                    paymentContext.hostViewController = self
                    paymentContext.delegate = self
                    paymentContext.presentPaymentMethodsViewController()
                    
                    //                    let viewController = STPPaymentMethodsViewController(configuration: config, theme: STPTheme(), customerContext: STPCustomerContext(keyProvider: client), delegate: self)
//                    let navigationController = UINavigationController(rootViewController: viewController)
//                    self.present(navigationController, animated: true, completion: nil)
                }
            
        }
    }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
