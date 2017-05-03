//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "SquareMarkerListViewController.h"
#import "LocalSquareMarkerManager.h"
#import "LocalSquareMarkerData.h"

#import "SquareARViewController.h"

@interface SquareMarkerListViewController ()
@property (strong, nonatomic) NSArray *markers;
@end

@implementation SquareMarkerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.markers = [LocalSquareMarkerManager loadSquareMarkers];
    [self.tableView reloadData];
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.markers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    LocalSquareMarkerData *data = self.markers[indexPath.row];
    UIImage *markerImage = [UIImage imageWithContentsOfFile:[data imageUrl].path];
    cell.imageView.image = markerImage;
    cell.textLabel.text = [data.name stringByAppendingString: data.isInternal ? @"(内置)" : @""];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Table View Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    LocalSquareMarkerData *data = self.markers[indexPath.row];
    return !data.isInternal;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SquareARViewController * nftarViewController = [SquareARViewController new];
    nftarViewController.marker = self.markers[indexPath.row];
    [self.navigationController pushViewController:nftarViewController animated:YES];
}

@end
