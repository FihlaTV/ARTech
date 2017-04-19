//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "NFTMarkerListViewController.h"
#import "LocalNFTMarkerManager.h"
#import "LocalNFTMarkerData.h"

#import "NFTARViewController.h"

@interface NFTMarkerListViewController ()
@property (strong, nonatomic) NSArray *markers;
@end

@implementation NFTMarkerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.markers = [LocalNFTMarkerManager loadNFTMarkers];
    [self.tableView reloadData];
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.markers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    LocalNFTMarkerData *data = self.markers[indexPath.row];
    UIImage *markerImage = [UIImage imageWithContentsOfFile:[data imageUrl].path];
    cell.imageView.image = markerImage;
    cell.textLabel.text = data.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Table View Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocalNFTMarkerData *data = self.markers[indexPath.row];
        [LocalNFTMarkerManager removeMarker:data];
        self.markers = [LocalNFTMarkerManager loadNFTMarkers];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.needGotoNFTAR) {
        NFTARViewController * nftarViewController = [NFTARViewController new];
        nftarViewController.marker = self.markers[indexPath.row];
        [self.navigationController pushViewController:nftarViewController animated:YES];
    }
}

@end
