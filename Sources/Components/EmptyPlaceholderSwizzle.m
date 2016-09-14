////
////  EmptyPlaceholderSwizzle.m
////  Rubick
////
////  Created by WuFan on 16/9/14.
////
////
//
//#import "EmptyPlaceholderSwizzle.h"
//#import <UIKit/UIKit.h>
//#import <objc/runtime.h>
//#import <objc/message.h>
//
//static void reloadData(id self, SEL _cmd) {
//    struct objc_super super = {
//        .receiver =  self,
//        .super_class = class_getSuperclass(object_getClass(self))
//    };
//    ((void (*)(struct objc_super, SEL))objc_msgSendSuper)(super, _cmd);
//    
//}
//
//static void setFrame(id self, SEL _cmd, CGRect rect) {
//    struct objc_super super = {
//        .receiver =  self,
//        .super_class = class_getSuperclass(object_getClass(self))
//    };
//    ((void (*)(struct objc_super, SEL, CGRect))objc_msgSendSuper)(super, _cmd, rect);
//}
//
//
//static void setBounds(id self, SEL _cmd, CGRect rect) {
//    struct objc_super super = {
//        .receiver =  self,
//        .super_class = class_getSuperclass(object_getClass(self))
//    };
//    ((void (*)(struct objc_super, SEL, CGRect))objc_msgSendSuper)(super, _cmd, rect);
//}
//
//static const void *SwizzleClassTagKey = &SwizzleClassTagKey;
//
//void swizzleTableViewClass(id obj) {
//    Class clazz = object_getClass(obj);
//
//    if (objc_getAssociatedObject(clazz, SwizzleClassTagKey)) {
//        return;
//    }
//    objc_setAssociatedObject(clazz, SwizzleClassTagKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    const char *clazzName = class_getName(clazz);
//    
//    char *subclazzName = alloca(strlen(clazzName) + 10);
//    strcpy(subclazzName, clazzName);
//    strcat(subclazzName, "_EMP_");
//    
//    Class subclazz = objc_getClass(subclazzName);
//    if (subclazz == NULL) {
//        subclazz = objc_allocateClassPair(clazz, subclazzName, 0);
//        
//        SEL reloadDataSelector = @selector(reloadData);
//        SEL setFrameSelector = @selector(setFrame:);
//        SEL setBoundsSelector = @selector(setBounds:);
//        
//        Method reloadDataMethod = class_getInstanceMethod(clazz, reloadDataSelector);
//        Method setFrameMethod = class_getInstanceMethod(clazz, setFrameSelector);
//        Method setBoundsMethod = class_getInstanceMethod(clazz, setBoundsSelector);
//        
//        const char *reloadDataEncoding = method_getTypeEncoding(reloadDataMethod);
//        const char *setFrameEncoding = method_getTypeEncoding(setFrameMethod);
//        const char *setBoundsEncoding = method_getTypeEncoding(setBoundsMethod);
//        
//        class_addMethod(subclazz, reloadDataSelector, (IMP)reloadData, reloadDataEncoding);
//        class_addMethod(subclazz, setFrameSelector, (IMP)setFrame, setFrameEncoding);
//        class_addMethod(subclazz, setBoundsSelector, (IMP)setBounds, setBoundsEncoding);
//        
//        objc_registerClassPair(subclazz);
//    }
//    
//    object_setClass(obj, subclazz);
//}
//
//@interface _GhostTableView : UITableView
//
//@end
//
//@implementation _GhostTableView
//
//
//@end
//
