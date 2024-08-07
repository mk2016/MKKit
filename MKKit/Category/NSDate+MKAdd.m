//
//  NSDate+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSDate+MKAdd.h"

@implementation NSDate (MKAdd)

#pragma mark - ***** timestamp ******
/** timestamp -> NSDate */
+ (NSDate *)mk_dataWithTimestamp:(long long)timestamp{
    while (timestamp > 10000000000) {
        timestamp = timestamp/1000;
    }
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

/** current timestamp ，millisecond，length : 13  */
+ (NSTimeInterval)mk_currentTimestamp{
    return [[NSDate date] mk_dateToMillisecond];
}

/** current timestamp ，second，length : 10  */
+ (NSTimeInterval)mk_currentTimestamp4Second{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return interval;
}

/** NSDate -> millisecond */
- (NSTimeInterval)mk_dateToMillisecond{
    NSTimeInterval interval = [self timeIntervalSince1970];
    return (long long)(interval*1000);
}

/** NSDate -> microsecond , length : 16 */
- (NSTimeInterval)mk_dateToMicrosecond{
    NSTimeInterval interval = [self timeIntervalSince1970];
    return interval*1000*1000;
}

- (NSTimeInterval)mk_timestamp4Second{
    NSTimeInterval interval = [self timeIntervalSince1970];
    return (long long)interval;
}


#pragma mark - ***** format ******
/** UTC -> NSDate */
+ (NSDate *)mk_dateWithUTC:(NSString *)utc{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];//2017-01-11T07:42:47.000Z
    return [dateFormatter dateFromString:utc];
}

/** timestamp -> yyyy-MM-dd HH:mm:ss */
+ (NSString *)mk_formatFullWithTimestamp:(long long)timestamp{
    NSDate *date = [NSDate mk_dataWithTimestamp:timestamp];
    return [date mk_dateToStringWithFormatFull];
}

/** NSDate -> UTC */
- (NSString *)mk_dateToUTCFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [dateFormatter stringFromDate:self];
}

/** NSDate -> format */
- (NSString *)mk_dateToStringWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

/** NSDate -> yyyy-MM-dd HH:mm:ss */
- (NSString *)mk_dateToStringWithFormatFull{
    return [self mk_dateToStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

/** NSDate -> yyyy-MM-dd */
- (NSString *)mk_dateToStringWithFormatDate{
    return [self mk_dateToStringWithFormat:@"yyyy-MM-dd"];
}

/** NSDate -> NSDate 00:00:00 */
- (NSDate *)mk_dateForZeroTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:self];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateStr = [NSString stringWithFormat:@"%@ 00:00:00", dateStr];
    return [formatter dateFromString:dateStr];
}

- (NSTimeInterval)mk_timestamp4SecondWithFormatFull:(NSString *)dateString{
    return [[dateString mk_dateWithFormatFull] mk_timestamp4Second];
}
@end

@implementation NSString (MKDateAdd)

/** format string -> date */
- (NSDate *)mk_dateWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

/** full format string -> date */
- (NSDate *)mk_dateWithFormatFull{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:self];
}

/** utc -> yyyy-MM-dd HH:mm:ss */
- (NSString *)mk_UTCToFormatFull{
    return [self mk_UTCToFormat:@"yyyy-MM-dd HH:mm:ss"];
}

/** timestep string -> Format string */
- (NSString *)mk_timestepToFormat:(NSString *)format{
    if (self) {
        NSDate *date = [NSDate mk_dataWithTimestamp:self.longLongValue];
        if (date) {
            return [date mk_dateToStringWithFormat:format];
        }
    }
    return @"";
}

/** utc -> format */
- (NSString *)mk_UTCToFormat:(NSString *)format{
    NSDate *date = [NSDate mk_dateWithUTC:self];
    return [date mk_dateToStringWithFormat:format];
}

/** second -> 0天0时0分 */
+ (NSString *)mk_dayHourMinuteWithSecond:(long long)ts{
    return [self mk_formatWithSecond:ts showSecond:NO];
}

/** second -> 0天0时0分0秒 */
+ (NSString *)mk_formatWithSecond:(long long)ts showSecond:(BOOL)showSecond{
    ts = llabs(ts);
    while (ts > 10000000000) {
        ts = ts/1000;
    }
    int day = (int)(ts/(60*60*24));
    ts = ts%(60*60*24);
    int hour = (int)(ts/3600);
    ts = ts%3600;
    int min = (int)(ts/60);
    int sec = ts%60;
    NSString *str = @"";
    if (day > 0) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d天",day]];
    }
    if (str.length > 0 || hour > 0) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d时",hour]];
    }
    if (str.length > 0 || min > 0) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d分",min]];
    }
    if (showSecond){
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d秒",sec]];
    }
    return str;
}
@end
