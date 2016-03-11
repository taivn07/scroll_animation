//
//  AnnimationController.h
//  CameraOverlay
//
//  Created by datxqv on 3/8/16.
//  Copyright © 2016 datxqv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnimationController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *panView;

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;
@end
