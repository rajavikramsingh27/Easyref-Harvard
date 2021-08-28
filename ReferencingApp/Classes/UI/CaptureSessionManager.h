#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>


@interface CaptureSessionManager : NSObject {

}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
-(void)addImageOutput;
-(void)lightON;
-(void)lightOFF;
-(void)focusAtPoint:(CGPoint)point;
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates andFrameSize:(CGSize)size;
@end
