
#import "NSDictionary+XZ.h"

@interface XZObjcJsonPropertyCreate : NSObject{
    NSMutableString       *Str_interface;        //存类头文件内容
    NSMutableString       *Str_implementation;   //存类源文件内容
    NSArray               <NSMutableString*> *Arr_interface_implementation;//0-Str_interface   1-Str_implementation 分开放 好复制呀
    NSString              *Str_ModName;
    
    NSMutableDictionary   *Dic_haveReplacedKey;/**< 有需要替换的键值对 */
    NSMutableDictionary   *Dic_ChildArrClass;/**< dic - dic */
}

- (NSArray*)JsonPropertyCreateWihtModName:(NSString*)modName dic:(NSDictionary*)dict;

@end


@implementation XZObjcJsonPropertyCreate

#define __interface         (@("\n#pragma mark - ====== ====== ====== ====== ====== ====== \n@interface %@ : NSObject\n\n%@\n@end\n"))
#define __implementation    (@("@implementation %@\n\n@end\n"))
#define __property          (@("@property (nonatomic,strong) %@  * %@; ///< <#...#>\n"))
#define __propertyCopy      (@("@property (nonatomic,copy) %@  * %@; ///< <#...#>\n"))

-(void)dealloc{
    //    NSLog(@"XZObjcJsonPropertyCreate dealloc dealloc dealloc dealloc dealloc dealloc dealloc");
}

- (NSArray*)JsonPropertyCreateWihtModName:(NSString*)modName dic:(NSDictionary*)dict{
    Str_interface = [NSMutableString new];
    Str_implementation = [NSMutableString new];
    Arr_interface_implementation = @[Str_interface,Str_implementation];
    Dic_ChildArrClass = [NSMutableDictionary dictionary];
    Dic_haveReplacedKey = [NSMutableDictionary dictionary];
    
    Str_ModName = modName;
    
    [Str_implementation appendFormat:__implementation,Str_ModName];
    [Str_interface appendFormat:__interface,Str_ModName,[self createCode:dict]];
    
    return Arr_interface_implementation;
}

