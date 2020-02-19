//
//  ViewController.m
//  OSSearch
//
//  Created by Sergii Onopriienko on 10.02.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "ViewController.h"
#import "OSStudent.h"
#import "OSSection.h"

@interface ViewController () <UISearchBarDelegate>
//typedef NS_ENUM(NSUInteger, GenderMode){
//    numOne,
//    numTwo
//};
@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (strong, nonatomic) NSArray *sectionsArray;

@property (strong, nonatomic) OSStudent *student;
@property (strong, nonatomic) OSSection *section;

@property (strong, nonatomic) NSString *searchString;

@property (assign, nonatomic) NSInteger selectedScope;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSOperation *currentOperation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentsArray = [NSMutableArray array];
    self.sectionsArray = [NSArray array];
    self.selectedScope = 0;
    self.searchString = nil;
    self.currentIndex = 0;
    //self.homeBarButton.enabled = NO;

    for (int i = 0; i < 100; i++) {
        [self.studentsArray addObject:[OSStudent createRandomStudent]];
    }
    
    [self generateSectionsInBackgroundFromArray:self.studentsArray];
    
    [self.tableView reloadData];
    
}

#pragma mark - Private methods -

- (void)generateSectionsInBackgroundFromArray:(NSArray *)array
{
    [self.currentOperation cancel];
    __weak ViewController *weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray *sectionsArray = [weakSelf generateSectionsFromArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.sectionsArray = sectionsArray;
            [weakSelf.tableView reloadData];
            self.currentOperation = nil;
        
        });
    }];
    
    [self.currentOperation start];
}

- (NSArray *)generateSectionsFromArray:(NSArray *)array
{
    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSMutableArray *sectionsNameArray = [NSMutableArray array];
    
    for (OSStudent *student in array)
    {
        OSSection *section = [[OSSection alloc] init];
        NSString *studentSearchText;
        NSString *sectionIndex;
        
        switch (self.selectedScope)
        {
            case 0:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd.MM.yyyy"];
                studentSearchText = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:student.birthDate]];
                sectionIndex = (student.birthDateMonth > 9) ? [NSString stringWithFormat:@"%lu", (unsigned long)student.birthDateMonth] :
                                                              [NSString stringWithFormat:@"0%lu", (unsigned long)student.birthDateMonth];
            }
                break;
                
            case 1:
                studentSearchText = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
                sectionIndex = [studentSearchText substringToIndex:1];
                break;

            case 2:
                studentSearchText = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
                sectionIndex = [studentSearchText substringToIndex:1];
                break;
        }
                
        if ([self.searchString length] > 0 && [studentSearchText rangeOfString:self.searchString].location == NSNotFound)
        {
            continue;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF isEqual:%@", sectionIndex];
        NSArray *sectionsFilteredArray = [sectionsNameArray filteredArrayUsingPredicate:predicate];
        
        if ([sectionsFilteredArray count] ==  0)
        {
            section.index = sectionIndex;
            section.rowsArray = [NSMutableArray array];
            [section.rowsArray addObject:student];
            [sectionsArray addObject:section];
            [sectionsNameArray addObject:sectionIndex];
        }
        
        else
        {
            NSInteger indexSection = [sectionsNameArray indexOfObject:sectionIndex];
            section = [sectionsArray objectAtIndex:indexSection];
            [section.rowsArray addObject:student];
        }
    }

    return sectionsArray = [self sortingSectionsAndRows:sectionsArray];
}

- (NSMutableArray *)sortingSectionsAndRows:(NSMutableArray *)array
{
    NSSortDescriptor *sortByIndex   = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [array sortUsingDescriptors:[NSArray arrayWithObjects:sortByIndex, nil]];

    for (OSSection *section in array)
    {
        NSMutableArray *sectionRowsArray    = [[NSMutableArray alloc] init];
        [sectionRowsArray addObjectsFromArray:section.rowsArray];
        
        NSSortDescriptor *sortByBirthdate   = [NSSortDescriptor sortDescriptorWithKey:@"birthdate" ascending:YES];
        NSSortDescriptor *sortByFirstName   = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *sortByLastName    = [NSSortDescriptor sortDescriptorWithKey:@"lastName"  ascending:YES];
        
        switch (self.selectedScope)
        {
            case 0:
                [sectionRowsArray sortUsingDescriptors:[NSArray arrayWithObjects:sortByBirthdate, sortByFirstName, sortByLastName, nil]];
                break;
                
            case 1:
                [sectionRowsArray sortUsingDescriptors:[NSArray arrayWithObjects:sortByFirstName, sortByLastName, sortByBirthdate, nil]];
                break;

            case 2:
                [sectionRowsArray sortUsingDescriptors:[NSArray arrayWithObjects:sortByLastName, sortByBirthdate, sortByFirstName, nil]];
                break;
        }

        section.rowsArray = sectionRowsArray;
    }
    
    return array;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.studentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    self.student = [self.studentsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.student.firstName, self.student.lastName];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.student.birthDate]];
    
    return cell;
}

#pragma mark - UISearchBarDelegate -
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchString = searchText;
    [self generateSectionsInBackgroundFromArray:self.studentsArray];
    
    NSLog(@"searchString = %@", searchText);
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    self.selectedScope = selectedScope;
    [self generateSectionsInBackgroundFromArray:self.studentsArray];
    
    //NSLog(@"selectedScope = %d", self.selectedScope);
}

@end
