#pragma once
// MESSAGE EMSAD_SENSOR_DATA_TX PACKING

#include <stdint.h>

#define MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX 2314


typedef struct __mavlink_emsad_sensor_data_tx_t {
 uint32_t time_sinceBoot; /*< [ms] Timestamp (time since system boot).*/
 float capacitor_volt; /*< [V] Capacitor voltage.*/
 float acc_reading; /*<  Acceleration measurement.*/
 float reserved1; /*<  Reserved.*/
 float pressure_reading; /*<  Barometric pressure.*/
 float pressure_Diff; /*<  Differential pressure.*/
 uint8_t status_flags; /*<  EMSAD status flags.*/
 uint8_t fsm_State; /*<  EMSAD finite-state-machine state.*/
} mavlink_emsad_sensor_data_tx_t;

#define MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN 26
#define MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN 26
#define MAVLINK_MSG_ID_2314_LEN 26
#define MAVLINK_MSG_ID_2314_MIN_LEN 26

#define MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC 141
#define MAVLINK_MSG_ID_2314_CRC 141



#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_EMSAD_SENSOR_DATA_TX { \
    2314, \
    "EMSAD_SENSOR_DATA_TX", \
    8, \
    {  { "time_sinceBoot", NULL, MAVLINK_TYPE_UINT32_T, 0, 0, offsetof(mavlink_emsad_sensor_data_tx_t, time_sinceBoot) }, \
         { "capacitor_volt", NULL, MAVLINK_TYPE_FLOAT, 0, 4, offsetof(mavlink_emsad_sensor_data_tx_t, capacitor_volt) }, \
         { "acc_reading", NULL, MAVLINK_TYPE_FLOAT, 0, 8, offsetof(mavlink_emsad_sensor_data_tx_t, acc_reading) }, \
         { "reserved1", NULL, MAVLINK_TYPE_FLOAT, 0, 12, offsetof(mavlink_emsad_sensor_data_tx_t, reserved1) }, \
         { "pressure_reading", NULL, MAVLINK_TYPE_FLOAT, 0, 16, offsetof(mavlink_emsad_sensor_data_tx_t, pressure_reading) }, \
         { "pressure_Diff", NULL, MAVLINK_TYPE_FLOAT, 0, 20, offsetof(mavlink_emsad_sensor_data_tx_t, pressure_Diff) }, \
         { "status_flags", NULL, MAVLINK_TYPE_UINT8_T, 0, 24, offsetof(mavlink_emsad_sensor_data_tx_t, status_flags) }, \
         { "fsm_State", NULL, MAVLINK_TYPE_UINT8_T, 0, 25, offsetof(mavlink_emsad_sensor_data_tx_t, fsm_State) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_EMSAD_SENSOR_DATA_TX { \
    "EMSAD_SENSOR_DATA_TX", \
    8, \
    {  { "time_sinceBoot", NULL, MAVLINK_TYPE_UINT32_T, 0, 0, offsetof(mavlink_emsad_sensor_data_tx_t, time_sinceBoot) }, \
         { "capacitor_volt", NULL, MAVLINK_TYPE_FLOAT, 0, 4, offsetof(mavlink_emsad_sensor_data_tx_t, capacitor_volt) }, \
         { "acc_reading", NULL, MAVLINK_TYPE_FLOAT, 0, 8, offsetof(mavlink_emsad_sensor_data_tx_t, acc_reading) }, \
         { "reserved1", NULL, MAVLINK_TYPE_FLOAT, 0, 12, offsetof(mavlink_emsad_sensor_data_tx_t, reserved1) }, \
         { "pressure_reading", NULL, MAVLINK_TYPE_FLOAT, 0, 16, offsetof(mavlink_emsad_sensor_data_tx_t, pressure_reading) }, \
         { "pressure_Diff", NULL, MAVLINK_TYPE_FLOAT, 0, 20, offsetof(mavlink_emsad_sensor_data_tx_t, pressure_Diff) }, \
         { "status_flags", NULL, MAVLINK_TYPE_UINT8_T, 0, 24, offsetof(mavlink_emsad_sensor_data_tx_t, status_flags) }, \
         { "fsm_State", NULL, MAVLINK_TYPE_UINT8_T, 0, 25, offsetof(mavlink_emsad_sensor_data_tx_t, fsm_State) }, \
         } \
}
#endif

/**
 * @brief Pack a emsad_sensor_data_tx message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param time_sinceBoot [ms] Timestamp (time since system boot).
 * @param capacitor_volt [V] Capacitor voltage.
 * @param acc_reading  Acceleration measurement.
 * @param reserved1  Reserved.
 * @param pressure_reading  Barometric pressure.
 * @param pressure_Diff  Differential pressure.
 * @param status_flags  EMSAD status flags.
 * @param fsm_State  EMSAD finite-state-machine state.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_emsad_sensor_data_tx_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               uint32_t time_sinceBoot, float capacitor_volt, float acc_reading, float reserved1, float pressure_reading, float pressure_Diff, uint8_t status_flags, uint8_t fsm_State)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN];
    _mav_put_uint32_t(buf, 0, time_sinceBoot);
    _mav_put_float(buf, 4, capacitor_volt);
    _mav_put_float(buf, 8, acc_reading);
    _mav_put_float(buf, 12, reserved1);
    _mav_put_float(buf, 16, pressure_reading);
    _mav_put_float(buf, 20, pressure_Diff);
    _mav_put_uint8_t(buf, 24, status_flags);
    _mav_put_uint8_t(buf, 25, fsm_State);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#else
    mavlink_emsad_sensor_data_tx_t packet;
    packet.time_sinceBoot = time_sinceBoot;
    packet.capacitor_volt = capacitor_volt;
    packet.acc_reading = acc_reading;
    packet.reserved1 = reserved1;
    packet.pressure_reading = pressure_reading;
    packet.pressure_Diff = pressure_Diff;
    packet.status_flags = status_flags;
    packet.fsm_State = fsm_State;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
}

/**
 * @brief Pack a emsad_sensor_data_tx message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param status MAVLink status structure
 * @param msg The MAVLink message to compress the data into
 *
 * @param time_sinceBoot [ms] Timestamp (time since system boot).
 * @param capacitor_volt [V] Capacitor voltage.
 * @param acc_reading  Acceleration measurement.
 * @param reserved1  Reserved.
 * @param pressure_reading  Barometric pressure.
 * @param pressure_Diff  Differential pressure.
 * @param status_flags  EMSAD status flags.
 * @param fsm_State  EMSAD finite-state-machine state.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_emsad_sensor_data_tx_pack_status(uint8_t system_id, uint8_t component_id, mavlink_status_t *_status, mavlink_message_t* msg,
                               uint32_t time_sinceBoot, float capacitor_volt, float acc_reading, float reserved1, float pressure_reading, float pressure_Diff, uint8_t status_flags, uint8_t fsm_State)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN];
    _mav_put_uint32_t(buf, 0, time_sinceBoot);
    _mav_put_float(buf, 4, capacitor_volt);
    _mav_put_float(buf, 8, acc_reading);
    _mav_put_float(buf, 12, reserved1);
    _mav_put_float(buf, 16, pressure_reading);
    _mav_put_float(buf, 20, pressure_Diff);
    _mav_put_uint8_t(buf, 24, status_flags);
    _mav_put_uint8_t(buf, 25, fsm_State);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#else
    mavlink_emsad_sensor_data_tx_t packet;
    packet.time_sinceBoot = time_sinceBoot;
    packet.capacitor_volt = capacitor_volt;
    packet.acc_reading = acc_reading;
    packet.reserved1 = reserved1;
    packet.pressure_reading = pressure_reading;
    packet.pressure_Diff = pressure_Diff;
    packet.status_flags = status_flags;
    packet.fsm_State = fsm_State;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_buffer(msg, system_id, component_id, _status, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
#else
    return mavlink_finalize_message_buffer(msg, system_id, component_id, _status, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#endif
}

/**
 * @brief Pack a emsad_sensor_data_tx message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param time_sinceBoot [ms] Timestamp (time since system boot).
 * @param capacitor_volt [V] Capacitor voltage.
 * @param acc_reading  Acceleration measurement.
 * @param reserved1  Reserved.
 * @param pressure_reading  Barometric pressure.
 * @param pressure_Diff  Differential pressure.
 * @param status_flags  EMSAD status flags.
 * @param fsm_State  EMSAD finite-state-machine state.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_emsad_sensor_data_tx_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   uint32_t time_sinceBoot,float capacitor_volt,float acc_reading,float reserved1,float pressure_reading,float pressure_Diff,uint8_t status_flags,uint8_t fsm_State)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN];
    _mav_put_uint32_t(buf, 0, time_sinceBoot);
    _mav_put_float(buf, 4, capacitor_volt);
    _mav_put_float(buf, 8, acc_reading);
    _mav_put_float(buf, 12, reserved1);
    _mav_put_float(buf, 16, pressure_reading);
    _mav_put_float(buf, 20, pressure_Diff);
    _mav_put_uint8_t(buf, 24, status_flags);
    _mav_put_uint8_t(buf, 25, fsm_State);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#else
    mavlink_emsad_sensor_data_tx_t packet;
    packet.time_sinceBoot = time_sinceBoot;
    packet.capacitor_volt = capacitor_volt;
    packet.acc_reading = acc_reading;
    packet.reserved1 = reserved1;
    packet.pressure_reading = pressure_reading;
    packet.pressure_Diff = pressure_Diff;
    packet.status_flags = status_flags;
    packet.fsm_State = fsm_State;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
}

/**
 * @brief Encode a emsad_sensor_data_tx struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param emsad_sensor_data_tx C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_emsad_sensor_data_tx_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_emsad_sensor_data_tx_t* emsad_sensor_data_tx)
{
    return mavlink_msg_emsad_sensor_data_tx_pack(system_id, component_id, msg, emsad_sensor_data_tx->time_sinceBoot, emsad_sensor_data_tx->capacitor_volt, emsad_sensor_data_tx->acc_reading, emsad_sensor_data_tx->reserved1, emsad_sensor_data_tx->pressure_reading, emsad_sensor_data_tx->pressure_Diff, emsad_sensor_data_tx->status_flags, emsad_sensor_data_tx->fsm_State);
}

/**
 * @brief Encode a emsad_sensor_data_tx struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param emsad_sensor_data_tx C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_emsad_sensor_data_tx_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_emsad_sensor_data_tx_t* emsad_sensor_data_tx)
{
    return mavlink_msg_emsad_sensor_data_tx_pack_chan(system_id, component_id, chan, msg, emsad_sensor_data_tx->time_sinceBoot, emsad_sensor_data_tx->capacitor_volt, emsad_sensor_data_tx->acc_reading, emsad_sensor_data_tx->reserved1, emsad_sensor_data_tx->pressure_reading, emsad_sensor_data_tx->pressure_Diff, emsad_sensor_data_tx->status_flags, emsad_sensor_data_tx->fsm_State);
}

/**
 * @brief Encode a emsad_sensor_data_tx struct with provided status structure
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param status MAVLink status structure
 * @param msg The MAVLink message to compress the data into
 * @param emsad_sensor_data_tx C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_emsad_sensor_data_tx_encode_status(uint8_t system_id, uint8_t component_id, mavlink_status_t* _status, mavlink_message_t* msg, const mavlink_emsad_sensor_data_tx_t* emsad_sensor_data_tx)
{
    return mavlink_msg_emsad_sensor_data_tx_pack_status(system_id, component_id, _status, msg,  emsad_sensor_data_tx->time_sinceBoot, emsad_sensor_data_tx->capacitor_volt, emsad_sensor_data_tx->acc_reading, emsad_sensor_data_tx->reserved1, emsad_sensor_data_tx->pressure_reading, emsad_sensor_data_tx->pressure_Diff, emsad_sensor_data_tx->status_flags, emsad_sensor_data_tx->fsm_State);
}

/**
 * @brief Send a emsad_sensor_data_tx message
 * @param chan MAVLink channel to send the message
 *
 * @param time_sinceBoot [ms] Timestamp (time since system boot).
 * @param capacitor_volt [V] Capacitor voltage.
 * @param acc_reading  Acceleration measurement.
 * @param reserved1  Reserved.
 * @param pressure_reading  Barometric pressure.
 * @param pressure_Diff  Differential pressure.
 * @param status_flags  EMSAD status flags.
 * @param fsm_State  EMSAD finite-state-machine state.
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_emsad_sensor_data_tx_send(mavlink_channel_t chan, uint32_t time_sinceBoot, float capacitor_volt, float acc_reading, float reserved1, float pressure_reading, float pressure_Diff, uint8_t status_flags, uint8_t fsm_State)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN];
    _mav_put_uint32_t(buf, 0, time_sinceBoot);
    _mav_put_float(buf, 4, capacitor_volt);
    _mav_put_float(buf, 8, acc_reading);
    _mav_put_float(buf, 12, reserved1);
    _mav_put_float(buf, 16, pressure_reading);
    _mav_put_float(buf, 20, pressure_Diff);
    _mav_put_uint8_t(buf, 24, status_flags);
    _mav_put_uint8_t(buf, 25, fsm_State);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX, buf, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
#else
    mavlink_emsad_sensor_data_tx_t packet;
    packet.time_sinceBoot = time_sinceBoot;
    packet.capacitor_volt = capacitor_volt;
    packet.acc_reading = acc_reading;
    packet.reserved1 = reserved1;
    packet.pressure_reading = pressure_reading;
    packet.pressure_Diff = pressure_Diff;
    packet.status_flags = status_flags;
    packet.fsm_State = fsm_State;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX, (const char *)&packet, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
#endif
}

/**
 * @brief Send a emsad_sensor_data_tx message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_emsad_sensor_data_tx_send_struct(mavlink_channel_t chan, const mavlink_emsad_sensor_data_tx_t* emsad_sensor_data_tx)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_emsad_sensor_data_tx_send(chan, emsad_sensor_data_tx->time_sinceBoot, emsad_sensor_data_tx->capacitor_volt, emsad_sensor_data_tx->acc_reading, emsad_sensor_data_tx->reserved1, emsad_sensor_data_tx->pressure_reading, emsad_sensor_data_tx->pressure_Diff, emsad_sensor_data_tx->status_flags, emsad_sensor_data_tx->fsm_State);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX, (const char *)emsad_sensor_data_tx, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
#endif
}

#if MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This variant of _send() can be used to save stack space by reusing
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_emsad_sensor_data_tx_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint32_t time_sinceBoot, float capacitor_volt, float acc_reading, float reserved1, float pressure_reading, float pressure_Diff, uint8_t status_flags, uint8_t fsm_State)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;
    _mav_put_uint32_t(buf, 0, time_sinceBoot);
    _mav_put_float(buf, 4, capacitor_volt);
    _mav_put_float(buf, 8, acc_reading);
    _mav_put_float(buf, 12, reserved1);
    _mav_put_float(buf, 16, pressure_reading);
    _mav_put_float(buf, 20, pressure_Diff);
    _mav_put_uint8_t(buf, 24, status_flags);
    _mav_put_uint8_t(buf, 25, fsm_State);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX, buf, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
#else
    mavlink_emsad_sensor_data_tx_t *packet = (mavlink_emsad_sensor_data_tx_t *)msgbuf;
    packet->time_sinceBoot = time_sinceBoot;
    packet->capacitor_volt = capacitor_volt;
    packet->acc_reading = acc_reading;
    packet->reserved1 = reserved1;
    packet->pressure_reading = pressure_reading;
    packet->pressure_Diff = pressure_Diff;
    packet->status_flags = status_flags;
    packet->fsm_State = fsm_State;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX, (const char *)packet, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_MIN_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_CRC);
#endif
}
#endif

#endif

// MESSAGE EMSAD_SENSOR_DATA_TX UNPACKING


/**
 * @brief Get field time_sinceBoot from emsad_sensor_data_tx message
 *
 * @return [ms] Timestamp (time since system boot).
 */
static inline uint32_t mavlink_msg_emsad_sensor_data_tx_get_time_sinceBoot(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint32_t(msg,  0);
}

/**
 * @brief Get field capacitor_volt from emsad_sensor_data_tx message
 *
 * @return [V] Capacitor voltage.
 */
static inline float mavlink_msg_emsad_sensor_data_tx_get_capacitor_volt(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  4);
}

/**
 * @brief Get field acc_reading from emsad_sensor_data_tx message
 *
 * @return  Acceleration measurement.
 */
static inline float mavlink_msg_emsad_sensor_data_tx_get_acc_reading(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  8);
}

