//
//  ImagesViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UIScrollViewDelegate {
    
    var pageImages: [UIImage] = []     // Current product images
    var pageViews: [UIView?] = []      // Display image on each page
    var viewingPage = -1               // Display empty page
    
    @IBOutlet weak var scrollView:  UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        // Set images count
        let imagesCount = pageImages.count
        let pageCount = imagesCount
        
        /* Set page styles */
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        
        // Set up the page control
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = pageCount;
        
        // Set layout
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["control"] = self.pageControl;
        viewsDict["scrollView"] = self.scrollView;
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        // Set up the array to hold the views for each page
        for (var i = 0; i < pageCount; ++i) {
            self.pageViews.append(nil)
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
        
        /* Set up the content size of the scroll view */
        let pagesScrollViewSize: CGSize = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(self.pageImages.count), pagesScrollViewSize.height);
        
        // Load the initial set of pages that are on screen
        self.loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadVisiblePages()
    }
}
