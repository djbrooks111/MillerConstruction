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
    NSArray *headers;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *title = self.report;
    if (self.reportType == ActiveReport) {
        title = [NSString stringWithFormat:@"%@ Active", title];
    } else if (self.reportType == ProposalReport) {
        title = [NSString stringWithFormat:@"%@ Proposal", title];
    } else if (self.reportType == BudgetaryReport) {
        title = [NSString stringWithFormat:@"%@ Budgetary", title];
    } else if (self.reportType == InactiveReport) {
        title = [NSString stringWithFormat:@"%@ Inactive", title];
    } else {
        title = [NSString stringWithFormat:@"%@ Closed", title];
    }
    
    self.navigationItem.title = title;
    
    helper = [[GenerateReportSearchHelper alloc] init];
    projects = [helper projectInformationForReport:self.report andReportType:self.reportType];
    if ([self.report isEqualToString:@"Weekly"]) {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper weeklyActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper weeklyProposalReportHeaders];
                break;
            }
            case BudgetaryReport: {
                headers = [helper weeklyBudgetaryReportHeaders];
                break;
            }
            case InactiveReport: {
                headers = [helper weeklyInactiveReportHeaders];
                break;
            }
            case ClosedReport: {
                headers = [helper weeklyClosedReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    } else if ([self.report isEqualToString:@"Steve Meyer"]) {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper steveMeyerActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper steveMeyerProposalReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    } else if ([self.report isEqualToString:@"South East Refrigeration"]) {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper southEastActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper southEastProposalReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    } else if ([self.report isEqualToString:@"North East Refrigeration"]) {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper northEastActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper northEastProposalReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    } else if ([self.report isEqualToString:@"J Dempsey"]) {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper jDempseyActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper jDempseyProposalReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    } else if ([self.report isEqualToString:@"Invoice"]) {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper invoiceActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper invoiceProposalReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    } else if ([self.report isEqualToString:@"Completed"]) {
        headers = [helper completedActiveReportHeaders];
    } else if ([self.report isEqualToString:@"Construction"]) {
        headers = [helper constructionActiveReportHeaders];
    } else if ([self.report isEqualToString:@"Repair"]) {
        headers = [helper repairActiveReportHeaders];
    } else {
        switch (self.reportType) {
            case ActiveReport: {
                headers = [helper hvacActiveReportHeaders];
                break;
            }
            case ProposalReport: {
                headers = [helper hvacProposalReportHeaders];
                break;
            }
            default: {
                break;
            }
        }
    }
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewColumnHeader withReuseIdentifier:CollectionViewHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewRowHeader withReuseIdentifier:CollectionViewHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
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

/**
 *  Return number of sections in given collection view
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *
 *  @return Number of sections
 */
-(NSUInteger)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

/**
 *  Return number of layout's rows in given collection view section
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param section        Collection View section
 *
 *  @return Number of layout's rows
 */
-(NSUInteger)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView numberOfRowsInSection:(NSUInteger)section {
    
    return [projects count];
}

/**
 *  Return number of layout's columns in given collection view section
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param section        Collection View section
 *
 *  @return Number of layout's columns
 */
-(NSUInteger)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView numberOfColumnsInSection:(NSUInteger)section {
    
    return [headers count];
}

/**
 *  Return width for layout's column in given collection view section
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param column         Layout's column index
 *  @param section        Collection View section
 *
 *  @return Column width
 */
-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView widthForColumn:(NSUInteger)column inSection:(NSUInteger)section {
    
    return 200.f;
}

/**
 *  Return height for layout's row in given collection view section
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param row            Layout's row index
 *  @param section        Collection View section
 *
 *  @return Row height
 */
-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView heightForRow:(NSUInteger)row inSection:(NSUInteger)section {
    
    return 100.f;
}

/**
 *  Return width for row headers. Return 0 to disable row headers.
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param section        Collection View section
 *
 *  @return Row headers width
 */
-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView widthForRowHeaderInSection:(NSUInteger)section {
    
    return 80.f;
}

/**
 *  Return height for column headers. Return 0 to disable column headers.
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param section        Collection View section
 *
 *  @return Column headers height
 */
-(CGFloat)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView heightForColumnHeaderInSection:(NSUInteger)section {
    
    return 80.f;
}

/**
 *  Return cell for given row and column in collection view
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param row            Layout's row
 *  @param column         Layout's column
 *  @param indexPath      Collection View Cell index path
 *
 *  @return Collection View Cell
 */
-(UICollectionViewCell *)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView cellForRow:(NSUInteger)row column:(NSUInteger)column indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [[[cell.contentView subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *subview, NSDictionary *bindings) {
        return ([subview isKindOfClass:[UILabel class]]);
    }]] firstObject];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textColor = [UIColor blackColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
    }
    
    NSArray *project = [projects objectAtIndex:row];
    if ([project objectAtIndex:column] == [NSNull null]) {
        label.text = @"--";
    } else {
        label.text = [[project objectAtIndex:column] description];
    }
    
    [label sizeThatFits:cell.contentView.frame.size];
    
    return cell;
}

/**
 *  Return view for column header
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param column         Layout's column
 *  @param indexPath      Collection View Supplementary View index path
 *
 *  @return Collection Reusable View
 */
-(UICollectionReusableView *)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView headerViewForColumn:(NSUInteger)column indexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewColumnHeader withReuseIdentifier:CollectionViewHeaderIdentifier forIndexPath:indexPath];
    
    view.backgroundColor = [UIColor grayColor];
    view.layer.borderColor = [[UIColor blackColor] CGColor];
    view.layer.borderWidth = 1.f;
    
    UILabel *label = [[[view subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *subview, NSDictionary *bindings) {
        return ([subview isKindOfClass:[UILabel class]]);
    }]] firstObject];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    label.text = [headers objectAtIndex:column];
    
    return view;
}

/**
 *  Return view for row header
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param row            Layout's row
 *  @param indexPath      Collection View Supplementary View index path
 *
 *  @return Collection Reusable View
 */
-(UICollectionReusableView *)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView headerViewForRow:(NSUInteger)row indexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:DRCollectionViewTableLayoutSupplementaryViewRowHeader withReuseIdentifier:CollectionViewHeaderIdentifier forIndexPath:indexPath];
    
    view.backgroundColor = [UIColor grayColor];
    view.layer.borderColor = [[UIColor blackColor] CGColor];
    view.layer.borderWidth = 1.f;
    
    UILabel *label = [[[view subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *subview, NSDictionary *bindings) {
        return ([subview isKindOfClass:[UILabel class]]);
    }]] firstObject];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    label.text = [NSString stringWithFormat:@"Project %ld", (long)row + 1];
    
    return view;
}

/**
 *  Return YES if column headers in given section should stick to top edge
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param section        Collection View section
 *
 *  @return Boolean value
 */
-(BOOL)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView stickyColumnHeadersForSection:(NSUInteger)section {
    
    return YES;
}

/**
 *  Return YES if row headers in given section should stick to left edge
 *
 *  @param manager        Collection View Table Layout Manager
 *  @param collectionView Collection View
 *  @param section        Collection View section
 *
 *  @return Boolean value
 */
-(BOOL)collectionViewTableLayoutManager:(DRCollectionViewTableLayoutManager *)manager collectionView:(UICollectionView *)collectionView stickyRowHeadersForSection:(NSUInteger)section {
    
    return YES;
}

@end
