//
//  AddArticleViewController.swift
//  d09
//
//  Created by Jimmy CHEN-MA on 10/12/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit
import jichen_m2018

class AddArticleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var articles:ArticleManager?
    let pickerController = UIImagePickerController()
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var img: UIImageView!
    
    @IBAction func cameraPhoto(_ sender: UIButton)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func usePhotoLibrary(_ sender: UIButton)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img.contentMode = .scaleAspectFit
            img.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem)
    {
        if (titleText.text != "" && detailText.text != "")
        {
            // TODO : need to create new article and save
            let langStr = Locale.current.languageCode
            if let i = img.image
            {
               let _ = articles?.newArticle(title: titleText.text!, content: detailText.text!, language: langStr!, image: UIImagePNGRepresentation(i) as NSData?)
                articles?.save()
            }
            else
            {
                let _ = articles?.newArticle(title: titleText.text!, content: detailText.text!, language: langStr!, image: nil)
                articles?.save()
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Must have a title and a description.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        performSegue(withIdentifier: "addArticleUnwindSegue", sender: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailText?.layer.borderWidth = 1
        detailText?.layer.borderColor = UIColor.black.cgColor
        detailText?.layer.cornerRadius = 5.0
        titleText?.layer.borderWidth = 1
        titleText?.layer.borderColor = UIColor.black.cgColor
        titleText?.layer.cornerRadius = 5.0
        
        pickerController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
