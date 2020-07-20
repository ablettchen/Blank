//
//  BlankExtensions.swift
//  Blank
//
//  Created by ablett on 2020/7/20.
//

public extension UIImage {

    static func inBlank(named name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.blank(), compatibleWith: nil)
    }
}

public extension Bundle {
    
    static func blank() -> Bundle? {
        if let bundlePath = Bundle(for: Blank.self).resourcePath?.appending("/Blank.bundle") {
            return Bundle(path: bundlePath)
        }
        return nil
    }
}

extension UIScrollView {
    
    public func itemsCount() -> (Int) {
        
        var items = 0
        
        if let tableView = self as? UITableView {
            
            var sections = 1
            
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: tableView)
                }
                if dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.tableView(tableView, numberOfRowsInSection: i)
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            
            var sections = 1
            
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: collectionView)
                }
                if dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.collectionView(collectionView, numberOfItemsInSection: i)
                    }
                }
            }
        }
        
        return items
    }
}
