#include "script_component.hpp"
/*
 * Author: commy2, Salbei
 * Handles when a unit gets in to a vehicle.  Release escorted captive when entering a vehicle
 *
 * Arguments:
 * 0: _vehicle <OBJECT>
 * 1: dunno <OBJECT>
 * 2: _unit <OBJECT>
 *
 * Return Value:
 * The return value <BOOL>
 *
 * Example:
 * [car2, x, player] call grad_captiveWalking_functions_fnc_handleGetIn
 *
 * Public: No
 */

params ["_vehicle", "","_unit"];
TRACE_2("params",_vehicle,_unit);

if (local _unit) then {
    if (_unit getVariable ["ace_captives_isEscorting", false]) then {
        _unit setVariable ["ace_captives_isEscorting", false, true];
    };

    if (_unit getVariable ["ace_captives_isSurrendering", false]) then {
        [_unit, false] call ace_captives_fnc_setSurrendered;
    };

    if (_unit getVariable ["ace_captives_isHandcuffed", false]) then {

        //remove animation handle
        private _pfh = _unit getVariable [QGVAR(PFH), -1];
        if (_pfh != -1) then {
           [_pfh] call CBA_fnc_removePerFrameHandler;
        };
        
        //Need to force animation for FFV turrets
        private _turretPath = [];
        {
            _x params ["_xUnit", "", "", "_xTurretPath"];
            if (_unit == _xUnit) exitWith {_turretPath = _xTurretPath};
        } forEach (fullCrew (vehicle _unit));
        if (!(_turretPath isEqualTo [])) then {
            TRACE_1("Setting FFV Handcuffed Animation",_turretPath);
            [_unit, "ACE_HandcuffedFFV", 2] call ace_common_fnc_doAnimation;
            [_unit, "ACE_HandcuffedFFV", 1] call ace_common_fnc_doAnimation;
        };
    };
};
