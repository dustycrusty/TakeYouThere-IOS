//
//  RequestStatusPageTableViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 19..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import Pring
import Firebase

struct RequestData {
    var opened = Bool()
    var request = Request()
}
class RequestStatusPageTableViewController: UITableViewController {
    
    var data = [RequestData]()
    var requests:DataSource<Request>?{
        didSet {
            data.removeAll()
            guard let requests:DataSource<Request> = requests else { return }
            for request in requests{
                data.append(RequestData(opened: false, request: request))
            }
        }
    }
    
    fileprivate func dataSourcePreservation(_ user: User) {
        self.requests = user.request.order(by: \Request.createdAt).dataSource()
            .on { (snapshot, changes) in
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
            }.listen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RequestStatusCell", bundle: nil), forCellReuseIdentifier: "RequestStatusCell")
        tableView.register(UINib(nibName: "RequestStatusCell_secondary", bundle: nil), forCellReuseIdentifier: "RequestStatusCell_secondary")
       
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            guard let user: User = user else { return }
            self.dataSourcePreservation(user)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if data[section].opened == true{
            return 2
        }
        else{
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestStatusCell", for: indexPath) as! RequestStatusCell
            configurePrimary(cell, atIndexPath: indexPath)
            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestStatusCell_secondary", for: indexPath) as! RequestStatusCell_secondary
            configureSecondary(cell, atIndexPath: indexPath)
            return cell
        }
       
        // Configure the cell...

            }
    
    func configurePrimary(_ cell: RequestStatusCell, atIndexPath indexPath: IndexPath) {
        guard let request: Request = self.data[indexPath.item].request else { return }
        request.driver?.get({ (driver, error) in
            guard let driver:Driver = driver else { return }
            cell.carName.text = driver.carModel
            cell.driverName.text = driver.FirstName! + " " + driver.lastName!
            cell.dateFromUntil.text = (request.pickUpTime?.toString())! + "~" + (request.endTime?.toString())!
            if request.status == .pending{
                cell.requestStatus.text = "Pending"
                cell.requestStatus.textColor = UIColor().mainBackgroundColor_Dark()
            }
            else if request.status == .accepted{
                cell.requestStatus.text = "Accepted"
                cell.requestStatus.textColor = UIColor.green
            }
            else{
                cell.requestStatus.text = "Rejected"
                cell.requestStatus.textColor = UIColor.red
            }
            
            
        })
        cell.disposer = request.listen { (request, error) in
            guard let request: Request = request else { return }
            if request.status == .pending{
                cell.requestStatus.text = "Pending"
                cell.requestStatus.textColor = UIColor().mainBackgroundColor_Dark()
            }
            else if request.status == .accepted{
                cell.requestStatus.text = "Accepted"
                cell.requestStatus.textColor = UIColor.green
            }
            else{
                cell.requestStatus.text = "Rejected"
                cell.requestStatus.textColor = UIColor.red
            }
        }
    }
    
    func configureSecondary(_ cell: RequestStatusCell_secondary, atIndexPath indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.section].opened == true{
            data[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
            
        }else{
            data[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
        }
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
