//
//  DHVaperDetailItemModel.h
//  DHSFit
//
//  Created by DHS on 2025/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHVaperDetailItemModel : NSObject
/// 时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, assign) NSInteger duration; //抽烟时长(秒)
@end

NS_ASSUME_NONNULL_END
