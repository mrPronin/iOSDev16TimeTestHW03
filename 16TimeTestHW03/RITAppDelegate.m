//
//  RITAppDelegate.m
//  16TimeTestHW03
//
//  Created by Pronin Alexander on 19.02.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import "RITAppDelegate.h"
#import "RITStudent.h"

@interface RITAppDelegate ()

@property (strong, nonatomic) NSDate* timerDate;
@property (strong, nonatomic) NSMutableDictionary* studentsDict;
@property (strong, nonatomic) NSDate* timerStopDate;

@end

@implementation RITAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSInteger           studentsNumber  = 200;
    NSMutableArray*     students        = [NSMutableArray array];
    NSCalendar*         calendar        = [NSCalendar currentCalendar];
    NSArray*            firstNames      = @[@"Lex", @"Conrad", @"Alan", @"Alex", @"Amos", @"Bart", @"Ben", @"Bill", @"Bob", @"Jim"];
    NSArray*            lastNames       = @[@"Smith", @"Johnson", @"Brown", @"Brown", @"Moore", @"Robinson", @"King", @"Scott", @"Evans", @"Bell"];
    NSInteger           secondsInDay    = 60 * 60 * 24;
    
    for (int i = 0; i < studentsNumber; i++) {
        
        RITStudent*     student         = [RITStudent studentWithlastName:lastNames[arc4random() % 10] andFirstName:firstNames[arc4random() % 10]];
        student.personalID              = i + 1;
        
        // define first date for year of birth
        NSInteger           studentAge  = arc4random() % 35 + 16;
        NSDate*             today       = [NSDate date];
        NSDateComponents*   comp        = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
        comp.year   -= studentAge;
        comp.month  = 1;
        comp.day    = 1;
        NSDate* firstDateOfYear         = [calendar dateFromComponents:comp];
        
        comp.month  = 12;
        comp.day    = 31;
        NSDate* lastDateOfYear          = [calendar dateFromComponents:comp];
        
        // days number in the birth year
        NSInteger           daysNumber  = [calendar
                                           ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitYear
                                           forDate:lastDateOfYear];
        
        student.dateOFBirth             = [NSDate dateWithTimeInterval:arc4random() % (daysNumber + 1) * secondsInDay sinceDate:firstDateOfYear];
        
        [students addObject:student];
    }
    
    NSComparisonResult (^sortingBlock)(id, id) = ^(id obj01, id obj02) {
        
        RITStudent* student01   = (RITStudent*)obj01;
        RITStudent* student02   = (RITStudent*)obj02;
        
        return [[student02 dateOFBirth] compare:[student01 dateOFBirth]];
        
    };
    
    NSArray* sortedStudents  = [students sortedArrayUsingComparator:sortingBlock];
    
    RITStudent* mostYounger = sortedStudents[0];
    RITStudent* mostSenior  = sortedStudents[[sortedStudents count] - 1];
    
    NSDate* firstDate       = mostYounger.dateOFBirth;
    NSDate* lastDate        = mostSenior.dateOFBirth;
    
    NSDateComponents*   components  = [calendar
                                       components:
                                       NSCalendarUnitYear |
                                       NSCalendarUnitMonth |
                                       NSCalendarUnitDay
                                       fromDate:lastDate
                                       toDate:firstDate
                                       options:0];
    
    NSLog(@"Age difference in ages: %d, months: %d and days: %d", components.year, components.month, components.day);
    
    // create dictionary with date-key for students object
    
    self.studentsDict   = [NSMutableDictionary dictionary];
    
    for (RITStudent* student in sortedStudents) {
        
        NSDate* dateOfBirth     = student.dateOFBirth;
        
        NSDateComponents* componentsOfDate = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:dateOfBirth];
        
        NSDate* dateWithoutYear = [calendar dateFromComponents:componentsOfDate];
        
        // check for the date in the dictionary
        
        NSMutableArray* array = [self.studentsDict objectForKey:dateWithoutYear];
        
        if (!array) {
            
            // create mutable array for store multiple objects with same date
            
            array   = [NSMutableArray array];
            
            [self.studentsDict setObject:array forKey:dateWithoutYear];
            
        };
        
        [array addObject:student];
    }
    
    self.timerDate = [NSDate date];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(birthdayTimer:) userInfo:nil repeats:YES];
    
    NSDateComponents*   dateCompontnts  = [[NSDateComponents alloc] init];
    
    [dateCompontnts setYear: 1];
    
    self.timerStopDate              = [calendar
                                       dateByAddingComponents:dateCompontnts
                                       toDate:self.timerDate
                                       options:0];
    
    return YES;
}

- (void) birthdayTimer:(NSTimer*) timer {
    
    self.timerDate = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:self.timerDate];
    
    if (!([self.timerDate compare:self.timerStopDate] == NSOrderedAscending)) {
        [timer invalidate];
    };
    
    NSDateFormatter*    dateFormatter   = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSLog(@"%@ / %@",
          [dateFormatter stringFromDate:self.timerDate],
          [dateFormatter stringFromDate:self.timerStopDate]
          );
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* componentsOfDate = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:self.timerDate];
    
    NSDate* dateWithoutYear = [calendar dateFromComponents:componentsOfDate];
    
    NSMutableArray* array = [self.studentsDict objectForKey:dateWithoutYear];
    
    if (array) {
        
        NSLog(@"--------------------------------------------------------------------");
        
        // show students with birthday today
        for (int i = 0; i < [array count]; i++) {
            RITStudent* student = array[i];
            NSLog(@"Happy birthday %@", student);
        };
        
        NSLog(@"--------------------------------------------------------------------");
        
    };
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
