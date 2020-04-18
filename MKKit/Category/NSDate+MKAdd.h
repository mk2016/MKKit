//
//  NSDate+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MKAdd)

/** timestamp -> NSDate */
+ (NSDate *)mk_dataWithTimestamp:(long long)timestamp;

/** current timestamp ，millisecond，length : 13  */
+ (NSTimeInterval)mk_currentTimestamp;

/** current timestamp ，second，length : 10  */
+ (NSTimeInterval)mk_currentTimestamp4Second;

/** NSDate -> millisecond */
- (NSTimeInterval)mk_dateToMillisecond;

/** NSDate -> microsecond , length : 16 */
- (NSTimeInterval)mk_dateToMicrosecond;


#pragma mark - ***** format ******
/** UTC -> NSDate */
+ (NSDate *)mk_dateWithUTC:(NSString *)utc;

/** timestamp -> yyyy-MM-dd HH:mm:ss */
+ (NSString *)mk_formatFullWithTimestamp:(long long)timestamp;

/** NSDate -> UTC */
- (NSString *)mk_dateToUTCFormat;

/** NSDate -> format */
- (NSString *)mk_dateToStringWithFormat:(NSString *)format;

/** NSDate -> yyyy-MM-dd HH:mm:ss */
- (NSString *)mk_dateToStringWithFormatFull;

/** NSDate -> yyyy-MM-dd */
- (NSString *)mk_dateToStringWithFormatDate;

/** NSDate -> NSDate 00:00:00 */
- (NSDate *)mk_dateForZeroTime;

@end


@interface NSString (MKDateAdd)
/** format string -> date */
- (NSDate *)mk_dateWithFormat:(NSString *)format;

/** full format string -> date */
- (NSDate *)mk_dateWithFormatFull;

/** utc -> yyyy-MM-dd HH:mm:ss */
- (NSString *)mk_UTCToFormatFull;

- (NSString *)mk_timestepToFormat:(NSString *)format;
    
/** utc -> format */
- (NSString *)mk_UTCToFormat:(NSString *)format;

/** second -> 0天0时0分 */
+ (NSString *)mk_dayHourMinuteWithSecond:(long long)ts;

@end
