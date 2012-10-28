//
//  RemoteDataController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "RemoteDataController.h"


@implementation RemoteDataController

{
    
    NSMutableData* _receivedData;
    
}

@synthesize serverURL = _serverURL;
@synthesize delegate = _delegate;


- (NSString*) serverURL
{
    
    if (_serverURL) {
        
        return _serverURL;
        
    }
    
    _serverURL = [NSString stringWithFormat:@"http://%@:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ProjectServerAddress"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ProjectServerPort"]];
    
    return _serverURL;
    
}


- (void) appendData:(NSData*)data

{
    
    if (_receivedData == nil) {
        
        _receivedData = [NSMutableData new];
    
    }
    
    [_receivedData appendData:data];
    
}


- (void) sendRequestToPage:(NSString*)page withParameters:(NSDictionary *)parameters

{
    NSURLConnection* connection;
    _receivedData = nil;
    NSString* urlString = [NSString stringWithFormat:@"%@/%@", self.serverURL, page];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* httpBody = [[NSString alloc] init];
    
    if (parameters) {
        
        httpBody = @"?";
        NSEnumerator *enumerator = [parameters keyEnumerator];
        
        for (NSString* key in enumerator) {
            
            httpBody = [NSString stringWithFormat:@"%@&%@=%@", httpBody, key, [parameters valueForKey:key]];
        
        }
        
        NSLog(@"Achieved an http body that looks like this: %@", httpBody);
        
    } else {
        
        httpBody = @"";
        
    }

    
    
    [request setValue:[NSString stringWithFormat:@"%d", [httpBody length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data

{
    
    [self appendData:data];
    
}



- (void) connectionDidFinishLoading:(NSURLConnection*)connection

{
    NSError* error = nil;
    NSArray* results = [NSJSONSerialization JSONObjectWithData:_receivedData options:0 error:&error];
    
    if (error) {
        [self.delegate handleError:[error description]];
    } else {
        [self.delegate processResults:results];
    }
    
}



- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error

{

    [self.delegate handleError:[error description]];
    
}

@end
