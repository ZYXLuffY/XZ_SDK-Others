
#import "XZStoryboardSegue.h"

@implementation XZStoryboardSegue

-(void)perform{
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    [source.navigationController pushViewController:destination animated:YES];
}

@end
