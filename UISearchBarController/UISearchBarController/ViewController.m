//
//  ViewController.m
//  UISearchBarController
//
//  Created by zhudong on 16/7/29.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ViewController.h"
#import "ZDResultController.h"

@interface ViewController ()<UISearchResultsUpdating>
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) NSArray *allCities;
@property (nonatomic,strong) ZDResultController *resultController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZDResultController *resultVC = [[ZDResultController alloc] init];
    self.resultController = resultVC;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
//    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.backgroundImage = [UIImage new];
    self.searchController.searchBar.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = self.searchController.searchBar;
//    NSLog(@"%@",self.allCities);
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", self.searchController.searchBar.text];
    NSArray *filteredCities = [[self.allCities filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    self.resultController.results = filteredCities;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultController.tableView reloadData];
    });
}
#pragma mark - DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.allCities[indexPath.row];
    return cell;
}

- (NSArray *)allCities{
    if (!_allCities) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chengshi.plist" ofType:nil]];
        NSMutableArray *arrM = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [obj.allKeys firstObject];
            NSArray *array = obj[key];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrM addObject:obj];
            }];
        }];
        _allCities = [arrM copy];
    }
    return _allCities;
}
@end
