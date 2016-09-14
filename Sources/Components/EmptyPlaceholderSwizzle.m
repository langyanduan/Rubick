//
//  EmptyPlaceholderSwizzle.m
//  Rubick
//
//  Created by WuFan on 16/9/14.
//
//

#import "EmptyPlaceholderSwizzle.h"

//@implementation EmptyPlaceholderSwizzle
//
//@end
//@interface _TableViewSwizzle : NSObject
//
//
//
//@end
//
//@implementation _TableViewSwizzle
//
//
//
//@end
//
//
//
//void reloadData(id self, SEL _cmd) {
//    struct objc_super super = {
//        .receiver =  self,
//        .super_class = class_getSuperclass(object_getClass(self))
//    };
//    ((void (*)(struct objc_super, SEL))objc_msgSendSuper)(super, _cmd);
//    
//    
//}
//
//void setRect(id self, SEL _cmd, CGRect rect) {
//    struct objc_super super = {
//        .receiver =  self,
//        .super_class = class_getSuperclass(object_getClass(self))
//    };
//    ((void (*)(struct objc_super, SEL, CGRect))objc_msgSendSuper)(super, _cmd, rect);
//}
//
//
//void test() {
//    id base = nil;
//    
//    class_getMethodImplementation(<#__unsafe_unretained Class cls#>, <#SEL name#>)
//    class_getInstanceMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)
//    
//    Class clazz = object_getClass(base);
//    const char *clazzName = class_getName(clazz);
//    char *subclazzName = "";
//    Class subclazz = objc_allocateClassPair(clazz, subclazzName, 0);
//    
//    SEL reloadDataSelector = @selector(reloadData);
//    SEL setFrameSelector = @selector(setFrame:);
//    SEL setBoundsSelector = @selector(setBounds:);
//    
//    class_addMethod(subclazz, reloadDataSelector, (IMP)reloadData, "v@:");
//    class_addMethod(subclazz, setFrameSelector, (IMP)setRect, "v@:");
//    class_addMethod(subclazz, setBoundsSelector, (IMP)setRect, "v@:");
//    
//    objc_registerClassPair(subclazz);
//    
//}
//
