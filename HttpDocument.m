//
//  MyDocument.m
//  HttpPoster
//
//  Created by Emil Arfvidsson on 2/5/11.
//  Copyright 2011 Emil Arfvidsson. All rights reserved.
//

#import "HttpDocument.h"

@implementation HttpDocument

#define HTTP_METHODS [NSMutableArray arrayWithObjects:@"GET", @"POST", @"PUT", @"DELETE", @"HEAD", @"OPTIONS", nil]

#define TITLE_KEY @"title"
#define HOST_KEY @"host"
#define PATH_KEY @"path"
#define METHOD_INDEX_KEY @"method_index"
#define METHOD_KEY @"method"
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
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.apple.com/", TITLE_KEY, @"http://www.apple.com/", HOST_KEY, @"/index.html", PATH_KEY, [NSNumber numberWithUnsignedInteger:0], METHOD_INDEX_KEY, @"GET", METHOD_KEY, @"application/json; charset=utf-8", CONTENT_TYPE_KEY, @"", BODY_KEY, nil];
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
	NSDictionary *form = [self saveForm];

	if (form != nil) {
		[self httpCallWithForm:form];
	} else {
		NSBeep();
	}
}

- (void) httpCallWithForm:(NSDictionary *)form {
	NSString *host = [form objectForKey:HOST_KEY];
	NSString *path = [form objectForKey:PATH_KEY];
	NSString *method = [form objectForKey:METHOD_KEY];
	NSString *contentType = [form objectForKey:CONTENT_TYPE_KEY];
	
	NSURL *url = [NSURL URLWithString:[host stringByAppendingPathComponent:path]];
	NSString *body = [bodyField string];
	body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [data length]];
	
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:method];
	[request setHTTPBody:data];
	
	[NSURLConnection connectionWithRequest:request
								  delegate:self];
}

# pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (fetchedData == nil) {
		fetchedData = [[NSMutableData alloc] initWithCapacity:[data length] * 1.2];
	}
	
	[fetchedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *result = [[NSString alloc] initWithData:fetchedData encoding:NSUTF8StringEncoding];
	[respField setString:result];
	[result release];
	
	[fetchedData release];
	fetchedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[fetchedData release];
	fetchedData	= nil;
}

# pragma mark - Saving

- (NSDictionary *) saveForm {
	NSDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
	[dict setValue:[hostField stringValue] forKey:HOST_KEY];
	[dict setValue:[pathField stringValue] forKey:PATH_KEY];
	[dict setValue:[NSNumber numberWithUnsignedInteger:selectedMethodIndex] forKey:METHOD_INDEX_KEY];
	[dict setValue:[self.httpMethods objectAtIndex:selectedMethodIndex] forKey:METHOD_KEY];
	[dict setValue:[contentTypeField stringValue] forKey:CONTENT_TYPE_KEY];
	[dict setValue:[bodyField string] forKey:BODY_KEY];
	
	[dict setValue:[NSString stringWithFormat:@"%@ @ %@", 
					[pathField stringValue], [hostField stringValue]]
			forKey:TITLE_KEY];
	
	[historyController insertObject:dict atArrangedObjectIndex:0];
	self.selectedHistoryItemIndex = 0;
	
	return dict;
}

# pragma mark - NSDocument stuff

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
