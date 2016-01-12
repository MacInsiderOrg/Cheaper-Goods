//
//  PreviewViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 24.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class PreviewViewController: UITableViewController {

    var discountObjects = NSMutableArray()  // Contain last 5 discounts
    var discountIDs: [Int] = []             // Contain discounts IDs
    var currentProductNumber = Int()        // Contain current discount number on discountObjects array

    var pageImages: [UIImage] = []          // List of discounts images
    var pageViews: [UIView?] = []           // Induvidual pages array
    var viewingPage = -1                    // Current viewing image
    var discountTimes: [String] = []

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var discountTime: UILabel!
    

    /**
     * If user click on home slider, 
     * he transfered to DiscountViewController
     */
    func singleTapped(sender: UITapGestureRecognizer) {
        self.currentProductNumber = self.discountIDs[self.viewingPage]
        self.performSegueWithIdentifier("openDiscount", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set page styles */
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        
        /* Set tap gesture */
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapped:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        // Get last 5 discounts images
        self.getDiscounts()
        
        // Set up the page control
        self.pageControl.currentPage = 0;
    }
    
    /**
     * Get all information about Discount Objects
     * Make new array of Discount images, which displayed
     * on home page
     */
    func getDiscounts() {
        
        let query: PFQuery = PFQuery(className: "Discounts")
        query.orderByAscending("discountID")
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    /* Contain count of images in Discounts Array */
                    var imagesCount = Int()
                    var pageCount = Int()

                    for object in objects! {
                        
                        self.discountObjects.addObject(object)
                        self.discountIDs.append((object["discountID"] as? Int!)!)
                        self.discountTimes.append(object["discountTime"] as! String)
                        
                        let discountImage = object["discountImage"] as? PFFile
                        discountImage!.getDataInBackgroundWithBlock {
                            (imageData, error) -> Void in

                            if (error == nil) {
                                let image = UIImage(data: imageData!)
                                self.pageImages.append(image!)
                                
                                /* Set images count */
                                imagesCount = self.pageImages.count
                                pageCount = imagesCount
                                
                                self.pageControl.numberOfPages = pageCount
                                
                                let pagesScrollViewSize: CGSize = self.scrollView.frame.size
                                self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(self.pageImages.count), pagesScrollViewSize.height)
                                
                                // Set up the element to hold the views for each page
                                self.pageViews.append(nil)
                                
                                // Load the initial set of pages that are on screen
                                self.loadVisiblePages()
                            }
                        }
                    }
                })
                
            } else {
                print(error)
            }
        }
    }
    
    /**
     * Set Destination View Controllers
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            case "openDiscount":
                let Discount: DiscountViewController = segue.destinationViewController as! DiscountViewController
                let object: PFObject = self.discountObjects.objectAtIndex(self.currentProductNumber - 1) as! PFObject
                Discount.discount = object
            
            case "openSales":
                let Sales: ViewController = segue.destinationViewController as! ViewController
                Sales.previousForm = "Homepage"
            
            case "openDiscounts":
                let Discounts: DiscountsViewController = segue.destinationViewController as! DiscountsViewController
                Discounts.previousForm = "Homepage"
            
            case "openStores":
                let Stores: StoreViewController = segue.destinationViewController as! StoreViewController
                Stores.previousForm = "Homepage"
            
            case "openFavorites":
                let Favorites: FavoritesProductsViewController = segue.destinationViewController as! FavoritesProductsViewController
                Favorites.previousForm = "Homepage"
            
            case "openReview":
                let Review: FeedbackViewController = segue.destinationViewController as! FeedbackViewController
                Review.previousForm = "Homepage"
            
            default:
                break
        }

    }

    /**
     * Load all pages, each of which contain one image
     */
    func loadVisiblePages() {
        
        // Determine, which page is currently visible
        let pageWidth: CGFloat = self.scrollView.frame.size.width;
        let page = Int(floor((self.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)));
        
        /**
         * Check that page have changed,
         * in case that user drag left in first page,
         * or drag right in last page a
         * 'scrollViewDidEndDecelerating' is fired
         */
        if viewingPage != page {
            
            // Update the page control
            self.pageControl.currentPage = page;
            
            // Work out which pages we want to load
            let firstPage = page - 1;
            let lastPage = page + 1;
            
            /* Purge anything before the first page */
            for (var i = 0; i < firstPage; i++) {
                self.purgePage(i)
            }
            
            for (var i = firstPage; i <= lastPage; i++) {
                self.loadPage(i)
            }
            
            for (var i = lastPage + 1 ; i < self.pageImages.count ; i++) {
                self.purgePage(i)
            }
            
            viewingPage = page
        }
    }
    
    /**
     * Load current page with current image
     */
    func loadPage(page:Int) {
        
        if page < 0 || page >= self.pageImages.count {
            // If it's outside the range of what we have to display, then do nothing
            return;
        }
        
        /* Load an individual page, first seeing if we've already loaded it */
        let pageView: UIView? = self.pageViews[page];

        if pageView == nil {
            var frame: CGRect = self.scrollView.bounds;
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView: UIImageView = UIImageView(image: self.pageImages[page])
            newPageView.frame = frame;
            
            self.scrollView.addSubview(newPageView)
            self.pageViews[page] = newPageView
            self.discountTime.text = self.discountTimes[page]
        }
    }
    
    /**
     * Remove current page from the scroll view
     */
    func purgePage(page:Int) {
        
        if page < 0 || page >= self.pageImages.count {
            // If it's outside the range of what we have to display, then do nothing
            return;
        }
        
        /* Remove a page from the scroll view and reset the container array */
        let pageView: UIView? = self.pageViews[page];
        
        if pageView != nil {
            pageView?.removeFromSuperview()
            self.pageViews[page] = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}