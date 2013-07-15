//
//  PhotoViewController.m
//  Text&Colour
//
//  Created by Lindemann on 15.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "Photo.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL firstLoad;

@end

@implementation PhotoViewController

- (id)initWithIndex:(int)index ForItem:(Item*)item {
    self = [super init];
    if (self) {
        
        if (index < 0 || index > item.photos.count-1) {
            return nil;
        }
        self.photoIndex = index;
        self.item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.96f blue:0.98f alpha:1.00f];
    
    // Set ActivityIndicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
    // Set ScrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    self.firstLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    // -viewDidAppear should call only once after -viewDidLoad...
    // Without self.firstLoad it would become loaded after
    // every swipe and trigger a creepy behavior and chrashes
    if (self.firstLoad) {
        self.firstLoad = NO;
    } else {
        return;
    }
    
    [super viewDidAppear:animated];
    
    dispatch_queue_t loadData = dispatch_queue_create("loadData", NULL);
    dispatch_async(loadData, ^{
        
        // Set Image and ImageView
        Photo *photo = [self.item.photos objectAtIndex:self.photoIndex];
        UIImage *image = [UIImage imageWithData:photo.photoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self.scrollView addSubview:imageView];
            
            [self.activityIndicator removeFromSuperview];
            
            // Set Scroll Scale
            self.scrollView.contentSize = image.size;
            self.scrollView.maximumZoomScale = 5.0;
            
            // Scale ImageView to fit into ScrollView
            if (image.size.width > self.scrollView.frame.size.width || image.size.height > self.scrollView.frame.size.height) {
                float heightZoomScale = self.scrollView.frame.size.height / image.size.height;
                float widthZoomScale = self.scrollView.frame.size.width / image.size.width;
                if (heightZoomScale < widthZoomScale) {
                    self.scrollView.minimumZoomScale = heightZoomScale;
                } else {
                    self.scrollView.minimumZoomScale = widthZoomScale;
                }
            } else {
                self.scrollView.minimumZoomScale = 1.0;
            }
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
            
            // Center ImageView
            imageView.center = [self centerOfScroll:self.scrollView];
            
            // Set GestureRecognizer
            UITapGestureRecognizer *tapGestureRecognizer02 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snapBack)];
            tapGestureRecognizer02.numberOfTapsRequired = 2;
            [self.scrollView addGestureRecognizer:tapGestureRecognizer02];
            
            UITapGestureRecognizer *tapGestureRecognizer01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNavBarAndToolBar)];
            tapGestureRecognizer01.numberOfTapsRequired = 1;
            
            [tapGestureRecognizer01 requireGestureRecognizerToFail:tapGestureRecognizer02];
            
            [self.scrollView addGestureRecognizer:tapGestureRecognizer01];
        
        });
    });
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView.subviews objectAtIndex:0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // Center ImageView
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    subView.center = [self centerOfScroll:scrollView];
}

- (CGPoint)centerOfScroll:(UIScrollView*)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    return CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                       scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)snapBack {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
}

- (void)hideNavBarAndToolBar {
    if (self.navigationController.navigationBarHidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.navigationBar.alpha = 1;
            self.navigationController.toolbar.alpha = 1;
        } completion:^(BOOL finished) {
            self.navigationController.navigationBarHidden = NO;
            self.navigationController.toolbarHidden = NO;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.navigationBar.alpha = 0;
            self.navigationController.toolbar.alpha = 0;
        } completion:^(BOOL finished) {
            self.navigationController.navigationBarHidden = YES;
            self.navigationController.toolbarHidden = YES;
        }];
    }
}

@end
