//
// Created by wangyang on 2017/3/16.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "NFTARViewController.h"
#import "ARNFTMarkerDetector.h"
#import "ARMarkerPose.h"
#import "LocalNFTMarkerData.h"
#import "ModelManager.h"

#import <EZGLib/EZGL.h>

#define  Bit(n) (0x00000001 << n)

enum CollisionTypes {
    CT_Floor = Bit(0),
    CT_Prop = Bit(1),
    CT_Prop2 = Bit(2),
    CT_Role = Bit(3),
    CT_Prop3 = Bit(4)
};

@interface NFTARViewController () {
    prop_strong(ELWorld, world);
}

@property  (strong, nonatomic) ARNFTMarkerDetector *markDetector;
@end

@implementation NFTARViewController
@synthesize world;
- (void)createMonkey:(ELVector3)position {
    ELFloat width = 17 * 3;
    ELFloat height = 17 * 3;

    auto gameObject = retain_ptr_init_v(ELGameObject, world);
    world->addNode(gameObject);
    gameObject->transform->position = position;
    gameObject->transform->quaternion = ELQuaternionMakeWithAngleAndAxis(M_PI / 2, 1, 0, 0);
    gameObject->transform->scale = ELVector3Make(0.3,0.3,0.3);

    NSString *path = [ModelManager loadSelected3DModel];
    std::vector<ELMeshGeometry *> geometries = ELFBXLoader::loadFromFile([path UTF8String]);
    for (int i = 0; i < geometries.size(); ++i) {
        auto animations = geometries.at(i)->animations;
        auto iter = animations.begin();
        iter ++;
        geometries.at(i)->setAnimation((*iter).second.name);
        geometries.at(i)->generateData();
        gameObject->addComponent(geometries.at(i));
    }
}


std::shared_ptr<ELGameObject> createCubeGameObject(std::shared_ptr<ELWorld> world, ELVector3 size,ELVector3 pos,ELFloat mass,GLuint diffuseMap,GLuint normalMap, bool hasBorder, int collisionGroup, int collisionMask, ELVector3 velocity, bool hasGeometry = false) {
    
    diffuseMap = ELTexture::texture(ELAssets::shared()->findFile("stone_ground.png"))->value;
//    normalMap = ELTexture::texture(ELAssets::shared()->findFile("stone_ground_normal.png"))->value;
    
    auto gameObject = retain_ptr_init_v(ELGameObject, world);
    world->addNode(gameObject);
    gameObject->transform->position = pos;
    gameObject->transform->scale = ELVector3Make(1,1,1);
    if (hasGeometry) {
        ELCubeGeometry *cube = new ELCubeGeometry(size);
        gameObject->addComponent(cube);
        cube->materials[0].diffuse = ELVector4Make(0.3, 0.3, 0.3, 1.0);
        cube->materials[0].ambient = ELVector4Make(0.3,0.3,0.3, 1.0);
        cube->materials[0].diffuseMap = diffuseMap;
        cube->materials[0].normalMap = normalMap;
        cube->enableBorder = hasBorder;
        cube->borderWidth = 0.2;
        cube->borderColor = ELVector4Make(1, 0, 0, 1);
        
    }
    
    auto collisionShape = retain_ptr_init(ELCollisionShape);
    collisionShape->asBox(ELVector3Make(size.x / 2, size.y / 2, size.z / 2));
    ELRigidBody *rigidBody = new ELRigidBody(collisionShape, mass);
    rigidBody->collisionGroup = collisionGroup;
    rigidBody->collisionMask = collisionMask;
    rigidBody->friction = 0.5;
    gameObject->addComponent(rigidBody);
    
    return gameObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markDetector = [[ARNFTMarkerDetector alloc] initWithMarkerFile:self.marker.url.path];
    world->physicsWorld->setGravity(ELVector3Make(0,0,-100));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    ELTexture::clearCache();
}

#pragma mark - Provide Marker Detector

- (id<ARMarkerDetector>)preferMarkerDetector {
    return self.markDetector;
}

#pragma mark - AR Lifecycle

- (void)arDidBeganDetect {
    CGSize markerSize = [self.markDetector markerSize];
    GLuint diffuseTex = ELTexture::texture(ELAssets::shared()->findFile("grass_yellow.jpg"))->value;
//    createCubeGameObject(world, ELVector3Make(20,20,20), ELVector3Make(markerSize.width/2,markerSize.height/2,0.0), 0, 0, 0, NO, CT_Floor, CT_Prop, ELVector3Make(0, 0, 0), true);
    [self createMonkey:ELVector3Make(markerSize.width/2,markerSize.height/2,0.0)];
//    createCubeGameObject(world, ELVector3Make(1000,1000,0), ELVector3Make(94.5,118.25,0.0), 0, 0, 0, NO, CT_Floor, CT_Prop, ELVector3Make(0, 0, 0));
//    for (int i = 0; i < 10; i++) {
//        srand(rand());
//        float randx = rand()/(float)RAND_MAX * 40 - 20;
//        float randy = rand()/(float)RAND_MAX * 40 - 20;
//        createCubeGameObject(world, ELVector3Make(20,20,20), ELVector3Make(0 + randx,0 + randy,70.0 + i * 10), 10, diffuseTex, 0, NO, CT_Prop, CT_Prop | CT_Floor, ELVector3Make(0, 0, 0), true);
//    }
}

- (void)arDetecting:(NSArray *)poses {
    if ([poses count] > 0) {
        ARMarkerPose *pose = (ARMarkerPose *)poses[0];
        world->activedCamera->setMatrixDirect([pose matrix]);
    } else {
        float matrix[16];
        memset(matrix, 0x00, sizeof(float) * 16);
        world->activedCamera->setMatrixDirect(matrix);
    }
}

- (void)arDidPauseDetect {

}

- (void)arDidResumeDetect {
    
}

- (void)arDidEndDetect {

}


@end
