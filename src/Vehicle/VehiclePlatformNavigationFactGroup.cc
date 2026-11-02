#include "VehiclePlatformNavigationFactGroup.h"

#include <QtMath>

namespace {
const char* const factNames[] = { "timeUsec", "rollSp", "qCmd", "qMeas", "errorHoriz", "errorVertic", "acczCmd", "acczMeas", "accyCmd", "accyMeas", "orthogonality", "error", "hit", "relaxFactor", "hitCounter", "deltax", "deltay", "deltaz", "speed", "diveFlag" };
}

VehiclePlatformNavigationFactGroup::VehiclePlatformNavigationFactGroup(QObject* parent)
    : FactGroup(100, ":/json/Vehicle/PlatformNavigationFact.json", parent)
    , _timeUsec(0, factNames[0], FactMetaData::valueTypeUint64)
    , _rollSp(0, factNames[1], FactMetaData::valueTypeDouble)
    , _qCmd(0, factNames[2], FactMetaData::valueTypeDouble)
    , _qMeas(0, factNames[3], FactMetaData::valueTypeDouble)
    , _errorHoriz(0, factNames[4], FactMetaData::valueTypeDouble)
    , _errorVertic(0, factNames[5], FactMetaData::valueTypeDouble)
    , _acczCmd(0, factNames[6], FactMetaData::valueTypeDouble)
    , _acczMeas(0, factNames[7], FactMetaData::valueTypeDouble)
    , _accyCmd(0, factNames[8], FactMetaData::valueTypeDouble)
    , _accyMeas(0, factNames[9], FactMetaData::valueTypeDouble)
    , _orthogonality(0, factNames[10], FactMetaData::valueTypeDouble)
    , _error(0, factNames[11], FactMetaData::valueTypeDouble)
    , _arrived(0, factNames[12], FactMetaData::valueTypeDouble)
    , _relaxFactor(0, factNames[13], FactMetaData::valueTypeDouble)
    , _counter(0, factNames[14], FactMetaData::valueTypeDouble)
    , _deltax(0, factNames[15], FactMetaData::valueTypeDouble)
    , _deltay(0, factNames[16], FactMetaData::valueTypeDouble)
    , _deltaz(0, factNames[17], FactMetaData::valueTypeDouble)
    , _v(0, factNames[18], FactMetaData::valueTypeDouble)
    , _startFlag(0, factNames[19], FactMetaData::valueTypeUint8)
{
    Fact* facts[] = { &_timeUsec, &_rollSp, &_qCmd, &_qMeas, &_errorHoriz, &_errorVertic, &_acczCmd, &_acczMeas, &_accyCmd, &_accyMeas, &_orthogonality, &_error, &_arrived, &_relaxFactor, &_counter, &_deltax, &_deltay, &_deltaz, &_v, &_startFlag };
    for (int i = 0; i < 20; ++i) { _addFact(facts[i], factNames[i]); facts[i]->setRawValue(qQNaN()); }
}

void VehiclePlatformNavigationFactGroup::handleMessage(Vehicle*, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_HUNTER_MODE) return;
    mavlink_hunter_mode_t t;
    mavlink_msg_hunter_mode_decode(&message, &t);
    _timeUsec.setRawValue(t.time_usec); _rollSp.setRawValue(t.roll_sp); _qCmd.setRawValue(t.q_cmd); _qMeas.setRawValue(t.q_meas);
    _errorHoriz.setRawValue(t.error_horiz); _errorVertic.setRawValue(t.error_vertic); _acczCmd.setRawValue(t.accz_cmd); _acczMeas.setRawValue(t.accz_meas);
    _accyCmd.setRawValue(t.accy_cmd); _accyMeas.setRawValue(t.accy_meas); _orthogonality.setRawValue(t.orthogonality); _error.setRawValue(t.error);
    _arrived.setRawValue(t.arrived); _relaxFactor.setRawValue(t.relax_factor); _counter.setRawValue(t.counter); _deltax.setRawValue(t.deltax);
    _deltay.setRawValue(t.deltay); _deltaz.setRawValue(t.deltaz); _v.setRawValue(t.v); _startFlag.setRawValue(t.start_flag);
    _setTelemetryAvailable(true);
}
