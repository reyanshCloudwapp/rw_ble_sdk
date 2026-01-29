//
//  DHBrightTimeSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHBrightTimeSetModel : NSObject

/// 时长（秒 0-255，0表示常亮）
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *durationNums; 
@property (nonatomic, assign) NSInteger muslimMode; //0自定义 1默认

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
