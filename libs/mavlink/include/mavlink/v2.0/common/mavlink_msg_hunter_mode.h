#pragma once
// MESSAGE HUNTER_MODE PACKING

#include <stdint.h>

#define MAVLINK_MSG_ID_HUNTER_MODE 42002


typedef struct __mavlink_hunter_mode_t {
 uint64_t time_usec; /*<  Timestamp (us)*/
 float roll_sp; /*<  Roll setpoint (rad)*/
 float q_cmd; /*<  rad/s)*/
 float q_meas; /*<  (rad/s)*/
 float error_horiz; /*<  */
 float error_vertic; /*<  */
 float accz_cmd; /*<  Acc Z command (m/s^2)*/
 float accz_meas; /*<  Acc Z measured (m/s^2)*/
 float accy_cmd; /*<  Acc Y command (m/s^2)*/
 float accy_meas; /*<  Acc Y measured (m/s^2)*/
 float orthogonality; /*<  Orthogonality metric*/
 float error; /*<  error*/
 float arrived; /*<  flag*/
 float relax_factor; /*<  Relax factor*/
 float counter; /*<  counter*/
 float deltax; /*<  Δx (m)*/
 float deltay; /*<  Δy (m)*/
 float deltaz; /*<  Δz (m)*/
 float v; /*<   speed (m/s)*/
 uint8_t start_flag; /*<  0/1*/
} mavlink_hunter_mode_t;

#define MAVLINK_MSG_ID_HUNTER_MODE_LEN 81
#define MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN 81
#define MAVLINK_MSG_ID_42002_LEN 81
#define MAVLINK_MSG_ID_42002_MIN_LEN 81

#define MAVLINK_MSG_ID_HUNTER_MODE_CRC 23
#define MAVLINK_MSG_ID_42002_CRC 23



