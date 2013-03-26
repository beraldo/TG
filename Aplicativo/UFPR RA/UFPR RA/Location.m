
#import "Location.h"


@implementation Location

@synthesize locationID, name, latitude, longitude;


+ (void) saveLocation:(NSString *)locationName latitude:(float)lat longitude:(float)lon
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription insertNewObjectForEntityForName:LOCATION_ENTITY_NAME inManagedObjectContext:context];
    
    [locationEntity setValue:locationName forKey:@"name"];
    [locationEntity setValue:[[NSNumber alloc] initWithFloat:lat] forKey:@"latitude"];
    [locationEntity setValue:[[NSNumber alloc] initWithFloat:lon] forKey:@"longitude"];
    
    [request setEntity:locationEntity];
    
    NSError *err = nil;
    
    if ( ! [context save:&err]  )
    {
        NSLog(@"Erro ao salvar a localização: %@", [err localizedDescription] );
    }
}

+ (NSArray *) loadLocatoins
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:LOCATION_ENTITY_NAME inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setEntity:locationEntity];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *err = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&err];
    
    if ( err != nil )
    {
        NSLog(@"Erro ao buscar localizações: %@", [err localizedDescription]);
    }
    
    NSMutableArray *arrLocations = [[NSMutableArray alloc] init];
    for ( NSManagedObject *obj in results )
    {
        Location *location = [[Location alloc] init];
        NSManagedObjectID *locId = [obj objectID];
        [location setLocationID:locId];
        [location setName:[obj valueForKey:@"name"]];
        [location setLatitude:[ obj valueForKey:@"latitude"]];
        [location setLongitude:[obj valueForKey:@"longitude"]];
        
        [arrLocations addObject:location];
    }
    
    return arrLocations;
}



+ (BOOL) removeLocation : (NSManagedObjectID *) locID
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSManagedObject *obj = [context objectWithID:locID];
    [context deleteObject:obj];
    
    NSError *err = nil;
    
    [context save:&err];
    
    if ( err != nil )
    {
        NSLog(@"Erro ao remover localização: %@", [err localizedDescription]);
        return NO;
    }
    
    return YES;
}




@end







