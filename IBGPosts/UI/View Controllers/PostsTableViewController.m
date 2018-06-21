//
//  PostsTableViewController.m
//  IBGPosts
//
//  Created by Fady on 6/15/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import "PostsTableViewController.h"
#import "PostTableViewCell.h"
#import "IBGNetworkingManager.h"
#import "Post.h"
#import "UIAlertController+ErrorAlerts.h"

@interface PostsTableViewController ()

@property (nonatomic, strong) NSMutableArray *postsArray;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) State state;
@property (nonatomic, assign) BOOL isPullDownToRefreshEnabled;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIRefreshControl *ibgRefreshControl;
@property (nonatomic, strong) UILabel *postsCountLabel;
@property (nonatomic, strong) UILabel *pageNumberLabel;

@end

@implementation PostsTableViewController

static NSString * const postTableViewCellIdentifier = @"PostTableViewCellIdentifier";

- (instancetype)init {
    if (self = [super init])  {
        self.pageNumber = 1;
        self.postsArray = [[NSMutableArray alloc] init];
        self.isPullDownToRefreshEnabled = NO;
        self.isRefreshing = NO;
        [self setToActiveState];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Posts";
    [self setupTableView];
    [self setupNavigationBarLabels];
    [self setupRefreshControl];
    [self registerTableViewCells];
    [self loadPosts];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:postTableViewCellIdentifier forIndexPath:indexPath];
    Post *post = [self.postsArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = post.title;
    cell.bodyLabel.text = post.body;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.postsArray.count - 1 && self.state == active) {
        [self enableInfiniteScrollUI];
        [self loadPosts];
    }
}

#pragma mark - Networking

- (void)loadPosts {
    [[IBGNetworkingManager sharedInstance] getPostsForPage:self.pageNumber WithSuccess:^(NSArray * _Nonnull postsArray) {
        if (self.isRefreshing) {
            [self.postsArray removeAllObjects];
            self.isRefreshing = NO;
        }
        
        [self.postsArray addObjectsFromArray:postsArray];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.tableView reloadData];
            [self updateForNetworkCallEnd];
        }];
    } failure:^(NSError * _Nonnull error) {
        if (self.pageNumber > 1) {
            self.pageNumber -= 1;
        }
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self updateUIForNetworkCallEnd];
        }];
    }];
}

#pragma mark - Refresh control support

- (void)setupRefreshControl {
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.ibgRefreshControl addTarget:self action:@selector(reloadNewPosts) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.ibgRefreshControl;
}

- (void)reloadNewPosts {
    if (self.isPullDownToRefreshEnabled) {
        self.pageNumber = 1;
        self.isRefreshing = YES;
        [self setToActiveState];
        [self loadPosts];
    } else {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view support

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 100.0f;
    self.tableView.estimatedRowHeight = 100.0f;
}

- (void)registerTableViewCells {
    [self.tableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:postTableViewCellIdentifier];
}

- (void)setupNavigationBarLabels {
    UILabel *postsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    UIBarButtonItem *postsCountBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postsCountLabel];
    self.postsCountLabel = postsCountLabel;
    self.navigationItem.rightBarButtonItem = postsCountBarButtonItem;
    
    UILabel *postsLoadCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    UIBarButtonItem *postsLoadCountBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postsLoadCountLabel];
    self.pageNumberLabel = postsLoadCountLabel;
    self.navigationItem.leftBarButtonItem = postsLoadCountBarButtonItem;
}

#pragma mark - Support

- (void)updateForNetworkCallEnd {
    if (self.state == active) {
        [self updateLabelsText];
        self.pageNumber += 1;
    }
    
    [self updateUIForNetworkCallEnd];
}

- (void)enableInfiniteScrollUI {
    [self.spinner startAnimating];
    self.tableView.tableFooterView = self.spinner;
}

- (void)disableInfiniteScrollUI {
    [self.spinner stopAnimating];
    self.tableView.tableFooterView = nil;
}

- (void)updateUIForNetworkCallEnd {
    [self disableInfiniteScrollUI];
    [self.ibgRefreshControl endRefreshing];
}

- (void)updateLabelsText {
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %tu", 0];
    self.postsCountLabel.text = [NSString stringWithFormat:@"%tu Posts", self.postsArray.count];
}

- (void)setToActiveState {
    self.state = active;
}

- (void)setToInactiveState {
    self.state = inactive;
}

- (void)presentNetworkFailureAlertController {
    UIAlertController *networkingErrorAlertController = [UIAlertController alertControllerWithTitle:@"Internet Connection Error" message:@"Would you like to try again?" handler:^(UIAlertAction * _Nonnull action) {
        [self loadPosts];
    }];
    
    [self presentViewController:networkingErrorAlertController animated:YES completion:nil];
}

#pragma mark - Properties

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.frame = CGRectMake(0, 0, 320, 44);
    }
    
    return _spinner;
}

- (UIRefreshControl *)ibgRefreshControl {
    if (!_ibgRefreshControl) {
        _ibgRefreshControl = [[UIRefreshControl alloc] init];
        [_ibgRefreshControl setTintColor:[UIColor grayColor]];   
    }
    
    return _ibgRefreshControl;
}

@end
