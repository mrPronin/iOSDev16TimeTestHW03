//
//  RITStudent.h
//  16TimeTestHW01
//
//  Created by Aleksandr Pronin on 18.02.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RITStudent : NSObject

@property (strong, nonatomic) NSDate* dateOFBirth;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) NSInteger personalID;

+ (RITStudent*) studentWithlastName:(NSString*) lastName andFirstName:(NSString*) firstName;

@end

