//
//  ViewController.m
//  OSSearch
//
//  Created by Sergii Onopriienko on 10.02.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "ViewController.h"
#import "OSStudent.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (strong, nonatomic) OSStudent *student;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentsArray = [NSMutableArray array];
    
    for (int i = 0; i < 1000; i++) {
        [self.studentsArray addObject:[OSStudent randomStudent]];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.studentsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    self.student = [self.studentsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.student.firstName, self.student.lastName];
    
    return cell;
    
}

@end
