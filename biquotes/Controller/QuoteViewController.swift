//
//  QuoteViewController.swift
//  biquotes
//
//  Created by 1 on 12/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var quotes = [Quote]()
    var currentIndex: Int!
    
    var quote: Quote?
    
    var delegate: QuoteViewControllerDelegate?

    @IBAction func favTapped(_ sender: UIBarButtonItem) {
        saveFav()
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        if let text = quote?.body, let name = quote?.author?.name, let surname = quote?.author?.surname {
            let sharedText = "\(text) \(name) \(surname)"
            let activityController = UIActivityViewController(activityItems: [sharedText], applicationActivities: [])
            activityController.popoverPresentationController?.barButtonItem = shareButton
            present(activityController, animated: true)
        }
    }
    
    @IBAction func handleTap(_ recognizer: UITapGestureRecognizer) {
        saveFav()
    }
    
    
    @IBAction func handleSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            nextIndex()
        }
    }

    @IBAction func handleLeftSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            prevIndex()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.getCurrentColor()
        
        quote = quotes[currentIndex]
        setQuote()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.currentIndex = currentIndex
        super.viewWillDisappear(animated)
    }
    
    func setQuote() {
        if let quote = quote {
            bodyLabel.text = quote.body
            authorLabel.text = "\(quote.author?.name ?? "") \(quote.author?.surname ?? "")"
            setFavButton()
        }
    }
    
    func nextIndex() {
        let newIndex = currentIndex + 1
        if newIndex < quotes.count {
            currentIndex = newIndex
            quote = quotes[newIndex]
            setQuote()
        }
    }
    
    func prevIndex() {
        let newIndex = currentIndex - 1
        if newIndex > -1 {
            currentIndex = newIndex
            quote = quotes[newIndex]
            setQuote()
        }
    }
    
    func saveFav() {
        if let quote = quote {
            quote.favorite = !quote.favorite
            CoreDataStack.saveContext()
            setFavButton()
        }
    }
    
    func setFavButton() {
        if let quote = quote {
            if quote.favorite {
                favButton.image = UIImage(named: "heart-full")
            } else {
                favButton.image = UIImage(named: "heart")
            }
        }
    }
}

extension QuoteViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol QuoteViewControllerDelegate {
    var currentIndex: Int? {get set}
}
