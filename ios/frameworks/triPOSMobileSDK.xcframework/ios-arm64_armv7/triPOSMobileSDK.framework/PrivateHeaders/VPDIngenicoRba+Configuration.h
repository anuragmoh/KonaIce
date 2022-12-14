///
/// \file VPDIngenicoRba+Configuration.h
///

#ifndef VPDIngenicoRba_Configuration_h
#define VPDIngenicoRba_Configuration_h

#ifndef DOXYGEN_SHOULD_SKIP_THIS

#import "VPDIngenicoRba.h"

@interface VPDIngenicoRba(Configuration)

-(BOOL)configure:(VPDInitializationParameters *)parameters model:(NSString *)model applicationVersion:(VPDVersionNumber *)applicationVersion error:(NSError **)error;

-(NSString *)getConfiguration:(NSString *)groupAndIndex error:(NSError **)error;

-(BOOL)setConfiguration:(NSString *)groupAndIndex value:(NSString *)value error:(NSError **)error;

-(BOOL)setConfiguration:(NSDictionary<NSString *, NSString *> *)configurationItems error:(NSError **)error;

-(NSString *)getVariable:(NSString *)variableId error:(NSError **)error;

-(void)enableNotifications:(BOOL)enable;

@end

@interface RbaModelInfo : NSObject

@property (retain, nonatomic) VPDVersionNumber *version;

@property (retain, nonatomic) NSString *firmwareFileName;

@property (retain, nonatomic) NSString *p2peEnableFileName;

@property (retain, nonatomic) NSString *formsFileName;

@property (retain, nonatomic) NSString *customPromptsFileName;

@property (retain, nonatomic) NSString *p2peEnableAlternativeFileName;

+(RbaModelInfo *)rbaModelInfoWithVersion:(NSString *)version firewareFileName:(NSString *)firmwareFileName p2peEnableFileName:(NSString *)p2peEnableFileName formsFileName:(NSString *)formsFileName customPromptsFileName:(NSString *)customPromptsFileName;

+(RbaModelInfo *)rbaModelInfoWithVersion:(NSString *)version firewareFileName:(NSString *)firmwareFileName p2peEnableFileName:(NSString *)p2peEnableFileName formsFileName:(NSString *)formsFileName customPromptsFileName:(NSString *)customPromptsFileName p2peEnableAlternativeFileName :(NSString *)p2peEnableAlternateFileName;

@end

#endif /* !DOXYGEN_SHOULD_SKIP_THIS */

#endif /* VPDIngenicoRba_Configuration_h */