#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_HUNTER_MODE { \
    42002, \
    "HUNTER_MODE", \
    20, \
    {  { "time_usec", NULL, MAVLINK_TYPE_UINT64_T, 0, 0, offsetof(mavlink_hunter_mode_t, time_usec) }, \
         { "roll_sp", NULL, MAVLINK_TYPE_FLOAT, 0, 8, offsetof(mavlink_hunter_mode_t, roll_sp) }, \
         { "q_cmd", NULL, MAVLINK_TYPE_FLOAT, 0, 12, offsetof(mavlink_hunter_mode_t, q_cmd) }, \
         { "q_meas", NULL, MAVLINK_TYPE_FLOAT, 0, 16, offsetof(mavlink_hunter_mode_t, q_meas) }, \
         { "error_horiz", NULL, MAVLINK_TYPE_FLOAT, 0, 20, offsetof(mavlink_hunter_mode_t, error_horiz) }, \
         { "error_vertic", NULL, MAVLINK_TYPE_FLOAT, 0, 24, offsetof(mavlink_hunter_mode_t, error_vertic) }, \
         { "accz_cmd", NULL, MAVLINK_TYPE_FLOAT, 0, 28, offsetof(mavlink_hunter_mode_t, accz_cmd) }, \
         { "accz_meas", NULL, MAVLINK_TYPE_FLOAT, 0, 32, offsetof(mavlink_hunter_mode_t, accz_meas) }, \
         { "accy_cmd", NULL, MAVLINK_TYPE_FLOAT, 0, 36, offsetof(mavlink_hunter_mode_t, accy_cmd) }, \
         { "accy_meas", NULL, MAVLINK_TYPE_FLOAT, 0, 40, offsetof(mavlink_hunter_mode_t, accy_meas) }, \
         { "orthogonality", NULL, MAVLINK_TYPE_FLOAT, 0, 44, offsetof(mavlink_hunter_mode_t, orthogonality) }, \
         { "error", NULL, MAVLINK_TYPE_FLOAT, 0, 48, offsetof(mavlink_hunter_mode_t, error) }, \
         { "arrived", NULL, MAVLINK_TYPE_FLOAT, 0, 52, offsetof(mavlink_hunter_mode_t, arrived) }, \
         { "relax_factor", NULL, MAVLINK_TYPE_FLOAT, 0, 56, offsetof(mavlink_hunter_mode_t, relax_factor) }, \
         { "counter", NULL, MAVLINK_TYPE_FLOAT, 0, 60, offsetof(mavlink_hunter_mode_t, counter) }, \
         { "deltax", NULL, MAVLINK_TYPE_FLOAT, 0, 64, offsetof(mavlink_hunter_mode_t, deltax) }, \
         { "deltay", NULL, MAVLINK_TYPE_FLOAT, 0, 68, offsetof(mavlink_hunter_mode_t, deltay) }, \
         { "deltaz", NULL, MAVLINK_TYPE_FLOAT, 0, 72, offsetof(mavlink_hunter_mode_t, deltaz) }, \
         { "v", NULL, MAVLINK_TYPE_FLOAT, 0, 76, offsetof(mavlink_hunter_mode_t, v) }, \
         { "start_flag", NULL, MAVLINK_TYPE_UINT8_T, 0, 80, offsetof(mavlink_hunter_mode_t, start_flag) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_HUNTER_MODE { \
    "HUNTER_MODE", \
    20, \
    {  { "time_usec", NULL, MAVLINK_TYPE_UINT64_T, 0, 0, offsetof(mavlink_hunter_mode_t, time_usec) }, \
         { "roll_sp", NULL, MAVLINK_TYPE_FLOAT, 0, 8, offsetof(mavlink_hunter_mode_t, roll_sp) }, \
         { "q_cmd", NULL, MAVLINK_TYPE_FLOAT, 0, 12, offsetof(mavlink_hunter_mode_t, q_cmd) }, \
         { "q_meas", NULL, MAVLINK_TYPE_FLOAT, 0, 16, offsetof(mavlink_hunter_mode_t, q_meas) }, \
         { "error_horiz", NULL, MAVLINK_TYPE_FLOAT, 0, 20, offsetof(mavlink_hunter_mode_t, error_horiz) }, \
         { "error_vertic", NULL, MAVLINK_TYPE_FLOAT, 0, 24, offsetof(mavlink_hunter_mode_t, error_vertic) }, \
         { "accz_cmd", NULL, MAVLINK_TYPE_FLOAT, 0, 28, offsetof(mavlink_hunter_mode_t, accz_cmd) }, \
         { "accz_meas", NULL, MAVLINK_TYPE_FLOAT, 0, 32, offsetof(mavlink_hunter_mode_t, accz_meas) }, \
         { "accy_cmd", NULL, MAVLINK_TYPE_FLOAT, 0, 36, offsetof(mavlink_hunter_mode_t, accy_cmd) }, \
         { "accy_meas", NULL, MAVLINK_TYPE_FLOAT, 0, 40, offsetof(mavlink_hunter_mode_t, accy_meas) }, \
         { "orthogonality", NULL, MAVLINK_TYPE_FLOAT, 0, 44, offsetof(mavlink_hunter_mode_t, orthogonality) }, \
         { "error", NULL, MAVLINK_TYPE_FLOAT, 0, 48, offsetof(mavlink_hunter_mode_t, error) }, \
         { "arrived", NULL, MAVLINK_TYPE_FLOAT, 0, 52, offsetof(mavlink_hunter_mode_t, arrived) }, \
         { "relax_factor", NULL, MAVLINK_TYPE_FLOAT, 0, 56, offsetof(mavlink_hunter_mode_t, relax_factor) }, \
         { "counter", NULL, MAVLINK_TYPE_FLOAT, 0, 60, offsetof(mavlink_hunter_mode_t, counter) }, \
         { "deltax", NULL, MAVLINK_TYPE_FLOAT, 0, 64, offsetof(mavlink_hunter_mode_t, deltax) }, \
         { "deltay", NULL, MAVLINK_TYPE_FLOAT, 0, 68, offsetof(mavlink_hunter_mode_t, deltay) }, \
         { "deltaz", NULL, MAVLINK_TYPE_FLOAT, 0, 72, offsetof(mavlink_hunter_mode_t, deltaz) }, \
         { "v", NULL, MAVLINK_TYPE_FLOAT, 0, 76, offsetof(mavlink_hunter_mode_t, v) }, \
         { "start_flag", NULL, MAVLINK_TYPE_UINT8_T, 0, 80, offsetof(mavlink_hunter_mode_t, start_flag) }, \
         } \
}
#endif

/**
 * @brief Pack a hunter_mode message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param time_usec  Timestamp (us)
 * @param roll_sp  Roll setpoint (rad)
 * @param q_cmd  rad/s)
 * @param q_meas  (rad/s)
 * @param error_horiz  
 * @param error_vertic  
 * @param accz_cmd  Acc Z command (m/s^2)
 * @param accz_meas  Acc Z measured (m/s^2)
 * @param accy_cmd  Acc Y command (m/s^2)
 * @param accy_meas  Acc Y measured (m/s^2)
 * @param orthogonality  Orthogonality metric
 * @param error  error
 * @param arrived  flag
 * @param relax_factor  Relax factor
 * @param counter  counter
 * @param deltax  Δx (m)
 * @param deltay  Δy (m)
 * @param deltaz  Δz (m)
 * @param v   speed (m/s)
 * @param start_flag  0/1
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hunter_mode_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               uint64_t time_usec, float roll_sp, float q_cmd, float q_meas, float error_horiz, float error_vertic, float accz_cmd, float accz_meas, float accy_cmd, float accy_meas, float orthogonality, float error, float arrived, float relax_factor, float counter, float deltax, float deltay, float deltaz, float v, uint8_t start_flag)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_HUNTER_MODE_LEN];
    _mav_put_uint64_t(buf, 0, time_usec);
    _mav_put_float(buf, 8, roll_sp);
    _mav_put_float(buf, 12, q_cmd);
    _mav_put_float(buf, 16, q_meas);
    _mav_put_float(buf, 20, error_horiz);
    _mav_put_float(buf, 24, error_vertic);
    _mav_put_float(buf, 28, accz_cmd);
    _mav_put_float(buf, 32, accz_meas);
    _mav_put_float(buf, 36, accy_cmd);
    _mav_put_float(buf, 40, accy_meas);
    _mav_put_float(buf, 44, orthogonality);
    _mav_put_float(buf, 48, error);
    _mav_put_float(buf, 52, arrived);
    _mav_put_float(buf, 56, relax_factor);
    _mav_put_float(buf, 60, counter);
    _mav_put_float(buf, 64, deltax);
    _mav_put_float(buf, 68, deltay);
    _mav_put_float(buf, 72, deltaz);
    _mav_put_float(buf, 76, v);
    _mav_put_uint8_t(buf, 80, start_flag);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#else
    mavlink_hunter_mode_t packet;
    packet.time_usec = time_usec;
    packet.roll_sp = roll_sp;
    packet.q_cmd = q_cmd;
    packet.q_meas = q_meas;
    packet.error_horiz = error_horiz;
    packet.error_vertic = error_vertic;
    packet.accz_cmd = accz_cmd;
    packet.accz_meas = accz_meas;
    packet.accy_cmd = accy_cmd;
    packet.accy_meas = accy_meas;
    packet.orthogonality = orthogonality;
    packet.error = error;
    packet.arrived = arrived;
    packet.relax_factor = relax_factor;
    packet.counter = counter;
    packet.deltax = deltax;
    packet.deltay = deltay;
    packet.deltaz = deltaz;
    packet.v = v;
    packet.start_flag = start_flag;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_HUNTER_MODE;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
}

/**
 * @brief Pack a hunter_mode message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param status MAVLink status structure
 * @param msg The MAVLink message to compress the data into
 *
 * @param time_usec  Timestamp (us)
 * @param roll_sp  Roll setpoint (rad)
 * @param q_cmd  rad/s)
 * @param q_meas  (rad/s)
 * @param error_horiz  
 * @param error_vertic  
 * @param accz_cmd  Acc Z command (m/s^2)
 * @param accz_meas  Acc Z measured (m/s^2)
 * @param accy_cmd  Acc Y command (m/s^2)
 * @param accy_meas  Acc Y measured (m/s^2)
 * @param orthogonality  Orthogonality metric
 * @param error  error
 * @param arrived  flag
 * @param relax_factor  Relax factor
 * @param counter  counter
 * @param deltax  Δx (m)
 * @param deltay  Δy (m)
 * @param deltaz  Δz (m)
 * @param v   speed (m/s)
 * @param start_flag  0/1
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hunter_mode_pack_status(uint8_t system_id, uint8_t component_id, mavlink_status_t *_status, mavlink_message_t* msg,
                               uint64_t time_usec, float roll_sp, float q_cmd, float q_meas, float error_horiz, float error_vertic, float accz_cmd, float accz_meas, float accy_cmd, float accy_meas, float orthogonality, float error, float arrived, float relax_factor, float counter, float deltax, float deltay, float deltaz, float v, uint8_t start_flag)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_HUNTER_MODE_LEN];
    _mav_put_uint64_t(buf, 0, time_usec);
    _mav_put_float(buf, 8, roll_sp);
    _mav_put_float(buf, 12, q_cmd);
    _mav_put_float(buf, 16, q_meas);
    _mav_put_float(buf, 20, error_horiz);
    _mav_put_float(buf, 24, error_vertic);
    _mav_put_float(buf, 28, accz_cmd);
    _mav_put_float(buf, 32, accz_meas);
    _mav_put_float(buf, 36, accy_cmd);
    _mav_put_float(buf, 40, accy_meas);
    _mav_put_float(buf, 44, orthogonality);
    _mav_put_float(buf, 48, error);
    _mav_put_float(buf, 52, arrived);
    _mav_put_float(buf, 56, relax_factor);
    _mav_put_float(buf, 60, counter);
    _mav_put_float(buf, 64, deltax);
    _mav_put_float(buf, 68, deltay);
    _mav_put_float(buf, 72, deltaz);
    _mav_put_float(buf, 76, v);
    _mav_put_uint8_t(buf, 80, start_flag);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#else
    mavlink_hunter_mode_t packet;
    packet.time_usec = time_usec;
    packet.roll_sp = roll_sp;
    packet.q_cmd = q_cmd;
    packet.q_meas = q_meas;
    packet.error_horiz = error_horiz;
    packet.error_vertic = error_vertic;
    packet.accz_cmd = accz_cmd;
    packet.accz_meas = accz_meas;
    packet.accy_cmd = accy_cmd;
    packet.accy_meas = accy_meas;
    packet.orthogonality = orthogonality;
    packet.error = error;
    packet.arrived = arrived;
    packet.relax_factor = relax_factor;
    packet.counter = counter;
    packet.deltax = deltax;
    packet.deltay = deltay;
    packet.deltaz = deltaz;
    packet.v = v;
    packet.start_flag = start_flag;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_HUNTER_MODE;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_buffer(msg, system_id, component_id, _status, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
#else
    return mavlink_finalize_message_buffer(msg, system_id, component_id, _status, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#endif
}

/**
 * @brief Pack a hunter_mode message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param time_usec  Timestamp (us)
 * @param roll_sp  Roll setpoint (rad)
 * @param q_cmd  rad/s)
 * @param q_meas  (rad/s)
 * @param error_horiz  
 * @param error_vertic  
 * @param accz_cmd  Acc Z command (m/s^2)
 * @param accz_meas  Acc Z measured (m/s^2)
 * @param accy_cmd  Acc Y command (m/s^2)
 * @param accy_meas  Acc Y measured (m/s^2)
 * @param orthogonality  Orthogonality metric
 * @param error  error
 * @param arrived  flag
 * @param relax_factor  Relax factor
 * @param counter  counter
 * @param deltax  Δx (m)
 * @param deltay  Δy (m)
 * @param deltaz  Δz (m)
 * @param v   speed (m/s)
 * @param start_flag  0/1
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hunter_mode_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   uint64_t time_usec,float roll_sp,float q_cmd,float q_meas,float error_horiz,float error_vertic,float accz_cmd,float accz_meas,float accy_cmd,float accy_meas,float orthogonality,float error,float arrived,float relax_factor,float counter,float deltax,float deltay,float deltaz,float v,uint8_t start_flag)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_HUNTER_MODE_LEN];
    _mav_put_uint64_t(buf, 0, time_usec);
    _mav_put_float(buf, 8, roll_sp);
    _mav_put_float(buf, 12, q_cmd);
    _mav_put_float(buf, 16, q_meas);
    _mav_put_float(buf, 20, error_horiz);
    _mav_put_float(buf, 24, error_vertic);
    _mav_put_float(buf, 28, accz_cmd);
    _mav_put_float(buf, 32, accz_meas);
    _mav_put_float(buf, 36, accy_cmd);
    _mav_put_float(buf, 40, accy_meas);
    _mav_put_float(buf, 44, orthogonality);
    _mav_put_float(buf, 48, error);
    _mav_put_float(buf, 52, arrived);
    _mav_put_float(buf, 56, relax_factor);
    _mav_put_float(buf, 60, counter);
    _mav_put_float(buf, 64, deltax);
    _mav_put_float(buf, 68, deltay);
    _mav_put_float(buf, 72, deltaz);
    _mav_put_float(buf, 76, v);
    _mav_put_uint8_t(buf, 80, start_flag);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#else
    mavlink_hunter_mode_t packet;
    packet.time_usec = time_usec;
    packet.roll_sp = roll_sp;
    packet.q_cmd = q_cmd;
    packet.q_meas = q_meas;
    packet.error_horiz = error_horiz;
    packet.error_vertic = error_vertic;
    packet.accz_cmd = accz_cmd;
    packet.accz_meas = accz_meas;
    packet.accy_cmd = accy_cmd;
    packet.accy_meas = accy_meas;
    packet.orthogonality = orthogonality;
    packet.error = error;
    packet.arrived = arrived;
    packet.relax_factor = relax_factor;
    packet.counter = counter;
    packet.deltax = deltax;
    packet.deltay = deltay;
    packet.deltaz = deltaz;
    packet.v = v;
    packet.start_flag = start_flag;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_HUNTER_MODE;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
}

/**
 * @brief Encode a hunter_mode struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param hunter_mode C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hunter_mode_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_hunter_mode_t* hunter_mode)
{
    return mavlink_msg_hunter_mode_pack(system_id, component_id, msg, hunter_mode->time_usec, hunter_mode->roll_sp, hunter_mode->q_cmd, hunter_mode->q_meas, hunter_mode->error_horiz, hunter_mode->error_vertic, hunter_mode->accz_cmd, hunter_mode->accz_meas, hunter_mode->accy_cmd, hunter_mode->accy_meas, hunter_mode->orthogonality, hunter_mode->error, hunter_mode->arrived, hunter_mode->relax_factor, hunter_mode->counter, hunter_mode->deltax, hunter_mode->deltay, hunter_mode->deltaz, hunter_mode->v, hunter_mode->start_flag);
}

/**
 * @brief Encode a hunter_mode struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param hunter_mode C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hunter_mode_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_hunter_mode_t* hunter_mode)
{
    return mavlink_msg_hunter_mode_pack_chan(system_id, component_id, chan, msg, hunter_mode->time_usec, hunter_mode->roll_sp, hunter_mode->q_cmd, hunter_mode->q_meas, hunter_mode->error_horiz, hunter_mode->error_vertic, hunter_mode->accz_cmd, hunter_mode->accz_meas, hunter_mode->accy_cmd, hunter_mode->accy_meas, hunter_mode->orthogonality, hunter_mode->error, hunter_mode->arrived, hunter_mode->relax_factor, hunter_mode->counter, hunter_mode->deltax, hunter_mode->deltay, hunter_mode->deltaz, hunter_mode->v, hunter_mode->start_flag);
}

/**
 * @brief Encode a hunter_mode struct with provided status structure
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param status MAVLink status structure
 * @param msg The MAVLink message to compress the data into
 * @param hunter_mode C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hunter_mode_encode_status(uint8_t system_id, uint8_t component_id, mavlink_status_t* _status, mavlink_message_t* msg, const mavlink_hunter_mode_t* hunter_mode)
{
    return mavlink_msg_hunter_mode_pack_status(system_id, component_id, _status, msg,  hunter_mode->time_usec, hunter_mode->roll_sp, hunter_mode->q_cmd, hunter_mode->q_meas, hunter_mode->error_horiz, hunter_mode->error_vertic, hunter_mode->accz_cmd, hunter_mode->accz_meas, hunter_mode->accy_cmd, hunter_mode->accy_meas, hunter_mode->orthogonality, hunter_mode->error, hunter_mode->arrived, hunter_mode->relax_factor, hunter_mode->counter, hunter_mode->deltax, hunter_mode->deltay, hunter_mode->deltaz, hunter_mode->v, hunter_mode->start_flag);
}

/**
 * @brief Send a hunter_mode message
 * @param chan MAVLink channel to send the message
 *
 * @param time_usec  Timestamp (us)
 * @param roll_sp  Roll setpoint (rad)
 * @param q_cmd  rad/s)
 * @param q_meas  (rad/s)
 * @param error_horiz  
 * @param error_vertic  
 * @param accz_cmd  Acc Z command (m/s^2)
 * @param accz_meas  Acc Z measured (m/s^2)
 * @param accy_cmd  Acc Y command (m/s^2)
 * @param accy_meas  Acc Y measured (m/s^2)
 * @param orthogonality  Orthogonality metric
 * @param error  error
 * @param arrived  flag
 * @param relax_factor  Relax factor
 * @param counter  counter
 * @param deltax  Δx (m)
 * @param deltay  Δy (m)
 * @param deltaz  Δz (m)
 * @param v   speed (m/s)
 * @param start_flag  0/1
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_hunter_mode_send(mavlink_channel_t chan, uint64_t time_usec, float roll_sp, float q_cmd, float q_meas, float error_horiz, float error_vertic, float accz_cmd, float accz_meas, float accy_cmd, float accy_meas, float orthogonality, float error, float arrived, float relax_factor, float counter, float deltax, float deltay, float deltaz, float v, uint8_t start_flag)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_HUNTER_MODE_LEN];
    _mav_put_uint64_t(buf, 0, time_usec);
    _mav_put_float(buf, 8, roll_sp);
    _mav_put_float(buf, 12, q_cmd);
    _mav_put_float(buf, 16, q_meas);
    _mav_put_float(buf, 20, error_horiz);
    _mav_put_float(buf, 24, error_vertic);
    _mav_put_float(buf, 28, accz_cmd);
    _mav_put_float(buf, 32, accz_meas);
    _mav_put_float(buf, 36, accy_cmd);
    _mav_put_float(buf, 40, accy_meas);
    _mav_put_float(buf, 44, orthogonality);
    _mav_put_float(buf, 48, error);
    _mav_put_float(buf, 52, arrived);
    _mav_put_float(buf, 56, relax_factor);
    _mav_put_float(buf, 60, counter);
    _mav_put_float(buf, 64, deltax);
    _mav_put_float(buf, 68, deltay);
    _mav_put_float(buf, 72, deltaz);
    _mav_put_float(buf, 76, v);
    _mav_put_uint8_t(buf, 80, start_flag);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUNTER_MODE, buf, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
#else
    mavlink_hunter_mode_t packet;
    packet.time_usec = time_usec;
    packet.roll_sp = roll_sp;
    packet.q_cmd = q_cmd;
    packet.q_meas = q_meas;
    packet.error_horiz = error_horiz;
    packet.error_vertic = error_vertic;
    packet.accz_cmd = accz_cmd;
    packet.accz_meas = accz_meas;
    packet.accy_cmd = accy_cmd;
    packet.accy_meas = accy_meas;
    packet.orthogonality = orthogonality;
    packet.error = error;
    packet.arrived = arrived;
    packet.relax_factor = relax_factor;
    packet.counter = counter;
    packet.deltax = deltax;
    packet.deltay = deltay;
    packet.deltaz = deltaz;
    packet.v = v;
    packet.start_flag = start_flag;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUNTER_MODE, (const char *)&packet, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
#endif
}

/**
 * @brief Send a hunter_mode message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_hunter_mode_send_struct(mavlink_channel_t chan, const mavlink_hunter_mode_t* hunter_mode)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_hunter_mode_send(chan, hunter_mode->time_usec, hunter_mode->roll_sp, hunter_mode->q_cmd, hunter_mode->q_meas, hunter_mode->error_horiz, hunter_mode->error_vertic, hunter_mode->accz_cmd, hunter_mode->accz_meas, hunter_mode->accy_cmd, hunter_mode->accy_meas, hunter_mode->orthogonality, hunter_mode->error, hunter_mode->arrived, hunter_mode->relax_factor, hunter_mode->counter, hunter_mode->deltax, hunter_mode->deltay, hunter_mode->deltaz, hunter_mode->v, hunter_mode->start_flag);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUNTER_MODE, (const char *)hunter_mode, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
#endif
}

#if MAVLINK_MSG_ID_HUNTER_MODE_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This variant of _send() can be used to save stack space by reusing
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_hunter_mode_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint64_t time_usec, float roll_sp, float q_cmd, float q_meas, float error_horiz, float error_vertic, float accz_cmd, float accz_meas, float accy_cmd, float accy_meas, float orthogonality, float error, float arrived, float relax_factor, float counter, float deltax, float deltay, float deltaz, float v, uint8_t start_flag)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;
    _mav_put_uint64_t(buf, 0, time_usec);
    _mav_put_float(buf, 8, roll_sp);
    _mav_put_float(buf, 12, q_cmd);
    _mav_put_float(buf, 16, q_meas);
    _mav_put_float(buf, 20, error_horiz);
    _mav_put_float(buf, 24, error_vertic);
    _mav_put_float(buf, 28, accz_cmd);
    _mav_put_float(buf, 32, accz_meas);
    _mav_put_float(buf, 36, accy_cmd);
    _mav_put_float(buf, 40, accy_meas);
    _mav_put_float(buf, 44, orthogonality);
    _mav_put_float(buf, 48, error);
    _mav_put_float(buf, 52, arrived);
    _mav_put_float(buf, 56, relax_factor);
    _mav_put_float(buf, 60, counter);
    _mav_put_float(buf, 64, deltax);
    _mav_put_float(buf, 68, deltay);
    _mav_put_float(buf, 72, deltaz);
    _mav_put_float(buf, 76, v);
    _mav_put_uint8_t(buf, 80, start_flag);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUNTER_MODE, buf, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
#else
    mavlink_hunter_mode_t *packet = (mavlink_hunter_mode_t *)msgbuf;
    packet->time_usec = time_usec;
    packet->roll_sp = roll_sp;
    packet->q_cmd = q_cmd;
    packet->q_meas = q_meas;
    packet->error_horiz = error_horiz;
    packet->error_vertic = error_vertic;
    packet->accz_cmd = accz_cmd;
    packet->accz_meas = accz_meas;
    packet->accy_cmd = accy_cmd;
    packet->accy_meas = accy_meas;
    packet->orthogonality = orthogonality;
    packet->error = error;
    packet->arrived = arrived;
    packet->relax_factor = relax_factor;
    packet->counter = counter;
    packet->deltax = deltax;
    packet->deltay = deltay;
    packet->deltaz = deltaz;
    packet->v = v;
    packet->start_flag = start_flag;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUNTER_MODE, (const char *)packet, MAVLINK_MSG_ID_HUNTER_MODE_MIN_LEN, MAVLINK_MSG_ID_HUNTER_MODE_LEN, MAVLINK_MSG_ID_HUNTER_MODE_CRC);
#endif
}
#endif

#endif

// MESSAGE HUNTER_MODE UNPACKING


/**
 * @brief Get field time_usec from hunter_mode message
 *
 * @return  Timestamp (us)
 */
static inline uint64_t mavlink_msg_hunter_mode_get_time_usec(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint64_t(msg,  0);
}

/**
 * @brief Get field roll_sp from hunter_mode message
 *
 * @return  Roll setpoint (rad)
 */
static inline float mavlink_msg_hunter_mode_get_roll_sp(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  8);
}

/**
 * @brief Get field q_cmd from hunter_mode message
 *
 * @return  rad/s)
 */
static inline float mavlink_msg_hunter_mode_get_q_cmd(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  12);
}