- (NSString*)createCode:(id)object{
    if(![object isKindOfClass:[NSDictionary class]]){
        return @"";
    }
    
    NSMutableString  * property = [NSMutableString new];
    NSDictionary  * dict = object;
    NSArray       * keyArr = [dict allKeys];
    
    for (NSInteger i = 0; i < dict.count; i++) {
        NSString *Key = keyArr[i];
        id subObject = object[Key];
        
        if ([Key isEqualToString:@"id"] || [Key hasPrefix:@"new"] || [Key hasPrefix:@"copy"]) {//id alloc，new，copy，mutableCopy
            Key = [Key capitalizedString];
            [Dic_haveReplacedKey setValue:@[keyArr[i],Key] forKey:Key];
        }
        
        /////////////////////////////////////////////////////////////////////////////////////
        void (^createSubclassBlock)() = ^(NSDictionary *ChildDic,Boolean *isArr){
            NSString * ChildclassName = [NSString stringWithFormat:@"%@_%@",Str_ModName,Key];
            [property appendFormat:__property,isArr ? [NSString stringWithFormat:@"NSMutableArray  <%@ *>",ChildclassName] : ChildclassName,Key];
            if (isArr) {
                [Dic_ChildArrClass setValue:ChildclassName forKey:Key];
            }
            
            NSArray *nextObj = [[XZObjcJsonPropertyCreate alloc] JsonPropertyCreateWihtModName:ChildclassName dic:ChildDic];
            [[Arr_interface_implementation firstObject] appendFormat:@"\n%@",[nextObj firstObject]];
            [[Arr_interface_implementation lastObject] appendFormat:@"\n%@",[nextObj lastObject]];
        };
        /////////////////////////////////////////////////////////////////////////////////////
        
        if([subObject isKindOfClass:[NSDictionary class]]){
            createSubclassBlock(subObject,NO);
        }else if ([subObject isKindOfClass:[NSArray class]]){
            if ([((NSArray*)subObject).firstObject isKindOfClass:[NSDictionary class]]) {//数组里面是模型
                createSubclassBlock(((NSArray*)subObject).firstObject,YES);
            }else{//数组里面其他的 都算字符串好了
                [property appendFormat:__property,[NSString stringWithFormat:@"NSMutableArray  <%@ *>",NSStringFromClass([NSString class])],Key];
            }
            
        }else if ([subObject isKindOfClass:[NSString class]]){
            NSString *add = [NSString stringWithFormat:__propertyCopy,@"NSString",Key];
            add = [add stringByReplacingOccurrencesOfString:@"<#...#>" withString:((NSString*)subObject).length >= 20 ? [((NSString*)subObject) substringToIndex:20] : subObject];
            [property appendString:add];
        }else if ([subObject isKindOfClass:[NSNumber class]]){//🤔🤔🤔 NSNumber -> NSString
            [property appendFormat:__property,@"NSString",Key];
            //[property appendFormat:__property,@"NSNumber",Key];
        }else{
            [property appendFormat:__propertyCopy,@"NSString",Key];
        }
    }
    
    if ((Dic_haveReplacedKey).count != 0) {
        NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:Dic_haveReplacedKey options:0 error:NULL] encoding:NSUTF8StringEncoding];
        [Str_implementation insertString:[NSString stringWithFormat:@"+ (NSDictionary *)replacedKeyFromPropertyName{ return @%@;}\n\n",jsonStr] atIndex:[Str_implementation rangeOfString:@"@end"].location];
    }
    
    if (Dic_ChildArrClass.count != 0) {
        NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:Dic_ChildArrClass options:0 error:NULL] encoding:NSUTF8StringEncoding];
        [Str_implementation insertString:[NSString stringWithFormat:@"+ (NSDictionary *)obXZctClassInArray{return @%@;}\n\n",jsonStr] atIndex:[Str_implementation rangeOfString:@"@end"].location];
    }
    
    //构建obcj Code
    BOOL firstChar = YES;
    for (int i = 0; i < Str_implementation.length; i ++) {
        NSString *chars = [Str_implementation substringWithRange:NSMakeRange(i, 1)];
        if ([chars isEqualToString:@"["]) {
            [Str_implementation insertString:@"@" atIndex:i];i++;
        }
        if ([chars isEqualToString:@"\""]) {
            if (firstChar) {
                [Str_implementation insertString:@"@" atIndex:i];i++;
            }
            firstChar = !firstChar;
        }
    }
    
    return property;
}

@end








#pragma mark -

@implementation NSDictionary (XZ)

- (NSDictionary*)addValue:(id)value forKey:(NSString *)key{
    if ([self isKindOfClass:[NSMutableDictionary class]]) {
        [self setValue:value ? : @"" forKey:key];
        return self;
    }
    NSAssert(@"NSMutableDictionary", @"");
    return nil;
}

/** 创建 xcode @property (nonatomic, ----- *** */
- (void)XZ_propertyCode:(NSString*)modName{
#ifdef DEBUG
    NSArray *int_imp = [[XZObjcJsonPropertyCreate alloc] JsonPropertyCreateWihtModName:modName dic:self];
    NSLog(@"\n\n👇👇interface👇👇 %@ \n\n👇👇implementation👇👇 \n\n%@\n",[int_imp firstObject],[int_imp lastObject]);
#endif
}

/** 获得的字符串 至少返回 @"" */
- (NSString*)str:(NSString*)key{
    id value = self[key];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@",value];
}

/** 将NSDictionary转换成url 参数字符串 */
- (NSString *)URLQueryString{
    NSMutableString *urlString =[NSMutableString string];
    for (id key in self) {
        [urlString appendFormat:@"%@%@=%@",(urlString.length == 0) ? @"?" : @"&",key,[self valueForKey:key]];
    }
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
