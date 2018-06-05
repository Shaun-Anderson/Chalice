import UIKit

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CardCellDelegate, UIGestureRecognizerDelegate {

    // MARK: - Variables
    
    var deck = [Card]()
    var informationView: InformationView?
    var cardSelected: Bool?
    var currentCard: CardCell?
    var collectionView : UICollectionView?
    fileprivate var currentPage: Int = 0
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck = loadJson(filename: "Cards") as! [Card]
        deck = deck.shuffled()
        self.addCollectionView()
        self.setupLayout()
        
    }
    
    // MARK: - Other functions
    
    func addCollectionView(){
        
        // This is just an utility custom class to calculate screen points
        // to the screen based in a reference view. You can ignore this and write the points manually where is required.
        let pointEstimator = RelativeLayoutUtility(referenceFrameSize: self.view.frame.size)
        
        let layout = UPCarouselFlowLayout()
        layout.minimumLineSpacing = -44
        // This is used for setting the cell size (size of each view in this case)
        // Here I'm writting 400 points of height and the 73.33% of the height view frame in points.
        //layout.itemSize = CGSize(width: pointEstimator.relativeWidth(multiplier: 0.73333), height: 500)
        layout.itemSize = CGSize(width:300, height: 500)

        // Setting the scroll direction
        layout.scrollDirection = .vertical
        
        // Collection view initialization, the collectionView must be
        // initialized with a layout object.
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.frame.width, height: view.frame.height - UIApplication.shared.statusBarFrame.height), collectionViewLayout: layout)
        // This line if for able programmatic constrains.
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        // CollectionView delegates and dataSource:
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        // Registering the class for the collection view cells
        self.collectionView?.register(CardCell.self, forCellWithReuseIdentifier: "cellId")
        
        // Spacing between cells:
        let spacingLayout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 100)
        
        self.collectionView?.backgroundColor = UIColor.gray
        self.view.addSubview(self.collectionView!)
        
    }
    
    func loadJson(filename fileName: String) -> [Card]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            print("NADS")
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                var tempDeck = [Card]()
                print(jsonData.Cards.count)
                var index: Int = 0
                for i in 0...3 {
                    for j in 0...jsonData.Cards.count-1 {
                        var newCard: Card = jsonData.Cards[j]
                        newCard.suit = SuitType.allValues[i]
                        tempDeck.append(newCard)
                        print("NEW CARD: \(newCard.rank) : \(newCard.suit)")
                        index += 1
                    }
                }
                return tempDeck
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func setupLayout(){
        self.currentPage = 0
    }
    
    // MARK: - GestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CardCell
        cell.revealed = false
        cell.card = deck[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    // MARK: - CardCellDelegate
    
    func RevealCard(view: UIView, card: CardCell) {
        cardSelected = true;
        //card.removeFromSuperview()
        //self.view.addSubview(card)
        print((self.collectionView?.contentOffset.y))
        //card.center.y = (self.view?.center.y)!
        print(card.frame)
        currentCard = card
        
        UIView.transition(with: card, duration: 1, options: [.transitionFlipFromLeft],
                          animations: {
                            card.frame.size.width = self.view.frame.width - 5
                            card.frame.size.height = self.view.frame.height - UIApplication.shared.statusBarFrame.height - 5
                            card.center.y = card.originalCenter.y
                            card.center.x = card.originalCenter.x
                            //card.frame = (self.view?.frame)!
                            self.view.layoutIfNeeded()
                            
        },
                          completion: { _ in
                            // TODO: CHANGE INFO FRAME
                            self.informationView = InformationView(frame: CGRect(x: 0, y: self.view.frame.height,width: self.view.frame.width, height: 0), card: card.card!)
                            self.view.addSubview(self.informationView!)
                            UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: {
                                self.informationView?.frame.size.height = self.view.frame.height / 2
                                self.informationView?.center.y = self.view.frame.height - (self.informationView?.frame.height)!/2
                            }, completion: { _ in
                                self.informationView?.AnimateInUI()
                                card.revealed = true
                            })
        })
    }
    
    func DismissCard(card: CardCell) {
        print("DIE")
        self.cardSelected = false
        UIView.transition(with: self.informationView!, duration: 1, options: [],
                          animations: {
                            self.informationView?.frame.size.height = 0
                            self.informationView?.center.y = self.view.frame.height - (self.informationView?.frame.height)!/2
        },
                          completion: { _ in
                            self.informationView?.removeFromSuperview()
        })
        
        if let indexPath = self.collectionView?.indexPath(for: card)
        {
            print("DELETE \(indexPath.row)" + (card.card?.rank)!)
            self.collectionView?.performBatchUpdates({ () -> Void in
                let indexPaths = [NSIndexPath]()
                self.deck.remove(at: indexPath.row)
                self.collectionView?.deleteItems(at: [indexPath])
                self.collectionView?.reloadData()
                print("Cards Remaining: \(self.deck.count)")
            }, completion: nil )
            
            UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
                self.currentCard?.removeFromSuperview()
                self.cardSelected = false;
            }, completion: nil)
        }
    }
    
}
