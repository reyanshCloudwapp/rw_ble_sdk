//
//  DHBleCommand.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DHBleSDK/DHBleCommandEnums.h>

#import <DHBleSDK/DHFirmwareVersionModel.h>
#import <DHBleSDK/DHBatteryInfoModel.h>
#import <DHBleSDK/DHTimeSetModel.h>

#import <DHBleSDK/DHBindSetModel.h>

#import <DHBleSDK/DHDeviceLogModel.h>


#import <DHBleSDK/DHHeartRateModeSetModel.h>
#import <DHBleSDK/DHBoModeSetModel.h>
#import <DHBleSDK/DHHrvModeSetModel.h>
#import <DHBleSDK/DHVideoHidSetModel.h>
#import <DHBleSDK/DHLedLightSetModel.h>
#import <DHBleSDK/DHStressModeSetModel.h>
#import <DHBleSDK/DHStressModeSetModel.h>
#import <DHBleSDK/DHBloodSugarModeSetModel.h>
#import <DHBleSDK/DHFlashDurationModel.h>
#import <DHBleSDK/DHBrightTimeSetModel.h>
#import <DHBleSDK/DHAlarmSetModel.h>

#import <DHBleSDK/DHDailyStepModel.h>
#import <DHBleSDK/DHDailySleepModel.h>
#import <DHBleSDK/DHDailyHrModel.h>
#import <DHBleSDK/DHDailyHrvModel.h>
#import <DHBleSDK/DHDailyBoModel.h>
#import <DHBleSDK/DHDailyPressureModel.h>
#import <DHBleSDK/DHDailyBloodSugarModel.h>
#import <DHBleSDK/DHDailyMuslimCountModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHBleCommand : NSObject

#pragma mark - 获取类

/// 获取固件版本信息
/// @param block 回调
+ (void)getFirmwareVersion:(void(^)(int code, id data))block;

/// 获取电量信息
/// @param block 回调
+ (void)getBattery:(void(^)(int code, id data))block;

/// 获取绑定信息
/// @param block 回调
+ (void)getBindInfo:(void(^)(int code, id data))block;

+ (void)getJLBindInfoLogin:(void(^)(int code, id data))block;

/// 获取心率监测
/// @param block 回调
+ (void)getHeartRateMode:(void(^)(int code, id data))block;

/// 获取血氧监测
/// @param block 回调
+ (void)getBoMode:(void(^)(int code, id data))block;

/// 获取HRV监测
/// @param block 回调
+ (void)getHrvMode:(void(^)(int code, id data))block;

+ (void)getStressMode:(void(^)(int code, id data))block;

+ (void)getBloodSugarMode:(void(^)(int code, id data))block;

/// 获取视频控制开关
/// @param block 回调
+ (void)getVideoHid:(void(^)(int code, id data))block;

/// 获取LED亮屏强度
/// @param block 回调
+ (void)getRingLEDLight:(void(^)(int code, id data))block;

/// 获取工厂模式开关
/// @param block 回调
+ (void)getRingInFactory:(void(^)(int code, id data))block;

/// 获取配戴左右手
/// @param block 回调
+ (void)getRingWearHand:(void(^)(int code, id data))block;

+ (void)getBrightTime:(void(^)(int code, id data))block;

/// 获取闹钟提醒
/// @param block 回调
+ (void)getAlarms:(void(^)(int code, id data))block;

+ (void)getMuslimRingFlashDuration:(void(^)(int code, id data))block;
+ (void)getMuslimRingConnectAppBrightTime:(void(^)(int code, id data))block;
+ (void)getRingMuslimGoal:(void(^)(int code, id data))block;

+ (void)getMuslimRingPrayerTimeWakeup:(void(^)(int code, id data))block;

#pragma mark - 设置类
/// 设置绑定信息
/// @param model 模型
/// @param block 回调
+ (void)setBind:(DHBindSetModel *)model block:(void(^)(int code, id data))block;

/// 设置时间
/// @param model 模型
/// @param block 回调
+ (void)setTime:(DHTimeSetModel *)model block:(void(^)(int code, id data))block;


+ (void)setJLTimeZone:(UInt8)timezone block:(void(^)(int code, id data))block;


