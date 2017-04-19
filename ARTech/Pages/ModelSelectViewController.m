//
// Created by wangyang on 2017/4/19.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "ModelSelectViewController.h"
#import "ModelManager.h"

@interface ModelSelectViewController ()
@property (strong, nonatomic) NSArray *models;
@end

@implementation ModelSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self load3DModels];
}

- (void)load3DModels {
    self.models = [ModelManager load3DModels];
    [self.tableView reloadData];
}

#pragma mark - Table Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSURL *url = [NSURL URLWithString:self.models[indexPath.row]];
    cell.textLabel.text = [url lastPathComponent];
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:0xff/255.0
            green:0xdc/255.0
            blue:0x5d/255.0
            alpha:0.5];
    cell.selectedBackgroundView =  customColorView;


    NSString *selectedModelPath = [ModelManager loadSelected3DModel];
    NSURL *selectedModelUrl = [NSURL URLWithString:selectedModelPath];
    if ([[url lastPathComponent] isEqualToString:[selectedModelUrl lastPathComponent]]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

#pragma mark - Table Deleagte
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ModelManager select3DModel:self.models[indexPath.row]];
}

@end