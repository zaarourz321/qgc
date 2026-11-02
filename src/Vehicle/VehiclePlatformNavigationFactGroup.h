#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

// Telemetry supplied by the custom HUNTER_MODE MAVLink message. Keeping it in
// a FactGroup makes every value available to configurable Flight View HUDs.
class VehiclePlatformNavigationFactGroup : public FactGroup
{public:
    VehiclePlatformNavigationFactGroup(QObject* parent = nullptr);
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;


private:
    Fact _timeUsec, _rollSp, _qCmd, _qMeas, _errorHoriz, _errorVertic;
    Fact _acczCmd, _acczMeas, _accyCmd, _accyMeas, _orthogonality;
    Fact _error, _arrived, _relaxFactor, _counter, _deltax, _deltay, _deltaz, _v, _startFlag;
};
