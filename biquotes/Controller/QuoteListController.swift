//
//  QuoteListController.swift
//  biquotes
//
//  Created by 1 on 12/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import CoreData

class QuoteListController: UITableViewController, QuoteViewControllerDelegate {
    
    
    @IBOutlet weak var favSelector: UISegmentedControl!
    
    @IBAction func favTapped(_ sender: UISegmentedControl) {
        updateQuotes()
    }
    
    //MARK: Properties
    
    private enum CellIdentifiers {
        static let quoteCell = "quoteCell"
    }
    
    private var quotes = [Quote]()
    
    var searchController: UISearchController!
    
    var currentIndex: Int?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            //navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
        updateQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateQuotes()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.quoteCell, for: indexPath)
        
        let quote = quotes[indexPath.row]
            cell.textLabel?.text = quote.body
            cell.detailTextLabel?.text = "\(quote.author?.name ?? "") \(quote.author?.surname ?? "")"
        
        return cell
    }
    
    //MARK: TableView delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "showQuote":
                if  let quoteViewController = segue.destination as? QuoteViewController {
                    if let selectedQuoteCell = sender as? UITableViewCell {
                        if let indexPath = tableView.indexPath(for: selectedQuoteCell) {
                            quoteViewController.quotes = quotes
                            quoteViewController.currentIndex = indexPath.row
                            quoteViewController.delegate = self
                        }
                    }
                }
                
            default:
                print("unexpected segue identifier \(identifier)")
            }
        }
    }
    
    //MARK: CoreData
    private lazy var fetchedResultController: NSFetchedResultsController<Quote> = {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let bodyDescriptor = NSSortDescriptor(key: "body", ascending: true)
        fetchRequest.sortDescriptors = [bodyDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    func updateQuotes() {
        let searchBarIsEmpty = searchController.searchBar.text?.isEmpty ?? true
        let scopeAll = favSelector.selectedSegmentIndex == 0
        
        if searchBarIsEmpty && scopeAll {
            fetchedResultController.fetchRequest.predicate = nil
        } else {
            var predicates = [NSPredicate]()
            
            if !searchBarIsEmpty {
                let strippedString = searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
                let bodyPredicate = NSPredicate(format: "body CONTAINS[c] %@", strippedString)
                let namePredicate = NSPredicate(format: "author.name CONTAINS[c] %@", strippedString)
                let surnamePredicate = NSPredicate(format: "author.surname CONTAINS[c] %@", strippedString)
                let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [bodyPredicate, namePredicate, surnamePredicate])
                predicates.append(orPredicate)
            }
            
            if !scopeAll {
                let favPredicate = NSPredicate(format: "favorite == true")
                predicates.append(favPredicate)
            }
            
            let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

            fetchedResultController.fetchRequest.predicate = andPredicate
        }
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let results = fetchedResultController.fetchedObjects {
            quotes = results
        }
        
        tableView.reloadData()
        if let index = currentIndex, index > -1, index < quotes.count {
            tableView.scrollToRow(at: IndexPath(item: index, section: 0), at: .top, animated: true)
        }
    }
}

extension QuoteListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateQuotes()
    }
}
