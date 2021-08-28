#import "AshtonConverter.h"
#import <Foundation/Foundation.h>

@interface AshtonUIKit : NSObject < AshtonConverter >

+ (instancetype)sharedInstance;

- (NSAttributedString *)intermediateRepresentationWithTargetRepresentation:(NSAttributedString *)input;
- (NSAttributedString *)targetRepresentationWithIntermediateRepresentation:(NSAttributedString *)input;

@end
