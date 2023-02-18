//
//  AddViewController.swift
//  memoApp
//
//  Created by eun-ji on 2023/02/11.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var tfAddItem: UITextView!
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    //소멸자
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
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf  = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.tfAddItem.contentInset
                inset.bottom = height
                strongSelf.tfAddItem.contentInset = inset
                
                inset = strongSelf.tfAddItem.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.tfAddItem.verticalScrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {return}
            
            var inset = strongSelf.tfAddItem.contentInset
            inset.bottom = 0
            strongSelf.tfAddItem.contentInset = inset
            
            inset = strongSelf.tfAddItem.verticalScrollIndicatorInsets
            inset.bottom = 0
            strongSelf.tfAddItem.verticalScrollIndicatorInsets = inset
            
            
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tfAddItem.becomeFirstResponder()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tfAddItem.resignFirstResponder()

        if self.isMovingFromParent {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newItem = MemoEntity(context: context)
            
            if !tfAddItem.text.isEmpty {
                newItem.contents = tfAddItem.text!
                newItem.date = Date()
                
                do {
                    try context.save()
                }
                catch {
                }
                
                items.append(newItem)
                itemsDate.append(newItem)
                
                tfAddItem.text = ""
            }
            
    }

           
    }


}
