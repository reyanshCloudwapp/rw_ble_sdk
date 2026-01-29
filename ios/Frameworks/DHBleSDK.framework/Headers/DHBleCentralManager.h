//
//  DHBleCentralManager.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <DHBleSDK/DHBleConnectDelegate.h>

NS_ASSUME_NONNULL_BEGIN


@interface DHBleCentralManager : NSObject

/// 单例
+ (__kindof DHBleCentralManager *)shareInstance;
/// 初始化设置服务
/// @param uuids 服务UUID
+ (void)initWithServiceUuids:(NSArray <NSString *>*)uuids;
/// 开始搜索 注意:如果设备未解绑,即使搜索到设备也不调用代理返回设备列表
+ (void)startScan;
/// 停止搜索
+ (void)stopScan;
/// 自动连接已绑定的设备
+ (void)autoReconnectDevice;
/// 连接绑定过的设备
/// @param model 设备模型
+ (void)connectHistoricalDeviceWithModel:(DHPeripheralModel *)model;
/// 连接设备
/// @param model 设备模型
+ (void)connectDeviceWithModel:(DHPeripheralModel *)model;
/// 断开连接
+(void)disconnectDevice;
/// 蓝牙关闭状态
+ (BOOL)isPoweredOff;
/// 设备连接状态
+ (BOOL)isConnected;
/// 设备绑定状态
+ (BOOL)isBinded;
/// 设置绑定状态
/// @param isBinded 是否绑定
+ (void)setBindedStatus:(BOOL)isBinded;
/// 设置是否打印日志
/// @param isLog 是否打印日志
+ (void)setLogStatus:(BOOL)isLog;
///是否为杰里平台蓝牙协议(根据服务号区分)
+ (BOOL)isJLProtocol;

/// 蓝牙连接代理
@property (nonatomic, weak) id<DHBleConnectDelegate> connectDelegate;
/// 蓝牙命令代理
//@property (nonatomic, weak) id<DHBleCommandDelegate> commandDelegate;

- (void)clearData;

#pragma mark - 杰理蓝牙库OTA流程相关业务
@property (nonatomic, strong) NSString *__nullable lastBleMacAddress;     // 上一次连接的蓝牙地址
@property (nonatomic, assign) BOOL isJLOTAing;  //是否正在进行杰里OTA升级,方便杰里检验完或失败后重连;
@property (nonatomic, assign) Boolean isJLDfuFailed; //杰里dfu升级是否失败, 失败后将没有RW服务;
@property (nonatomic, strong) CBPeripheral *bleCurrentPeripheral;
@property (nonatomic, assign) BOOL chatGPTType;  //0 文字问答, 1 文生图

- (void)handleReconnectByMac;

typedef void(^GET_DEVICE_CALLBACK)(BOOL needForcedUpgrade);


/**
 *  获取已连接的蓝牙设备信息
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback;
/**
 *  OTA升级
 */
- (void)otaFuncWithFilePath:(NSString *)otaFilePath;


@end

NS_ASSUME_NONNULL_END
