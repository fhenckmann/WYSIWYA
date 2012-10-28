//
//  RemoteDataController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RemoteDataControllerDelegate;

@interface RemoteDataController : NSObject

@property (strong, nonatomic) NSString* serverURL;
@property (strong, nonatomic) id <RemoteDataControllerDelegate> delegate;

- (void) sendRequestToPage:(NSString*)page withParameters:(NSDictionary*)parameters;

@end

@protocol RemoteDataControllerDelegate <NSObject>

- (void) updateProgress:(NSNumber*)progress;
- (void) processResults:(NSArray*)results;
- (void) handleError:(NSString*)error;

@end



