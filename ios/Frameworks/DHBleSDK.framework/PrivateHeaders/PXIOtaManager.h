//
//  PXIOtaManager.h
//  DHSFit
//
//  Created by DHS on 2025/3/1.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PXIBleFileSyncingCallbackBlock)(int code, CGFloat progress, id data);

@interface PXIOtaManager : NSObject

@property (nonatomic, strong, nullable) CBPeripheral *pxiPeripheral;
@property (nonatomic, strong, nullable) CBCharacteristic *pxiOTACharacteristic;

/// 单例
+ (__kindof PXIOtaManager *)shareInstance;

@property (nonatomic, copy, nullable) PXIBleFileSyncingCallbackBlock fileSyncingBlock;

- (void)startPXIUIFileSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block;

- (void)ble_receive_data:(NSData *)receiveData;

@end

NS_ASSUME_NONNULL_END
