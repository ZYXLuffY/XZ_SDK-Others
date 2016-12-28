
#import "NSObject+XZ.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+MJKeyValue.h"
#import "XZUtility.h"

@implementation NSObject (XZ)

-(BOOL)isArray{
    return [self isKindOfClass:[NSArray class]];
}

-(BOOL)isDict{
    return [self isKindOfClass:[NSDictionary class]];
}

-(NSString *)JsonStr{
    return   [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
}

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,originalSel,class_getMethodImplementation(self, originalSel),method_getTypeEncoding(originalMethod));
    class_addMethod(self,newSel,class_getMethodImplementation(self, newSel), method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}


/** 对应的描述 */
-(NSString *)XZ_DebugDescription{
#ifdef DEBUG
    NSLog(@"%@",self.keyValues);//https://github.com/dhcdht/DXXcodeConsoleUnicodePlugin  装了插件 直打直看
     return self.keyValues.JsonStr;
#endif
    return nil;
}

/** 属性值和列表 */
-(NSDictionary *)propertyDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        if(propValue){
            [dict setObject:propValue forKey:propName];
        }
    }
    free(props);
    return dict;
}

/** 属性集合 */
+ (NSArray *)ClassPropertyList {
    NSMutableArray *allProperties = [[NSMutableArray alloc] init];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        if (propName) {
            [allProperties addObject:propName];
        }
    }
    free(props);
    return [NSArray arrayWithArray:allProperties];
}

- (void)propertyList_methodList_ivarList{
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        if (propertyName) {
            NSLog(@"property---->  %@", propertyName);
        }
        //        id propertyValue = [self valueForKey:(NSString *)propertyName];
    }
    
    free(propertyList);
    //获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for ( int i = 0; i < count; i++) {
        Method method = methodList[i];
        if (method) {
            NSLog(@"method---->  %@", NSStringFromSelector(method_getName(method)));
        }
    }
    
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        if (ivarName) {
             NSLog(@"Ivar---->  %@", [NSString stringWithUTF8String:ivarName]);
        }
       
    }
    
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        if (protocolName) {
            NSLog(@"protocol---->  %@", [NSString stringWithUTF8String:protocolName]);
        }
        
    }
}

+ (BOOL)isNULL_Obj{
    
    return YES;
}


@end
