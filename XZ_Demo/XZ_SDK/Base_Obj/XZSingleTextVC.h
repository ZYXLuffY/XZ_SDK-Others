//
//  XZSingleTextVC.h
//  EVGO
//
//  Created by XZ on 15/8/22.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZTextView.h"
#import "XZTextField.h"

typedef void(^ResString)(NSString *Res);

@interface XZSingleTextVC : UIViewController
@property (nonatomic,strong) ResString ResCall;

@property (nonatomic,copy) NSString *VcTitle;
@property (nonatomic,copy) NSString *DefaultText;
@property (nonatomic,copy) NSString *PlaceText;
@property (nonatomic,assign) NSUInteger limit;
@property (nonatomic,assign) NSUInteger VHeight;

@property (nonatomic,strong) XZTextView *TextV_;
@property (nonatomic,strong) XZTextField *Tf_;
@property (nonatomic,assign) BOOL UseTextField;


/** Push一个编辑TextView */
+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title Text:(NSString*)text  Limit:(NSUInteger)limit Call:(ResString)call;
/** Push一个编辑的TextView */
+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title Text:(NSString*)text placeHolder:(NSString*)place  Limit:(NSUInteger)limit TextH:(NSUInteger)textH Call:(ResString)call;
/** Push一个编辑的 TextField */
+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title TfText:(NSString*)text placeHolder:(NSString*)place  Limit:(NSUInteger)limit Call:(ResString)call;

@property (nonatomic,copy)   NSString *UseTableSex;/**< tableview 选性别 */
/** Push一个选择性别的 */
+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title Sex:(NSString*)sex Call:(ResString)call;

@end
