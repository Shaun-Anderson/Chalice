import UIKit

class MainViewController: UIViewController {

    // MARK: - Variables
    var pauseMenu: UIView!
    var pauseButton : UIButton?
    var ruleSet: ResponseData?
    var deck = [Card]()
    var tempDeck = [Int]()
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
        pauseMenu = UIView(frame: .zero)
        super.viewDidLoad()
        
        deck = generateDeck(ruleset: ruleSet!)!.filter({$0.rank == "K"})
        //deck = deck.shuffled()
        
        // Status bar view
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height))
        statusBarView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.1)
        
        // Add King Tracker
        progressTracker = ProgressView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: 50, height: view.frame.height - UIApplication.shared.statusBarFrame.height))
        progressTracker?.fullImage = #imageLiteral(resourceName: "FilledKing")
        progressTracker?.emptyImage = #imageLiteral(resourceName: "EmptyCrown")
        progressTracker?.contentMode = UIViewContentMode.scaleAspectFit
        progressTracker?.type = .wholeRatings
        progressTracker?.rating = 4;
        progressTracker?.cardsRemaining = 54
        
        // Pause button
        pauseButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: 50, height: 50))
        pauseButton?.setImage(#imageLiteral(resourceName: "UI_Icon_Pause"), for: .normal)
        pauseButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        pauseButton?.setTitleColor(UIColor.white, for: .normal)
        pauseButton?.addTarget(self, action:#selector(self.PauseButtonPressed), for: .touchUpInside)
        
        // Pause menu, can be moved into own file.
        pauseMenu = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        pauseMenu.isHidden = true

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = pauseMenu.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let pauseTitle = UITextField(frame: CGRect(x: 0, y: 100, width: pauseMenu.frame.width, height: 100))
        pauseTitle.text = "Pause Menu"
        pauseTitle.textColor = UIColor.white
        pauseTitle.textAlignment = .center
        
        let pauseBackButton = UIButton(frame: CGRect(x: 0, y: 200, width: pauseMenu.frame.width, height: 100))
        pauseBackButton.addTarget(self, action:#selector(self.returnToHome), for: .touchUpInside)
        pauseBackButton.setTitle("Back", for: .normal)
        
        pauseMenu.addSubview(blurEffectView)
        pauseMenu.addSubview(pauseTitle)
        pauseMenu.addSubview(pauseBackButton)

        self.view.addSubview(progressTracker!)

        self.addCollectionView()
        self.setupLayout()
        self.view.addSubview(statusBarView)
        self.view.addSubview(pauseMenu)
        self.view.addSubview(pauseButton!)
    }
    
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
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        self.collectionView?.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = true
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(CardCell.self, forCellWithReuseIdentifier: "cellId")
        
        // Spacing between cells:
        let spacingLayout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 0)
        
        self.collectionView?.backgroundColor = UIColor.clear
        self.view.addSubview(self.collectionView!)
        
    }
    
    ///
    /// Create the end game view.
    ///
    func gameComplete () {
        let endGameView = EmitterView(frame: CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        endGameView.backgroundColor = Constants.kingColor
        self.view.addSubview(endGameView)

        UIView.setAnimationCurve(UIViewAnimationCurve.easeOut)
        UIView.animate(withDuration: 1, animations: {
            endGameView.center.y = self.view.center.y
        }, completion: {(_ completed: Bool) -> Void in
            endGameView.setup()
            endGameView.emit()
            // TODO: set font
            // End game title
            let endTextLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 50))
            endTextLabel.text = "You have been selected as the final king!"
            endTextLabel.textColor = UIColor.darkGray
            endTextLabel.numberOfLines = 0
            endTextLabel.textAlignment = .center
            endGameView.addSubview(endTextLabel)
            
            let victoryImage = UIImageView(frame: CGRect(x: self.view.frame.width/2 - 75, y: self.view.frame.height/2 - 100, width: 150, height: 75))
            victoryImage.image = UIImage(named: "VictoryBanner")
            endGameView.addSubview(victoryImage)
            
            // Return button
            let returnButton = UIButton(frame: CGRect(x: 0, y: endGameView.frame.height - 100, width: endGameView.frame.width, height: 50))
            returnButton.setTitle("Return", for: .normal)
            returnButton.setTitleColor(UIColor.white, for: .normal)
            returnButton.backgroundColor = UIColor.black;
            returnButton.target(forAction: #selector(self.returnToHome), withSender: self)
            endGameView.addSubview(returnButton)
            
        })
        
    }
    
    func generateDeck(ruleset: ResponseData) -> [Card]? {
        var tempDeck = [Card]()
        var index: Int = 0
        print(ruleset.Cards)
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
        self.currentPage = 0
    }
    
    @objc func PauseButtonPressed () {
        pauseMenu?.isHidden = !(pauseMenu?.isHidden)!
        if(pauseMenu?.isHidden == true)
        {
            print("Unpause")
            pauseButton?.setImage(UIImage(named: "UI_Icon_Pause"), for: .normal)
        }
        else
        {
            print("Paused")
            pauseButton?.setImage(UIImage(named: "UI_Icon_Play"), for: .normal)
        }
    }
    
    @objc func returnToHome() {
        print("ReturnToHome")
        dismiss(animated: true, completion: nil)
    }
    
    

    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    
}

// MARK: - GestureRecognizerDelegate

extension MainViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}

// MARK: - UICollectionViewDelegate

extension MainViewController : UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}

// MARK: - UICollectionViewDataSource

extension MainViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CardCell
        cell.revealed = false
        cell.card = deck[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
}

// MARK: - CardCellDelegate

extension MainViewController : CardCellDelegate {
    
    func RevealCard(view: UIView, card: CardCell) {
        collectionView?.isScrollEnabled = false
        cardSelected = true;
        currentCard = card
        
        // King check
        if(card.card?.rank == "K")
        {
            progressTracker?.rating -= 1
            if progressTracker?.rating == 0 {
                print("GAME IS COMPLETE")
                gameComplete()
            }
        }
        
        UIView.transition(with: card, duration: 0.5, options: [.transitionFlipFromLeft],
                          animations: {
                            card.center.y = card.originalCenter.y
                            card.center.x = card.originalCenter.x
                            self.view.layoutIfNeeded()
        },
                          completion: { _ in
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
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            card.center.x = 1000
        }, completion: nil)
        self.progressTracker?.cardsRemaining -= 1
        
        
        
        delay(0.5, closure: {
            card.alpha = 0
            self.informationView?.removeFromSuperview()
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
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
