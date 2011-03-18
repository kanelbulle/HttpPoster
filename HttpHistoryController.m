//
//  HttpHistoryController.m
//  HttpPoster
//
//  Created by Emil Arfvidsson on 3/14/11.
//  Copyright 2011 Royal Institute of Technology. All rights reserved.
//

#import "HttpHistoryController.h"


@implementation HttpHistoryController

@synthesize methods;

- (id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		self.methods = [NSArray arrayWithObjects:@"GET", @"POST", @"PUT", @"DELETE", nil];
    }
    
    return self;
}



@end
