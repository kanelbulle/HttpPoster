//
//  HttpHistoryController.h
//  HttpPoster
//
//  Created by Emil Arfvidsson on 3/14/11.
//  Copyright 2011 Royal Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpHistoryController : NSDictionaryController {
    NSArray *methods;
}

@property (nonatomic, retain) NSArray *methods;

@end
