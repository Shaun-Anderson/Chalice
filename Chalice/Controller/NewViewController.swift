import UIKit

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CardCellDelegate, UIGestureRecognizerDelegate {

    // MARK: - Variables
    
    var ruleSet: ResponseData?
    var deck = [Card]()
    // UI
    var informationView: InformationView?
    var progressTracker: ProgressView?
    var collectionView : UICollectionView?
    fileprivate var currentPage: Int = 0
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    var cardSelected: Bool?
    var currentCard: CardCell?
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck = generateDeck(ruleset: ruleSet!)!
        deck = deck.shuffled()
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height))
        statusBarView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.1)
        // Add King Tracker
        progressTracker = ProgressView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: 50, height: view.frame.height - UIApplication.shared.statusBarFrame.height))
        progressTracker?.fullImage = #imageLiteral(resourceName: "FilledKing")
        progressTracker?.emptyImage = #imageLiteral(resourceName: "EmptyCrown")
        progressTracker?.contentMode = UIViewContentMode.scaleAspectFit

        progressTracker?.type = .wholeRatings
        progressTracker?.rating = 4;
        
        self.view.addSubview(progressTracker!)

        self.addCollectionView()
        self.setupLayout()
        self.view.addSubview(statusBarView)

    }
    
//    override func viewDidLayoutSubviews() {
//        UIView.animate(withDuration: 3, delay: 0, animations: {
//            self.collectionView?.alpha = 1
//        })
//    }
    
    // MARK: - Other functions
    
    func addCollectionView(){
        self.view.backgroundColor = UIColor(red: 14/255, green: 1/255, blue: 26/255, alpha: 1)

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
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
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
        
        self.collectionView?.backgroundColor = UIColor.clear
        self.view.addSubview(self.collectionView!)
        
    }
    
    func generateDeck(ruleset: ResponseData) -> [Card]? {
        var tempDeck = [Card]()
        var index: Int = 0
        for i in 0...3 {
            for j in 0...ruleset.Cards.count-1 {
                var newCard: Card = ruleset.Cards[j]
                newCard.suit = SuitType.allValues[i]
                tempDeck.append(newCard)
                index += 1
            }
        }
        return tempDeck
    }
    
    func setupLayout(){
        self.currentPage = 2
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
        progressTracker?.cardsRemaining = deck.count
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
        collectionView?.isScrollEnabled = false
        cardSelected = true;
//        card.removeFromSuperview()
//        self.view.addSubview(card)
        print((self.collectionView?.contentOffset.y))
        //card.center.y = (self.view?.center.y)!
        print(card.frame)
        currentCard = card
        
        if(card.card?.rank == "K")
        {
            progressTracker?.rating -= 1
        }
        
        UIView.transition(with: card, duration: 0.5, options: [.transitionFlipFromLeft],
                          animations: {
//                            card.frame.size.width = self.view.frame.width - 5
//                            card.frame.size.height = self.view.frame.height - UIApplication.shared.statusBarFrame.height - 5
                            card.center.y = card.originalCenter.y
                            card.center.x = card.originalCenter.x
                            //card.frame = (self.view?.frame)!
                            self.view.layoutIfNeeded()
                            
        },
                          completion: { _ in
                            // TODO: CHANGE INFO FRAME
                            self.informationView = InformationView(frame: CGRect(x: 0, y: card.frame.height/2,width: card.frame.width, height: 0), card: card.card!)
                            card.addSubview(self.informationView!)
                            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                                self.informationView?.frame.size.height = card.frame.height / 2
                                self.informationView?.center.y = card.frame.height/2
                            }, completion: { _ in
                                self.informationView?.AnimateInUI()
                                card.revealed = true
                            })
        })
    }
    
    func DismissCard(card: CardCell) {
        self.collectionView?.isScrollEnabled = true
        self.cardSelected = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            card.center.x = 1000
        }, completion: nil)
        
        func delay(_ delay:Double, closure:@escaping ()->()) {
            let when = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        }
        
        delay(0.5, closure: {
            card.alpha = 0
            self.informationView?.removeFromSuperview()
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                if let indexPath = self.collectionView?.indexPath(for: card)
                {
                    print("DELETE \(indexPath.row)" + (card.card?.rank)!)
                    self.collectionView?.performBatchUpdates({ () -> Void in
                        self.deck.remove(at: indexPath.row)
                        self.collectionView?.deleteItems(at: [indexPath])
                        print("Cards Remaining: \(self.deck.count)")
                    }, completion: nil )
                }
            }, completion: nil)
            })
    }
    
}
