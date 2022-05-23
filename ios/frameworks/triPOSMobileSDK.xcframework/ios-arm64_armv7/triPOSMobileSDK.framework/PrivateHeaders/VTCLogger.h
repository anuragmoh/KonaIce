//
//  \file VTCLogger.h
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif



#define NSLog(args...) VTCLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

void VTCLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

#ifdef __cplusplus
}
#endif
    
    
@interface VTCLogger : NSObject

@property (retain, nonatomic, readonly) NSArray<NSString *> *logFileList;
@property (class) NSString *identifier;

+(NSString *) getLogIdentifier;
+(void) resetLogIdentifier;

@end
