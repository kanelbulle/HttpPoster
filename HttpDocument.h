//
//  MyDocument.h
//  HttpPoster
//
//  Created by Emil Arfvidsson on 2/5/11.
//  Copyright 2011 Emil Arfvidsson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HttpDocument : NSDocument
{
	NSTextField *hostField;
	NSTextField *pathField;
	NSTextField *contentTypeField;
	NSTextView *bodyField;
	NSTextView *respField;
	
	NSMutableArray *historyItems;
	NSDictionary *selectedHistoryItem;
	NSUInteger selectedHistoryItemIndex;
	
	NSArray *httpMethods;
	NSUInteger selectedMethodIndex;
}

@property (nonatomic, assign) IBOutlet NSTextField *hostField;
@property (nonatomic, assign) IBOutlet NSTextField *pathField;
@property (nonatomic, assign) IBOutlet NSTextField *contentTypeField;
@property (nonatomic, assign) IBOutlet NSTextView *bodyField;
@property (nonatomic, assign) IBOutlet NSTextView *respField;

@property (nonatomic, retain) NSMutableArray *historyItems;
@property (nonatomic, assign) NSUInteger selectedHistoryItemIndex;
@property (nonatomic, assign) NSDictionary *selectedHistoryItem;

@property (nonatomic, retain) NSArray *httpMethods;
@property (nonatomic, assign) NSUInteger selectedMethodIndex;

- (IBAction) sendButtonPushed:(id)sender;

@end
