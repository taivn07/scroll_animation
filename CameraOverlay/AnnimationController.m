//
//  AnnimationController.m
//  CameraOverlay
//
//  Created by datxqv on 3/8/16.
//  Copyright © 2016 datxqv. All rights reserved.
//

#import "AnnimationController.h"
#import "ImageCell.h"

#define rateOfView 0.5
#define numberCellInRow 4
#define distanceBetweenTwoCell 6

static NSString *nibNameCell = @"ImageCell";
static NSString *identifierCell = @"imageCell";
@interface AnnimationController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic) CGFloat backupContentOffset;
@property (nonatomic) BOOL inTop;
@property (nonatomic) BOOL inBottom;
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation AnnimationController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initComponent];
}

- (void)initComponent{
    
    // Register nib
    [self.collectionView registerNib:[UINib nibWithNibName:nibNameCell bundle:nil]forCellWithReuseIdentifier:identifierCell];
    self.inTop = NO;
    self.inBottom = NO;
    self.lastContentOffset = 0.0;
    
    //Reset frame
    CGRect screen = self.view.frame;
    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(screen), CGRectGetWidth(screen));
    self.collectionView.frame = CGRectMake(0, CGRectGetHeight(self.topView.frame),CGRectGetWidth(screen), CGRectGetHeight(screen) - CGRectGetWidth(screen));
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 90;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ImageCell alloc] init];
    }
    NSString *contentCell = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.labelContent.text = contentCell;
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return distanceBetweenTwoCell/2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return distanceBetweenTwoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger numberCell = numberCellInRow > 0 ? numberCellInRow : 3;
    CGRect screen = self.view.frame;
    CGFloat widthFix = (CGRectGetWidth(screen) - 2*distanceBetweenTwoCell - (numberCellInRow - 1) * distanceBetweenTwoCell) / numberCell;
    return CGSizeMake(widthFix, widthFix);
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = [self.collectionView.panGestureRecognizer locationInView:self.view];
    
    BOOL isScrollUp = self.collectionView.contentOffset.y > self.lastContentOffset;
    if (self.collectionView.tracking){
        if (self.topView.frame.origin.y == 0) {
            // on bottom
            if (isScrollUp) {
                [self changePositionOfTopViewWithPoint:point];
            }
        } else if(self.topView.frame.origin.y == 43 - CGRectGetHeight(self.topView.frame)){
            // on top
            if (!isScrollUp) {
               [self changePositionOfTopViewWithPoint:point];
            }
            
        }else{
            // on mid
            [self changePositionOfTopViewWithPoint:point];
        }
    }
    
    self.lastContentOffset = self.collectionView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGPoint stopPoint = [self.collectionView.panGestureRecognizer locationInView:self.view];
    NSLog(@"StopPoint:%f",stopPoint.y);
    [self didStopDragView];
    
}

#pragma mark - Change postion when collection tracking
- (void)changePositionOfTopViewWithPoint:(CGPoint )point{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = CGRectGetHeight(self.topView.frame);
    
    if (point.y < height  && self.topView.frame.origin.y >=  - height && !self.inTop) {
        
        [self.collectionView setContentOffset:CGPointMake(0, self.backupContentOffset)];
        
        // Begin annimation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        // Change top view frame
        self.topView.frame = CGRectMake(0,point.y - height, CGRectGetWidth(self.topView.frame), CGRectGetHeight(self.topView.frame));
        
        // Change collection view frame
        self.collectionView.frame = CGRectMake(0,point.y, CGRectGetWidth(self.collectionView.frame),screenSize.height - CGRectGetHeight(self.topView.frame) - self.topView.frame.origin.y);
        
        // Commit annimation
        [UIView commitAnimations];
    } else {
        
        // Back up contentOffset of collection view
        self.backupContentOffset = self.collectionView.contentOffset.y;
    }
    
    if (self.inTop && (self.collectionView.contentOffset.y < 0) && self.collectionView.isTracking) {
        CGRect topFrame = self.topView.frame;
        CGRect collectionFrame = self.collectionView.frame;
        topFrame.origin.y -= self.collectionView.contentOffset.y;
        collectionFrame.origin.y -= self.collectionView.contentOffset.y;
        [self.topView setFrame:topFrame];
        [self.collectionView setFrame:collectionFrame];
    }
    
}

#pragma  mark - Drag view has stopped
- (void) didStopDragView {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat panHeight = CGRectGetHeight(self.panView.frame);
    CGFloat heightCanView = self.topView.frame.origin.y + self.topView.frame.size.height;
    CGFloat heightOfTopView = CGRectGetHeight(self.topView.frame);
    
    if ( heightCanView != CGRectGetHeight(self.panView.frame)  && heightCanView < rateOfView * heightOfTopView ) {
        
        NSLog(@"Move up");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        // Move top view up
        self.topView.frame = CGRectMake(0, panHeight - CGRectGetHeight(self.topView.frame), CGRectGetWidth(self.topView.frame), CGRectGetHeight(self.topView.frame));
        
        // Move collection view up
        self.collectionView.frame = CGRectMake(0, panHeight, CGRectGetWidth(self.collectionView.frame),screenSize.height - 43);
        self.inTop = YES;
        self.inBottom = NO;
        
        // Commit annimation
        [UIView commitAnimations];
        
    } else if (self.topView.frame.origin.y != 0 && heightCanView >= rateOfView * heightOfTopView){
        
        CGFloat newYForCollection = self.topView.frame.size.height;
        NSLog(@"Move down");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        // Move topView down
        self.collectionView.frame = CGRectMake(0, newYForCollection, CGRectGetWidth(self.collectionView.frame),screenSize.height - newYForCollection);
        
        // Move collection view down
        self.topView.frame = CGRectMake(0,0, CGRectGetWidth(self.topView.frame), CGRectGetHeight(self.topView.frame));
        [UIView commitAnimations];
        self.inTop = NO;
        self.inBottom = YES;
    }
}

#pragma mark - Detect pan action
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender{
    
    UIPanGestureRecognizer *recognizer = sender;
    CGPoint translation = [sender translationInView:self.view];
    NSLog(@"Pan Y: %f",translation.y);
    
    // Calculate frame
    CGRect screen = [UIScreen mainScreen].bounds;
    self.topView.center = CGPointMake(self.topView.center.x, self.topView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    CGRect collectionViewFrame = self.collectionView.frame;
    collectionViewFrame.origin.y = (CGRectGetHeight(self.topView.frame) + self.topView.frame.origin.y);
    collectionViewFrame.size.height = CGRectGetHeight(screen) - collectionViewFrame.origin.y;
    [self.collectionView setFrame:collectionViewFrame];
    
    if(sender.state == UIGestureRecognizerStateEnded){
        [self didStopDragView];
    }
}
@end
