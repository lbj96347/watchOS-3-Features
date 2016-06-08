//
//  ViewController.m
//  SDKSample
//

#import "DeviceListVC.h"
#import "DroneDiscoverer.h"
#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>

#import "BebopVC.h"
#import "JSVC.h"
#import "MiniDroneVC.h"
#import "SkyControllerVC.h"

#define BEBOP_SEGUE         @"bebopSegue"
#define JS_SEGUE            @"jsSegue"
#define MINIDRONE_SEGUE     @"miniDroneSegue"
#define SKYCONTROLLER_SEGUE @"skyControllerSegue"

@interface DeviceListVC () <UITableViewDelegate, UITableViewDataSource, DroneDiscovererDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic, strong) ARService *selectedService;

@end

@implementation DeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSArray array];
    _droneDiscoverer = [[DroneDiscoverer alloc] init];
    [_droneDiscoverer setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerNotifications];
    [_droneDiscoverer startDiscovering];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self unregisterNotifications];
    [_droneDiscoverer stopDiscovering];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(([segue.identifier isEqualToString:BEBOP_SEGUE]) && (_selectedService != nil)) {
        BebopVC *bebopVC = (BebopVC*)[segue destinationViewController];
        
        [bebopVC setService:_selectedService];
    } else if (([segue.identifier isEqualToString:JS_SEGUE]) && (_selectedService != nil)) {
        JSVC *jsVC = (JSVC*)[segue destinationViewController];
        
        [jsVC setService:_selectedService];
    } else if (([segue.identifier isEqualToString:MINIDRONE_SEGUE]) && (_selectedService != nil)) {
        MiniDroneVC *miniDroneVC = (MiniDroneVC*)[segue destinationViewController];
        
        [miniDroneVC setService:_selectedService];
    } else if (([segue.identifier isEqualToString:SKYCONTROLLER_SEGUE]) && (_selectedService != nil)) {
        SkyControllerVC *skyControllerVC = (SkyControllerVC*)[segue destinationViewController];
        
        [skyControllerVC setService:_selectedService];
    }
}

#pragma mark DroneDiscovererDelegate
- (void)droneDiscoverer:(DroneDiscoverer *)droneDiscoverer didUpdateDronesList:(NSArray *)dronesList {
    _dataSource = dronesList;
    [_tableView reloadData];
}

#pragma mark notification registration
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name: UIApplicationWillEnterForegroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitle:) name:@"notificationReady" object: nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationWillEnterForegroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationReady" object: nil];
}

#pragma mark - application notifications
- (void)enterForeground:(NSNotification*)notification {
    [_droneDiscoverer startDiscovering];
}

- (void)enteredBackground:(NSNotification*)notification {
    [_droneDiscoverer stopDiscovering];
}

- (void)updateTitle:(NSNotification*)notification {
    self.titleLabel.text = @"Parrot SDK Sample ( Watch is Ready )";
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((ARService*)[_dataSource objectAtIndex:indexPath.row]).name;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedService = [_dataSource objectAtIndex:indexPath.row];
    
    switch (_selectedService.product) {
        case ARDISCOVERY_PRODUCT_ARDRONE:
        case ARDISCOVERY_PRODUCT_BEBOP_2:
            [self performSegueWithIdentifier:BEBOP_SEGUE sender:self];
            break;
        case ARDISCOVERY_PRODUCT_JS:
        case ARDISCOVERY_PRODUCT_JS_EVO_LIGHT:
            case ARDISCOVERY_PRODUCT_JS_EVO_RACE:
            [self performSegueWithIdentifier:JS_SEGUE sender:self];
            break;
        case ARDISCOVERY_PRODUCT_MINIDRONE:
        case ARDISCOVERY_PRODUCT_MINIDRONE_EVO_BRICK:
        case ARDISCOVERY_PRODUCT_MINIDRONE_EVO_LIGHT:
            [self performSegueWithIdentifier:MINIDRONE_SEGUE sender:self];
            break;
        case ARDISCOVERY_PRODUCT_SKYCONTROLLER:
            [self performSegueWithIdentifier:SKYCONTROLLER_SEGUE sender:self];
            break;
        default:
            break;
    }
}
@end
