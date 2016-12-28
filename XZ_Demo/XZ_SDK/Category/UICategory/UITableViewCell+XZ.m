
#import "UITableViewCell+XZ.h"


@implementation UITableViewCell (XZ)

/** cell 对应的 indexpath */
-(NSIndexPath *)indexPath{
    return [self.superTableView indexPathForCell:self];
}

- (UITableView*)superTableView{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UITableView class]]) {
            return (UITableView *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}


- (instancetype)XZ_reloadCell{
    return self;
}


@end
