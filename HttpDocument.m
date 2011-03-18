//
//  MyDocument.m
//  HttpPoster
//
//  Created by Emil Arfvidsson on 2/5/11.
//  Copyright 2011 Emil Arfvidsson. All rights reserved.
//

#import "HttpDocument.h"

@implementation HttpDocument

#define HTTP_METHODS [NSArray arrayWithObjects:@"GET", @"POST", @"PUT", @"DELETE", @"HEAD", nil]

#define TITLE_KEY @"title"
#define HOST_KEY @"host"
#define PATH_KEY @"path"
#define METHOD_KEY @"method_index"
#define CONTENT_TYPE_KEY @"content_type"
#define BODY_KEY @"body"
#define RESPONSE_BODY_KEY @"response_body"

@synthesize hostField, pathField, contentTypeField, bodyField, respField;

@synthesize historyItems;
@synthesize selectedHistoryItem;

@synthesize httpMethods;
@synthesize selectedMethodIndex;

- (id)init
{
    self = [super init];
    if (self) {
		self.historyItems = [NSMutableArray arrayWithCapacity:5];
		
		self.httpMethods = HTTP_METHODS;
		self.selectedMethodIndex = 0;
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.apple.com/", @"title", @"http://www.apple.com/", @"host", @"/index.html", @"path", [NSNumber numberWithUnsignedInteger:2], @"methodIndex", nil];
		[self.historyItems addObject:dict];
		dict = [NSDictionary dictionaryWithObjectsAndKeys:@"hi there", @"title", nil];
		[self.historyItems addObject:dict];
		
		self.selectedHistoryItemIndex = 0;

    }
    return self;
}

- (void) setSelectedHistoryItemIndex:(NSUInteger)index {
	self.selectedHistoryItem = [self.historyItems objectAtIndex:index];
	
	NSNumber *httpIndex = [selectedHistoryItem objectForKey:@"methodIndex"];
	self.selectedMethodIndex = [httpIndex unsignedIntegerValue];
	
	selectedHistoryItemIndex = index;
}

- (NSUInteger) selectedHistoryItemIndex {
	return selectedHistoryItemIndex;
}

- (IBAction) sendButtonPushed:(id)sender {
	[respField setString:@""];
	
	NSURL *url = [NSURL URLWithString:[hostField stringValue]];
	NSString *body = [bodyField string];
	body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [data length]];
	
	[request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:data];
	
	NSURLResponse *response;
	data = [NSURLConnection sendSynchronousRequest:request
										 returningResponse:&response
													 error:NULL];
	
	if ([data length] == 0) {
		NSLog(@"data length was zero");
	} else {
		NSLog(@"responseLength: %lu", [data length]);
		NSString *requestResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		NSLog(@"respField: %@", respField);
		NSLog(@"response: %@", requestResponse);
		[respField setString:requestResponse];
		
		[requestResponse release];
	}
	
}


- (NSString *)windowNibName
{
    return @"HttpDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
