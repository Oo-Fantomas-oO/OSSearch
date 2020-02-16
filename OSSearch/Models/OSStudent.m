//
//  OSStudent.m
//  OSSearch
//
//  Created by Sergii Onopriienko on 10.02.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "OSStudent.h"

@implementation OSStudent

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static int namesCount = 50;

+(OSStudent *) createRandomStudent {
    
    OSStudent *student = [OSStudent new];
    student.firstName = firstNames[arc4random_uniform(namesCount)];
    student.lastName = lastNames[arc4random_uniform(namesCount)];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    NSInteger yearCurrent = [components year];
    
    NSInteger birthDateYear = yearCurrent - (arc4random_uniform(100));
    NSInteger birthDateDay = arc4random_uniform(31);
    NSInteger birthDateMonth = arc4random_uniform(12);
    
    [components setDay:birthDateDay];
    [components setMonth:birthDateMonth];
    [components setYear:birthDateYear];
    
    student.birthDate = [calendar dateFromComponents:components];
    student.birthDateMonth = birthDateMonth;
    
    return student;
}

@end