/**
 * @brief Get field reserved1 from emsad_sensor_data_tx message
 *
 * @return  Reserved.
 */
static inline float mavlink_msg_emsad_sensor_data_tx_get_reserved1(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  12);
}

/**
 * @brief Get field pressure_reading from emsad_sensor_data_tx message
 *
 * @return  Barometric pressure.
 */
static inline float mavlink_msg_emsad_sensor_data_tx_get_pressure_reading(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  16);
}

/**
 * @brief Get field pressure_Diff from emsad_sensor_data_tx message
 *
 * @return  Differential pressure.
 */
static inline float mavlink_msg_emsad_sensor_data_tx_get_pressure_Diff(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  20);
}

/**
 * @brief Get field status_flags from emsad_sensor_data_tx message
 *
 * @return  EMSAD status flags.
 */
static inline uint8_t mavlink_msg_emsad_sensor_data_tx_get_status_flags(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  24);
}

/**
 * @brief Get field fsm_State from emsad_sensor_data_tx message
 *
 * @return  EMSAD finite-state-machine state.
 */
static inline uint8_t mavlink_msg_emsad_sensor_data_tx_get_fsm_State(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  25);
}

/**
 * @brief Decode a emsad_sensor_data_tx message into a struct
 *
 * @param msg The message to decode
 * @param emsad_sensor_data_tx C-struct to decode the message contents into
 */
