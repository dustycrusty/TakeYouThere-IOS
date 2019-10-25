//
//  CardTableViewController.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 13..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit
import Stripe
import Firebase

class CardTableViewController: UITableViewController, STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: nil)
    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        submitTokenToBackend(token, completion: { (error: Error?) in
            if let error = error {
                // Show error in add card view controller
                completion(error)
            }
            else {
                // Notify add card view controller that token creation was handled successfully
                completion(nil)
                
                // Dismiss add card view controller
                addCardViewController.dismiss(animated: true)
            }
        })
    }
    
    func submitTokenToBackend(_ token:STPToken, completion: @escaping ((Error?)->Void)){
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            if let error = error {
                completion(error)
            }
            else{
                let doc = user?.reference.collection("tokens").document()
                doc?.setData(["token":token.allResponseFields], merge: true, completion: { (error) in
                    completion(error)
                })
            
            }
        }
    }
    var cellData:[STPSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func addTapped(){
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let tokenSearchQueue = DispatchQueue(label: "com.card.token.SearchQueue", attributes: DispatchQueue.Attributes.concurrent)
        cellData.removeAll()
        tokenSearchQueue.sync {
            User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
                if user?.tokens != nil{
                    for token in user?.tokens as? [String:String] ?? [:] {
                        TYTAPIClient().retrieveSource(withId:token.value, clientSecret: "pk_test_H97aLUMq6WNCjTxKFK32nrbk", completion: { (source, error) in
                            self.cellData.append(source!)
                        })
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexCellData = cellData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        cell.expirationDate.text = String((indexCellData.cardDetails?.expMonth)!) + "/" + String((indexCellData.cardDetails?.expYear)!)
        // Configure the cell...
        cell.cardImage.image = indexCellData.image
        cell.last4.text = "XXXX XXXX XXXX " + (indexCellData.cardDetails?.last4)!
        cell.cardType.text = indexCellData.label
        return cell
 }

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