/**
 * @brief Get field q_meas from hunter_mode message
 *
 * @return  (rad/s)
 */
static inline float mavlink_msg_hunter_mode_get_q_meas(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  16);
}

/**
 * @brief Get field error_horiz from hunter_mode message
 *
 * @return  
 */
static inline float mavlink_msg_hunter_mode_get_error_horiz(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  20);
}

/**
 * @brief Get field error_vertic from hunter_mode message
 *
 * @return  
 */
static inline float mavlink_msg_hunter_mode_get_error_vertic(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  24);
}

/**
 * @brief Get field accz_cmd from hunter_mode message
 *
 * @return  Acc Z command (m/s^2)
 */
static inline float mavlink_msg_hunter_mode_get_accz_cmd(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  28);
}

/**
 * @brief Get field accz_meas from hunter_mode message
 *
 * @return  Acc Z measured (m/s^2)
 */
static inline float mavlink_msg_hunter_mode_get_accz_meas(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  32);
}

/**
 * @brief Get field accy_cmd from hunter_mode message
 *
 * @return  Acc Y command (m/s^2)
 */
static inline float mavlink_msg_hunter_mode_get_accy_cmd(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  36);
}

/**
 * @brief Get field accy_meas from hunter_mode message
 *
 * @return  Acc Y measured (m/s^2)
 */
