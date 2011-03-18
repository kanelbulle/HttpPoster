//
//  MyDocument.h
//  HttpPoster
//
//  Created by Emil Arfvidsson on 2/5/11.
//  Copyright 2011 Royal Institute of Technology. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface HttpDocument : NSDocument
{
	NSTextField *addressField;
	NSTextView *bodyField;
	NSTextView *respField;
	
	NSMutableArray *historyItems;
	NSInteger selectedHistoryItemIndex;
	NSDictionary *selectedHistoryItem;
	
	NSArray *methods;
	NSInteger selectedMethod;
}

@property (nonatomic, assign) IBOutlet NSTextField *addressField;
@property (nonatomic, assign) IBOutlet NSTextView *bodyField;
@property (nonatomic, assign) IBOutlet NSTextView *respField;

@property (nonatomic, retain) NSMutableArray *historyItems;
@property (nonatomic, assign) NSInteger selectedHistoryItemIndex;
@property (nonatomic, assign) NSDictionary *selectedHistoryItem;


@property (nonatomic, retain) NSArray *methods;
@property (nonatomic, assign) NSInteger selectedMethod;

- (IBAction) sendButtonPushed:(id)sender;

@end