static inline void mavlink_msg_emsad_sensor_data_tx_decode(const mavlink_message_t* msg, mavlink_emsad_sensor_data_tx_t* emsad_sensor_data_tx)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    emsad_sensor_data_tx->time_sinceBoot = mavlink_msg_emsad_sensor_data_tx_get_time_sinceBoot(msg);
    emsad_sensor_data_tx->capacitor_volt = mavlink_msg_emsad_sensor_data_tx_get_capacitor_volt(msg);
    emsad_sensor_data_tx->acc_reading = mavlink_msg_emsad_sensor_data_tx_get_acc_reading(msg);
    emsad_sensor_data_tx->reserved1 = mavlink_msg_emsad_sensor_data_tx_get_reserved1(msg);
    emsad_sensor_data_tx->pressure_reading = mavlink_msg_emsad_sensor_data_tx_get_pressure_reading(msg);
    emsad_sensor_data_tx->pressure_Diff = mavlink_msg_emsad_sensor_data_tx_get_pressure_Diff(msg);
    emsad_sensor_data_tx->status_flags = mavlink_msg_emsad_sensor_data_tx_get_status_flags(msg);
    emsad_sensor_data_tx->fsm_State = mavlink_msg_emsad_sensor_data_tx_get_fsm_State(msg);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN? msg->len : MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN;
        memset(emsad_sensor_data_tx, 0, MAVLINK_MSG_ID_EMSAD_SENSOR_DATA_TX_LEN);
    memcpy(emsad_sensor_data_tx, _MAV_PAYLOAD(msg), len);
#endif
}