static inline float mavlink_msg_hunter_mode_get_accy_meas(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  40);
}

/**
 * @brief Get field orthogonality from hunter_mode message
 *
 * @return  Orthogonality metric
 */
static inline float mavlink_msg_hunter_mode_get_orthogonality(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  44);
}

/**
 * @brief Get field error from hunter_mode message
 *
 * @return  error
 */
static inline float mavlink_msg_hunter_mode_get_error(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  48);
}

/**
 * @brief Get field arrived from hunter_mode message
 *
 * @return  flag
 */
static inline float mavlink_msg_hunter_mode_get_arrived(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  52);
}

/**
 * @brief Get field relax_factor from hunter_mode message
 *
 * @return  Relax factor
 */
static inline float mavlink_msg_hunter_mode_get_relax_factor(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  56);
}

/**
 * @brief Get field counter from hunter_mode message
 *
 * @return  counter
 */
static inline float mavlink_msg_hunter_mode_get_counter(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  60);
}

/**
 * @brief Get field deltax from hunter_mode message
 *
 * @return  Δx (m)
 */
static inline float mavlink_msg_hunter_mode_get_deltax(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  64);
}

/**
 * @brief Get field deltay from hunter_mode message
 *
 * @return  Δy (m)
 */
static inline float mavlink_msg_hunter_mode_get_deltay(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  68);
}

