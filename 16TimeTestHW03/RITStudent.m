//
//  RITStudent.m
//  16TimeTestHW01
//
//  Created by Aleksandr Pronin on 18.02.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import "RITStudent.h"

@implementation RITStudent

- (NSString*) description {
    
    NSDateFormatter*    dateFormatter   = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];

    NSDateComponents*   components  = [[NSCalendar currentCalendar]
                                       components:
                                       NSCalendarUnitYear
                                       fromDate:_dateOFBirth
                                       toDate:[NSDate date]
                                       options:0];
    
    return [NSString
            stringWithFormat:@"%@ %@, date fo birth: %@, age: %d",
            _lastName,
            _firstName,
            [dateFormatter stringFromDate:_dateOFBirth],
            [components year]];
}

+ (RITStudent*) studentWithlastName:(NSString*) lastName andFirstName:(NSString*) firstName {
    RITStudent*     student     = [[RITStudent alloc] init];
    student.lastName           = lastName;
    student.firstName           = firstName;
    
    return student;
}

@end
