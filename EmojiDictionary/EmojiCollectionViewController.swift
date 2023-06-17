// EmojiDictionary

import UIKit

private let reuseIdentifier = "Item"

class EmojiCollectionViewController: UICollectionViewController {
    
    var emojis: [Emoji] = [
            Emoji(symbol: "🫵🃏", name: "Ur Joking", description: "Accuses someone of joking.", usage: "disbelief"),
            Emoji(symbol: "🤓👆🏻", name: "Um, Actually", description: "Corrects someone's misinformation", usage: "told you so"),
            Emoji(symbol: "📠", name: "Fax", description: "When someone is spitting straight facts", usage: "facts"),
            Emoji(symbol: "🌌🔭🦔", name: "Hedgehog Astronomer", description: "For your hedgehog astronomer friends.", usage: "stars nerd"),
            Emoji(symbol: "😳🕶️🤏", name: "Seriously", description: "When you can't believe what someone just told you.", usage: "shock, awe"),
            Emoji(symbol: "👨🏻‍🎨", name: "French Artist", description: "A french (or gay) artist.", usage: "insult"),
            Emoji(symbol: "👰🏻‍♂️💍", name: "Jonathan Van Ness", description: "Queer eye.", usage: "bride"),
            Emoji(symbol: "🧙🏻‍♂️", name: "Gandalf", description: "Where is Gandalf? For I much desire to speak with him.", usage: "wizard"),
            Emoji(symbol: "🧖🏻‍♀️📸", name: "Mirror Selfie", description: "When you're feeling yourself after a shower", usage: "hot"),
            Emoji(symbol: "🙅🧢", name: "No cap", description: "Wouldn't lie.", usage: "truth"),
            Emoji(symbol: "🔙🔛🔝🔜", name: "Back On Top Soon", description: "When you're gonna make a comeback", usage: "optimism"),
            Emoji(symbol: "🏧", name: "At the moment", description: "Right now", usage: "atm"),
            Emoji(symbol: "🚩🔂🚫", name: "Don't repeat red flag", description: "Believe people when they show you who they are", usage: "describing f*ckbois"),
            Emoji(symbol: "🖕🏻😡 📨 ", name: "Hate mail", description: "When they're in your DMs with some bs", usage: "hate speech")
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Below I am defining an item size for each cell in the collection view. Each item is the full size of its container
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
//        Below I am defining a group to be set to a fixed height of 70 and the full width of its container. Each group contains one item.
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            subitem: item,
            count: 1)
        
//        Below, each group is encapsulated into a section and the section is used to set the final compositional layout
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
    
        //Step 2: Fetch model object to display
        let emoji = emojis[indexPath.item]

        //Step 3: Configure cell
        cell.update(with: emoji)

        //Step 4: Return cell
        return cell
    }

    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            // Editing Emoji
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding Emoji
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditEmojiTableViewController,
            let emoji = sourceViewController.emoji else { return }
        
        // Update the data source and collection view
        
//        If the indexPathsForSelectedItems property of the collection view has data, this means an item was selected and edited, so the item's definition and the displayed details both need to be updated to reflect the changes.
        if let path = collectionView.indexPathsForSelectedItems?.first {
            emojis[path.row] = emoji
            collectionView.reloadItems(at: [path])
        } else {
//            If there are no selected index paths, a new emoji was created, and its definition needs to be added to your collection of emoji. You will also need a new row added to the collection view for it.
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            collectionView.insertItems(at: [newIndexPath])

        }
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            let delete = UIAction(title: "Delete") { (action) in
                self.deleteEmoji(at: indexPath)
                
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        
        return config
    }
    
    func deleteEmoji(at indexPath: IndexPath) {
        emojis.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }

}