/**
 * @brief Get field deltaz from hunter_mode message
 *
 * @return  Δz (m)
 */
static inline float mavlink_msg_hunter_mode_get_deltaz(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  72);
}

/**
 * @brief Get field v from hunter_mode message
 *
 * @return   speed (m/s)
 */
static inline float mavlink_msg_hunter_mode_get_v(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  76);
}

/**
 * @brief Get field start_flag from hunter_mode message
 *
 * @return  0/1
 */
static inline uint8_t mavlink_msg_hunter_mode_get_start_flag(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  80);
}

/**
 * @brief Decode a hunter_mode message into a struct
 *
 * @param msg The message to decode
 * @param hunter_mode C-struct to decode the message contents into
 */
static inline void mavlink_msg_hunter_mode_decode(const mavlink_message_t* msg, mavlink_hunter_mode_t* hunter_mode)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    hunter_mode->time_usec = mavlink_msg_hunter_mode_get_time_usec(msg);
    hunter_mode->roll_sp = mavlink_msg_hunter_mode_get_roll_sp(msg);
    hunter_mode->q_cmd = mavlink_msg_hunter_mode_get_q_cmd(msg);
    hunter_mode->q_meas = mavlink_msg_hunter_mode_get_q_meas(msg);
    hunter_mode->error_horiz = mavlink_msg_hunter_mode_get_error_horiz(msg);
    hunter_mode->error_vertic = mavlink_msg_hunter_mode_get_error_vertic(msg);
    hunter_mode->accz_cmd = mavlink_msg_hunter_mode_get_accz_cmd(msg);
    hunter_mode->accz_meas = mavlink_msg_hunter_mode_get_accz_meas(msg);
    hunter_mode->accy_cmd = mavlink_msg_hunter_mode_get_accy_cmd(msg);
    hunter_mode->accy_meas = mavlink_msg_hunter_mode_get_accy_meas(msg);
    hunter_mode->orthogonality = mavlink_msg_hunter_mode_get_orthogonality(msg);
    hunter_mode->error = mavlink_msg_hunter_mode_get_error(msg);
    hunter_mode->arrived = mavlink_msg_hunter_mode_get_arrived(msg);
    hunter_mode->relax_factor = mavlink_msg_hunter_mode_get_relax_factor(msg);
    hunter_mode->counter = mavlink_msg_hunter_mode_get_counter(msg);
    hunter_mode->deltax = mavlink_msg_hunter_mode_get_deltax(msg);
    hunter_mode->deltay = mavlink_msg_hunter_mode_get_deltay(msg);
    hunter_mode->deltaz = mavlink_msg_hunter_mode_get_deltaz(msg);
    hunter_mode->v = mavlink_msg_hunter_mode_get_v(msg);
    hunter_mode->start_flag = mavlink_msg_hunter_mode_get_start_flag(msg);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_HUNTER_MODE_LEN? msg->len : MAVLINK_MSG_ID_HUNTER_MODE_LEN;
        memset(hunter_mode, 0, MAVLINK_MSG_ID_HUNTER_MODE_LEN);
    memcpy(hunter_mode, _MAV_PAYLOAD(msg), len);
#endif
}
