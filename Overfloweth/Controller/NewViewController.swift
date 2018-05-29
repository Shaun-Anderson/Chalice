import UIKit

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CardCellDelegate {

    
    var deck = [Card]()

    // MARK: Card Cell Delegate Methods
    
    func RevealCard(view: UIView, card: CardCell) {
        UIView.transition(with: view, duration: 1, options: .transitionFlipFromRight,
        animations: {
        view.frame.size.width = self.view.frame.width
        view.frame.size.height = self.view.frame.height - UIApplication.shared.statusBarFrame.height
        view.center = card.originalCenter
        },
        completion: { _ in
            // TODO: Display information.
            print("BOOOO")
            let informationView = InformationView(frame: CGRect(x: 0, y: card.frame.height,width: self.view.frame.width, height: 0), card: card.card!)
            card.addSubview(informationView)
            UIView.transition(with: informationView, duration: 1, options: [],
                              animations: {
                                informationView.frame.size.height = self.view.frame.height / 2
                                informationView.center.y = card.frame.height - informationView.frame.height/2
            },
                              completion: { _ in
                                informationView.AnimateInUI()
            })
        })
    }
    
    func DismissCard(card: CardCell) {
        
    }
    
    
    
    // CollectionView variable:
    var collectionView : UICollectionView?
    
    // Variables asociated to collection view:
    fileprivate var currentPage: Int = 0
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck = loadJson(filename: "Cards") as! [Card]
        self.addCollectionView()
        self.setupLayout()
        
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
        

        // This is just an utility custom class to calculate screen points
        // to the screen based in a reference view. You can ignore this and write the points manually where is required.
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)
        
//        self.collectionView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.collectionView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: pointEstimator.relativeHeight(multiplier: 0)).isActive = true
//        self.collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        self.collectionView?.heightAnchor.constraint(equalToConstant: pointEstimator.relativeHeight(multiplier: 1)).isActive = true
        
        self.currentPage = 0
    }
    
    
    func addCollectionView(){
        
        // This is just an utility custom class to calculate screen points
        // to the screen based in a reference view. You can ignore this and write the points manually where is required.
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)
        
        let layout = UPCarouselFlowLayout()
        // This is used for setting the cell size (size of each view in this case)
        // Here I'm writting 400 points of height and the 73.33% of the height view frame in points.
        layout.itemSize = CGSize(width: pointEstimator.relativeWidth(multiplier: 0.73333), height: 500)
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
        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 20)
        
        self.collectionView?.backgroundColor = UIColor.gray
        self.view.addSubview(self.collectionView!)
        
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
        
        cell.card = deck[indexPath.row]
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
    
}

protocol CardCellDelegate {
    func RevealCard(view: UIView, card: CardCell)
    func DismissCard(card: CardCell)
}
class CardCell: UICollectionViewCell {
    
    var card: Card?
    var delegate: CardCellDelegate?
    var revealed: Bool
    var originalCenter: CGPoint!

    let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(frame: CGRect) {
        self.revealed = false
        super.init(frame: frame)
        self.addSubview(self.customView)
        self.customView.backgroundColor = UIColor.darkGray

        self.customView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.customView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.customView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        self.customView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action:#selector(swiped(_:)))
        self.addGestureRecognizer(swipeGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Reveal () {
        self.customView.backgroundColor = UIColor.white

        // Create UI elements
        let topText = UILabel(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        let topSuit = UIImageView(frame: CGRect(x: 37.5, y: 75, width: 25, height: 25))
        let bottomText = UILabel(frame: CGRect(x: frame.width - 75, y: frame.height - 75, width: 50, height: 50))
        let bottomSuit = UIImageView(frame: CGRect(x: frame.width - 63.5, y: frame.height - 100, width: 25, height: 25))
        
        // Set UI specifcs
        topText.text = card?.rank
        topText.textAlignment = NSTextAlignment.center
        topSuit.image = UIImage(named: (card?.suit?.rawValue)!)
        bottomText.text = card?.rank
        bottomText.textAlignment = NSTextAlignment.center
        bottomSuit.image = UIImage(named: (card?.suit?.rawValue)!)
        bottomText.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        bottomSuit.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        self.addSubview(topText)
        self.addSubview(topSuit)
        self.addSubview(bottomText)
        self.addSubview(bottomSuit)
        
    }
    
    // Take the values of the currcent swipe
    @objc func swiped(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let xDistance:CGFloat = gestureRecognizer.translation(in: self).x
        let yDistance:CGFloat = gestureRecognizer.translation(in: self).y
        
        switch(gestureRecognizer.state) {
        case UIGestureRecognizerState.ended:
            // TODO: remove uneeded variables
            let hasMovedToFarLeft = xDistance < -75
            if (hasMovedToFarLeft) {
                originalCenter = self.center
                self.revealed = true
                delegate!.RevealCard(view: self, card: self)
                Reveal()
            }
            
            let swipeDown = yDistance < -75
            if(swipeDown)
            {
                delegate!.DismissCard(card: self)
            }
        default:
            break
        }
    }
} // End of CardCell


class RelativeLayoutUtilityClass {
    
    var heightFrame: CGFloat?
    var widthFrame: CGFloat?
    
    init(referenceFrameSize: CGSize){
        heightFrame = referenceFrameSize.height
        widthFrame = referenceFrameSize.width
    }
    
    func relativeHeight(multiplier: CGFloat) -> CGFloat{
        
        return multiplier * self.heightFrame!
    }
    
    func relativeWidth(multiplier: CGFloat) -> CGFloat{
        return multiplier * self.widthFrame!
        
    }
    
    
    
}
