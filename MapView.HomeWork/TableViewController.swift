//
//  TableViewController.swift
//  MapView.HomeWork
//
//  Created by Садыбек Мырзалиев on 25.10.2026.
//

import UIKit

class TableViewController: UITableViewController {
    

    var arrayHotels = [NameOfHotels(nameOfHotels: "Comfort Inn Sunnyvale", addresOfHotels: "940 West Weddel Drive", images: "Comfort Inn", lat: 37.3997268, long: -122.0259636),
                       
    NameOfHotels(nameOfHotels: "Hilton Garden Inn Cupertino", addresOfHotels: "10741 North Wolfe Road, Cupertino, CA 95014, USA", images: "Hilton Garden", lat: 37.3334351, long: -122.0148656),
                       
    NameOfHotels(nameOfHotels: "Wild Palms Hotel", addresOfHotels: "910 E Fremont Ave, Sunnyvale, CA 94087, США", images: "Wild Palms", lat: 37.957666, long: -122.0323133)
                       
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayHotels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let label = cell.viewWithTag(1000) as! UILabel
        label.text = arrayHotels[indexPath.row].nameOfHotels
        
        let imageView = cell.viewWithTag(1001) as! UIImageView
        imageView.image = UIImage(named: arrayHotels[indexPath.row].images)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 213
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        vc.hotels = arrayHotels[indexPath.row]
        
        navigationController?.show(vc, sender: self)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
