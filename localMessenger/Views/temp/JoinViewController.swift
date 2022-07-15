//
//  JoinViewController.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/13/22.
//

import UIKit

struct Message {
    let text: String
    let isSender: State
    enum State {
        case sender, receiver
    }
}

class JoinViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    var labelSize: CGSize = CGSize.zero
    var messages: [Message] = []
    @IBAction func send() {
        messages.insert(Message(text: textField.text!, isSender: .sender), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    private let sectionInsets = UIEdgeInsets(
        top: 50,
        left: 20,
        bottom: 50,
        right: 20)
    private let itemsPerRow: CGFloat = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        var nib = UINib(nibName: "MessageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "receive")
        nib = UINib(nibName: "SendCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "send")
        let message1 = Message(text: "Hello", isSender: .sender)
        let message2 = Message(text: "Hi", isSender: .receiver)
        messages.insert(message1, at: 0)
        messages.insert(message2, at: 0)
        // Do any additional setup after loading the view.
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

extension JoinViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "message", for: indexPath) as? JoinCollectionViewCell
            cell?.backgroundColor = .green

        cell?.body.text = messages[indexPath.row].text
        cell?.body.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        switch messages[indexPath.row].isSender {
        case .sender:
            cell?.image.image = R.image.sentMessage()
//            cell?.image.alignmentRectInsets = UIEdgeInsets
        case .receiver:
            cell?.image.image = R.image.receivedMessage()
        }
        return cell!
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}
extension JoinViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

