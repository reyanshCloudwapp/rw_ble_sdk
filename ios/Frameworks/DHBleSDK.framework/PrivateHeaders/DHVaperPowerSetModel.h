//
//  DHVaperPowerSetModel.h
//  DHSFit
//
//  Created by DHS on 2024/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHVaperPowerSetModel : NSObject
@property (nonatomic, assign) NSInteger vaperPower;
@property (nonatomic, assign) NSInteger vaperPowerType;
@property (nonatomic, assign) NSInteger vaperPowerLevelNum;
@property (nonatomic, copy) NSString *vaperPowerLevel;

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
