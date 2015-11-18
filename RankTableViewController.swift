//
//  RankTableViewController.swift
//  ColorSpeed
//
//  Created by Eddie on 11/17/15.
//  Copyright © 2015 Wen. All rights reserved.
//

import UIKit
import SwiftyJSON

class RankTableViewController: UITableViewController {

    var rankJSON: JSON!
    var dataLoaded: Bool = false
    let reachability = Reachability()
    let userP = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = 70
        
        // Check should I download new rank data
        let httpRequest = NSMutableURLRequest(URL: NSURL( string: "http://eddiewen.me/colorspeed/backend/anythingNew.php" )!)
        httpRequest.HTTPMethod = "POST"
        let getJsonTask = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest ) { (response, data, error) in

            if error == nil {
            }

        }
        getJsonTask.resume()
    }

    func updateLocalRank() {

        let httpRequest = NSMutableURLRequest(URL: NSURL( string: "http://eddiewen.me/colorspeed/backend/read.php" )!)
        httpRequest.HTTPMethod = "GET"
        let getJsonTask = NSURLSession.sharedSession().dataTaskWithRequest( httpRequest ) { (response, data, error) in

            if error == nil {
                self.dataLoaded = true
                self.rankJSON = JSON( data: response! )

                self.tableView.reloadData()

                // Save to UserPreference
                self.userP.setValue( NSString(data: response!, encoding: NSUTF8StringEncoding), forKey: "json")
                self.saveCurrentTime()
            }

        }

        getJsonTask.resume()

    }

    func saveCurrentTime() {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()

        let currentTime = dateFormatter.stringFromDate( NSDate() )

        // Save to UserPreference
        self.userP.setValue( currentTime, forKey: "time" )

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RankTableViewCell

        // Configure the cell...
        if self.dataLoaded {

            cell.username.text = self.rankJSON[indexPath.row]["user"].string
            cell.time.text = self.rankJSON[indexPath.row]["time"].string
            if let fbid = self.rankJSON[indexPath.row]["fb_id"].string {
                let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=small")!
                self.reachability.getImageFromUrl( url, completion: { (data, response, error) in
                    if data != nil {
                        dispatch_async( dispatch_get_main_queue(), {
                            cell.userSticker.image = UIImage(data: data!)
                        })
                    }
                })
            }

        }

        return cell
    }

    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
