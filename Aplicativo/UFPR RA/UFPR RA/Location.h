
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#define LOCATION_ENTITY_NAME @"Location"

@interface Location : NSObject

@property (nonatomic, strong) NSManagedObjectID *locationID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

+ (void) saveLocation:(NSString *)locationName latitude:(float)latitude longitude:(float)longitude;
+ (NSArray *) loadLocatoins;
+ (BOOL) removeLocation : (NSManagedObjectID *) locID;

@end
