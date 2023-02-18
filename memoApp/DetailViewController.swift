//
//  DetailViewController.swift
//  memoApp
//
//  Created by eun-ji on 2023/02/11.
//

import UIKit

class DetailViewController: UIViewController {
    
    var receiveItem = ""
    var idx = 0
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    @IBOutlet weak var tfItem: UITextView!
    
 
    
    deinit {
        if let token = willShowToken{
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tfItem.text = receiveItem
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf  = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.tfItem.contentInset
                inset.bottom = height
                strongSelf.tfItem.contentInset = inset
                
                inset = strongSelf.tfItem.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.tfItem.verticalScrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {return}
            
            var inset = strongSelf.tfItem.contentInset
            inset.bottom = 0
            strongSelf.tfItem.contentInset = inset
            
            inset = strongSelf.tfItem.verticalScrollIndicatorInsets
            inset.bottom = 0
            strongSelf.tfItem.verticalScrollIndicatorInsets = inset
            
            
        })
    }
    
    func receiveItem(_ item: String)
    {
        receiveItem = item
    }
    
    func receiveIdx(_ index: Int) {
        idx = index
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tfItem.resignFirstResponder()
        
        if self.isMovingFromParent {
            saveData()
        }
    }
    
    private func saveData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if tfItem.text.isEmpty {
            context.delete(items[idx])
            items.remove(at: idx)
            try? context.save()
            return
        }
        
       
        let newItem = MemoEntity(context: context)
        
        
        newItem.contents = tfItem.text!
        newItem.date = Date()
        items.insert(newItem, at: idx)
        
        context.delete(items[idx + 1])
        
        
        do {
            try context.save()
        }
        catch {
        }
        items.remove(at: idx + 1)
        
        
        itemsDate.insert(newItem, at: idx)
        itemsDate.remove(at: idx + 1)
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