/// 设置心率监测
/// @param model 模型
/// @param block 回调
+ (void)setHeartRateMode:(DHHeartRateModeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置血氧监测
/// @param model 模型
/// @param block 回调
+ (void)setBoMode:(DHBoModeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置HRV监测
/// @param model 模型
/// @param block 回调
+ (void)setHrvMode:(DHHrvModeSetModel *)model block:(void(^)(int code, id data))block;

+ (void)setStressMode:(DHStressModeSetModel *)model block:(void(^)(int code, id data))block;

+ (void)setBloodSugarMode:(DHBloodSugarModeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置视频控制开关
/// @param model 模型
/// @param block 回调
+ (void)setVideoHid:(DHVideoHidSetModel *)model block:(void(^)(int code, id data))block;

/// 设置LED屏幕亮度
/// @param model 模型
/// @param block 回调
+ (void)setRingLEDLight:(DHLedLightSetModel *)model block:(void(^)(int code, id data))block;

/// 设置视频控制开关
/// @param wearHand 0 左手 1右手
/// @param block 回调
+ (void)setRingWearHand:(UInt8)wearHand block:(void(^)(int code, id data))block;

/// 清理赞念数据
/// @param block 回调
+ (void)setJLMuslimCountClean:(void(^)(int code, id data))block;

/// 设置达标闪屏次数
/// @param goalFlashDuration 赞念目标达到闪屏次数
/// @param alarmFlashDuration 闹钟达到闪屏次数
/// @param block 回调
+ (void)setMuslimRingFlashDuration:(UInt8)goalFlashDuration alarmFlashDuration:(UInt8)alarmFlashDuration block:(void(^)(int code, id data))block;

/// 连接APP时的亮屏时长,单位分钟
/// @param brightTime 亮屏时长,单位分钟, 范围10-60
/// @param block 回调
+ (void)setMuslimRingConnectAppBrightTime:(UInt8)brightTime block:(void(^)(int code, id data))block;

/// 设置赞念目标
/// @param countGoal 赞念目标数量
/// @param mode 模式 0:自定义模式 1: 默认模式
/// @param block 回调
+ (void)setJLMuslimCountGoal:(int32_t)countGoal mode:(UInt8)mode block:(void(^)(int code, id data))block;

+ (void)setBrightTime:(DHBrightTimeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置闹钟提醒
/// @param alarms 闹钟数组
/// @param block 回调
+ (void)setAlarms:(NSArray <DHAlarmSetModel *>*)alarms block:(void(^)(int code, id data))block;

#pragma mark - 控制类

/// 启动健康数据开关(心率,血氧,HRV)
/// @param type （0.关闭 1.打开）
/// @param block 回调
+ (void)controlOpen:(NSInteger)type dataType:(NSInteger)dataType block:(void(^)(int code, id data))block;

/// 拍照控制
/// @param type （0.关闭 1.打开 2.拍照）
/// @param block 回调
+ (void)controlCamera:(NSInteger)type block:(void(^)(int code, id data))block;

/// 开始寻找设备
/// @param block 回调
+ (void)controlFindDeviceBegin:(void(^)(int code, id data))block;

/// 设备控制
/// @param type （0.重启 1.关机 2.恢复出厂设置）
/// @param block 回调
+ (void)controlDevice:(NSInteger)type block:(void(^)(int code, id data))block;

/// 开启赞念
/// @param number 赞念数量
/// @param block 回调
+ (void)controlMuslimRingStart:(NSInteger)number block:(void(^)(int code, id data))block;

/// 结束赞念
/// @param block 回调
+ (void)controlMuslimRingEnd:(void(^)(int code, id data))block;

#pragma mark - 文件传输类

/// Ring  BIN升级
+ (void)startPXIUIFileSyncing:(NSData *)fileData bleKey:(BleKey)bleKey block:(void(^)(int code, CGFloat progress, id data))block;

#pragma mark - 自动同步数据类

/// 自动同步数据
/// @param block 回调
+ (void)startDataSyncing:(void(^)(int code, int progress, id data))block;

+ (void)startDataSyncing:(Boolean)supportStress
       supportBloodSugar:(Boolean)supportBloodSugar
     supportMuslimPraise:(Boolean)supportMuslimPraise
                callback:(void(^)(int code, int progress, id data))block;

@end

NS_ASSUME_NONNULL_END
