
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "MapViewController.h"

@protocol MyLocationsDelegate <NSObject>

- (void) didSelectLocation:(CLLocationCoordinate2D)location;

@end

@interface MyLocationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *locations;
}
 

@property (nonatomic, strong) IBOutlet UITableView *locationsTableView;
@property (nonatomic, strong) id<MyLocationsDelegate> delegate;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UINavigationItem *myEditButton;


- (IBAction) closeWindow;
- (IBAction) editAction;

@end
