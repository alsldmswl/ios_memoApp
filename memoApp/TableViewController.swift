//
//  TableViewController.swift
//  memoApp
//
//  Created by eun-ji on 2023/02/11.
//

import UIKit
import CoreData

var items = [MemoEntity]()
var itemsDate = [MemoEntity]()


class TableViewController: UITableViewController {
    
    var container: NSPersistentContainer!
    
    @IBOutlet var tvListView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //왼쪽에 edit 버튼 생성, 목록삭제 가능
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            items = try context.fetch(MemoEntity.fetchRequest())
            itemsDate = try context.fetch(MemoEntity.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // error
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tvListView.reloadData()
    }
    // MARK: - Table view data source
    
    // 보여지는 섹션
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // 보여지는 목록 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    // 목록 추가
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = items[(indexPath as NSIndexPath).row].contents
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        cell.detailTextLabel?.text  = formatter.string(from: Date())
        cell.detailTextLabel?.text = formatter.string(from: itemsDate[(indexPath as NSIndexPath).row].date ?? Date())
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view. 오른쪽으로 밀어서 아이템 삭제하기
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(items[(indexPath as NSIndexPath).row])
            do {
                try context.save()
            }
            catch {
                
            }
            // Delete the row from the data source
            items.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view. 아이템 순서 이동
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = items[(fromIndexPath as NSIndexPath).row]
        
        items.remove(at: (fromIndexPath as NSIndexPath).row)
        items.insert(itemToMove, at: (to as NSIndexPath).row)
    }
    */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveItem(items[((indexPath! as NSIndexPath).row)].contents ?? "none")
            detailView.receiveIdx(indexPath?.row ?? 0)
        }
    }
    
    
    
    
}
