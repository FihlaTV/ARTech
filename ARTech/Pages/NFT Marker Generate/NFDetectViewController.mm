//
//  NFDetectViewController.m
//  ARTech
//
//  Created by wangyang on 2017/3/16.
//  Copyright © 2017年 wangyang. All rights reserved.
//

#import "NFDetectViewController.h"
#import "ARNaturalFeatureDetector.h"
#import "ARCameraCapture.h"
#import "ARNFTDataCreator.h"
#import "NFTMarkerPreviewViewController.h"
#import "HexColor.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <TSMessage.h>

@interface NFDetectViewController () {
    uint8_t *detectingPlane;
    uint8_t *waitingPlane;
    cv::KeyPoint first;
    BOOL ptValid;
    ELGameObject *nfPlane;
    ELTexture *featureDetectTexture;
    BOOL needCapture;
    BOOL isGenNFT;
    BOOL isProcessingStrengthDetect;
}

@property (strong, nonatomic) ARNaturalFeatureDetector *nfDetector;
@property (nonatomic) dispatch_queue_t detectQueue;
@property (nonatomic) dispatch_queue_t genQueue;
@property (nonatomic) dispatch_semaphore_t semaphore;
@property (weak, nonatomic) UILabel * detectStrengthLabel;
@end

@implementation NFDetectViewController
ELGameObject * createVideoPlane3(ELWorld *world, ELVector2 size, GLuint diffuseMap, GLuint normalMap) {
    ELGameObject *gameObject = new ELGameObject(world);
    world->addNode(gameObject);
    EL2DPlane *plane = new EL2DPlane(size);
    gameObject->addComponent(plane);
    plane->materials[0].diffuseMap = diffuseMap;
    plane->materials[0].normalMap = normalMap;
    return gameObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nfDetector = [ARNaturalFeatureDetector new];
    ptValid = NO;
    needCapture = NO;
    featureDetectTexture = ELTexture::texture(ELAssets::shared()->findFile("particle_point.png"));

    [self setupNavigationBar];
    [self setupDetectStrengthLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

- (void)dealloc {

}

- (void)arWillProcessFrame:(AR2VideoBufferT *)buffer {
    if (needCapture) {
        needCapture = NO;
        self.detectStrengthLabel.hidden = YES;
        [self beginGenNFTMarker];
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.detectStrengthLabel.hidden = NO;
        isGenNFT = YES;
        dispatch_async(self.genQueue, ^ {
            [ARNFTDataCreator genNFTDataWithImage:image];
            [self endGenNFTMarker:image];
            isGenNFT = NO;
        });
    }
    if (!isGenNFT && !isProcessingStrengthDetect) {
        isProcessingStrengthDetect = YES;
        static std::vector<cv::KeyPoint> kpts;
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self copyBuf:buffer->bufPlanes[0] to:waitingPlane size:self.cameraCapture.arParamLT->paramLTf.xsize * self.cameraCapture.arParamLT->paramLTf.ysize * sizeof(uint8_t)];
        dispatch_semaphore_signal(self.semaphore);
        dispatch_async(self.detectQueue, ^{
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            uint8_t *swapTemp = waitingPlane;
            waitingPlane = detectingPlane;
            detectingPlane = swapTemp;
            dispatch_semaphore_signal(self.semaphore);
            std::vector<cv::KeyPoint> keyPts = [self.nfDetector detectFeatures:detectingPlane size:CGSizeMake(self.cameraCapture.arParamLT->paramLTf.xsize, self.cameraCapture.arParamLT->paramLTf.ysize)];
            if (keyPts.size() > 0) {
                first = keyPts.at(keyPts.size() - 1);
                ptValid = YES;
            } else {
                ptValid = NO;
            }
            if(ptValid) {
                dispatch_async(dispatch_get_main_queue(), ^() {
                    [self setDetectStrength:keyPts.size()];
                });
            }

            kpts = keyPts;
            isProcessingStrengthDetect = NO;
        });
    }
}

-(void)arDidBeganDetect {
    int bufSize = self.cameraCapture.arParamLT->paramLTf.xsize * self.cameraCapture.arParamLT->paramLTf.ysize;
    waitingPlane = (uint8_t *)malloc(bufSize);
    detectingPlane = (uint8_t *)malloc(bufSize);
    memset(waitingPlane, 0xaa, bufSize);
    memset(detectingPlane, 0xaa, bufSize);
}


- (dispatch_queue_t)detectQueue {
    if (_detectQueue == nil) {
        _detectQueue = dispatch_queue_create("queue.detectNF", 0);
    }
    return _detectQueue;
}

- (dispatch_queue_t)genQueue {
    if (_detectQueue == nil) {
        _detectQueue = dispatch_queue_create("queue.genNFT", 0);
    }
    return _detectQueue;
}

- (dispatch_semaphore_t)semaphore {
    if (_semaphore == nil) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void)copyBuf:(uint8_t *)fromBuf to:(uint8_t *)toBuf size:(int)size {
    if (toBuf && fromBuf) {
        memcpy(toBuf, fromBuf, size);
    }
}

- (void)setupNavigationBar {
    UIBarButtonItem *captureButton = [[UIBarButtonItem alloc] initWithTitle:@"制作NFT标记" style:UIBarButtonItemStylePlain target:self action:@selector(captureButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:captureButton];
}

- (void)setupDetectStrengthLabel {
    UILabel *detectStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    detectStrengthLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    detectStrengthLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:detectStrengthLabel];
    self.detectStrengthLabel = detectStrengthLabel;
}

- (void)setDetectStrength:(int)keyPointsCount {
    if (keyPointsCount < 1000) {
        self.detectStrengthLabel.backgroundColor = [UIColor colorWithHexString:@"#ff2222" alpha:0.6];
    } else if (keyPointsCount < 3000) {
        self.detectStrengthLabel.backgroundColor = [UIColor colorWithHexString:@"#ffad22" alpha:0.6];
    } else {
        self.detectStrengthLabel.backgroundColor = [UIColor colorWithHexString:@"#5ed25e" alpha:0.6];
    }
    self.detectStrengthLabel.text = [NSString stringWithFormat:@" NFT特征点数目：%d",keyPointsCount];
}

- (void)captureButtonClicked: (id)sender {
    needCapture = YES;
}

- (void)beginGenNFTMarker {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)endGenNFTMarker:(UIImage *)markerImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NFTMarkerPreviewViewController *previewViewController = [NFTMarkerPreviewViewController new];
        previewViewController.previewImage = markerImage;
        [self.navigationController pushViewController:previewViewController animated:YES];
        [TSMessage showNotificationWithTitle:@"NFT 标记生成成功" type:TSMessageNotificationTypeSuccess];
    });
}
@end
