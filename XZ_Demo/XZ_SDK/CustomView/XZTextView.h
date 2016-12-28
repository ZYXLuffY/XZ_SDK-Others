
#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, XHInputViewType) {
//    XHInputViewTypeNormal = 0,
//    XHInputViewTypeText,
//    XHInputViewTypeEmotion,
//    XHInputViewTypeShareMenu,
//};

@interface XZTextView : UITextView

/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;

/**
 *  获取自身文本占据有多少行
 */
- (NSUInteger)numberOfLinesOfText;

/**
 *  获取每行的高度
 */
+ (NSUInteger)maxCharactersPerLine;

/**
 *  获取某个文本占据自身适应宽带的行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;


/**
 *  边框啊 传空默认颜色或hex   宽默认1
 */
@property(nonatomic,copy) NSString *bor_c;


/**
 *  强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！)
 */
@property (nonatomic,assign) NSUInteger XZMaxCharactersLength;
/**
 *  强制按text.length长度计算限制文本的最大长度
 */
@property (nonatomic,assign) NSUInteger XZMaxTextLength;
@property (nonatomic,assign) BOOL ShowToolBar;/**< 显示ToolBar */
@property (nonatomic,assign) BOOL ReturnToresign;/**< 点换行是取消响应 */
@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,assign) BOOL DisabelEmoji;/**< 禁止使用表情字符 */


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;



@end
