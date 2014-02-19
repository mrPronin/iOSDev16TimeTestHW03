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
@property (strong, nonatomic) NSDateComponents* timerComponents;
@property (strong, nonatomic) NSArray* students;

@end

@implementation RITAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSInteger           studentsNumber  = 30;
    NSMutableArray*     students        = [NSMutableArray array];
    NSCalendar*         calendar        = [NSCalendar currentCalendar];
    NSArray*            firstNames      = @[@"Lex", @"Conrad", @"Alan", @"Alex", @"Amos", @"Bart", @"Ben", @"Bill", @"Bob", @"Jim"];
    NSArray*            lastNames       = @[@"Smith", @"Johnson", @"Brown", @"Brown", @"Moore", @"Robinson", @"King", @"Scott", @"Evans", @"Bell"];
    NSInteger           SecondsInDay    = 60 * 60 * 24;
    
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
        
        student.dateOFBirth             = [NSDate dateWithTimeInterval:arc4random() % (daysNumber + 1) * SecondsInDay sinceDate:firstDateOfYear];
        
        [students addObject:student];
    }
    
    NSComparisonResult (^sortingBlock)(id, id) = ^(id obj01, id obj02) {
        
        RITStudent* student01   = (RITStudent*)obj01;
        RITStudent* student02   = (RITStudent*)obj02;
        
        return [[student02 dateOFBirth] compare:[student01 dateOFBirth]];
        
    };
    
    self.students  = [students sortedArrayUsingComparator:sortingBlock];
    
    /*
    NSLog(@"Students sorted by bitrh date:");
    for (RITStudent* student in sortedByDate) {
        NSLog(@"%@", student);
    }
    */
    
    self.timerDate = [NSDate date];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(birthdayTimer:) userInfo:nil repeats:YES];
    
    return YES;
}

- (void) birthdayTimer:(NSTimer*) timer {
    self.timerDate = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:self.timerDate];
    NSDateFormatter*    dateFormatter   = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSLog(@"%@", [dateFormatter stringFromDate:self.timerDate]);
    
    //self.timerComponents
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
