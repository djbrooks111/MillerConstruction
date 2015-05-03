//
//  GenerateReportViewController.m
//  MillerConstruction
//
//  Created by David Brooks on 4/16/15.
//  Copyright (c) 2015 David J Brooks. All rights reserved.
//

#import "GenerateReportViewController.h"
#import "DRCollectionViewTableLayout.h"
#import "DRCollectionViewTableLayoutManager.h"

static NSString * const CollectionViewCellIdentifier = @"Cell";
static NSString * const CollectionViewHeaderIdentifier = @"Header";

@interface GenerateReportViewController () <DRCollectionViewTableLayoutManagerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) DRCollectionViewTableLayoutManager *collectionManager;

@end

@implementation GenerateReportViewController {
    GenerateReportSearchHelper *helper;
    NSArray *projects;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    helper = [[GenerateReportSearchHelper alloc] init];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewColumnHeader withReuseIdentifier:CollectionViewHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewRowHeader withReuseIdentifier:CollectionViewHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionView class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    DRCollectionViewTableLayout *collectionViewLayout = [[DRCollectionViewTableLayout alloc] initWithDelegate:self.collectionManager];
    [collectionViewLayout setHorizontalSpacing:5.f];
    [collectionViewLayout setVerticalSpacing:5.f];
    [self.collectionView setCollectionViewLayout:collectionViewLayout];
    [self.collectionView setDataSource:self.collectionManager];
    [self.collectionView setDelegate:self.collectionManager];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection Manger Setup

-(DRCollectionViewTableLayoutManager *)collectionManager {
    if (!_collectionManager) {
        _collectionManager = [[DRCollectionViewTableLayoutManager alloc] init];
        _collectionManager.delegate = self;
    }
    
    return _collectionManager;
}

#pragma mark - DRCollectionViewTableLayoutManagerDelegate

-(NSUInteger)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSUInteger)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView numberOfRowsInSection:(NSUInteger)section {
    
    return [[projects firstObject] count];
}

-(NSUInteger)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView numberOfColumnsInSection:(NSUInteger)section {
    
    return [projects count];
}

-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView widthForColumn:(NSUInteger)column inSection:(NSUInteger)section {
    
    return 100.f;
}

-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView heightForRow:(NSUInteger)row inSection:(NSUInteger)section {
    
    return 50.f;
}

-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView widthForRowHeaderInSection:(NSUInteger)section {
    
    return 80.f;
}

-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView heightForColumnHeaderInSection:(NSUInteger)section {
    
    return 30.f;
}

-(UICollectionViewCell *)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView cellForRow:(NSUInteger)row column:(NSUInteger)column indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    UILabel *label = [[[cell.contentView subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *subview, NSDictionary *bindings) {
        return ([subview isKindOfClass:[UILabel class]]);
    }]] firstObject];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.font = [UIFont systemFontOfSize:10.f];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
    }
    
    NSArray *project = [projects objectAtIndex:column];
    label.text = [project objectAtIndex:row];
    
    return cell;
}

-(UICollectionReusableView *)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView headerViewForColumn:(NSUInteger)column indexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewRowHeader withReuseIdentifier:CollectionViewHeaderIdentifier forIndexPath:indexPath];
    
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    view.layer.borderWidth = 1.f;
    
    UILabel *label = [[[view subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *subview, NSDictionary *bindings) {
        return ([subview isKindOfClass:[UILabel class]]);
    }]] firstObject];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.font = [UIFont systemFontOfSize:10.f];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    //label.text = [projectHeaders objectAtIndex:column];
    return view;
}

-(UICollectionReusableView *)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView headerViewForRow:(NSUInteger)row indexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewRowHeader withReuseIdentifier:CollectionViewHeaderIdentifier forIndexPath:indexPath];
    
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    view.layer.borderWidth = 1.f;
    
    UILabel *label = [[[view subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *subview, NSDictionary *bindings) {
        return ([subview isKindOfClass:[UILabel class]]);
    }]] firstObject];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.font = [UIFont systemFontOfSize:10.f];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    label.text = [NSString stringWithFormat:@"id: %ld", (long)row];
    
    return view;
}

-(BOOL)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView stickyColumnHeadersForSection:(NSUInteger)section {
    
    return YES;
}

-(BOOL)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView stickyRowHeadersForSection:(NSUInteger)section {
    
    return YES;
}

@end
