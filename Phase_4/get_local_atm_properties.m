function [density, temperature, pressure] = get_local_atm_properties(planet, altitude)
% get_local_atm_properties
%
% Returns local atmospheric properties at a given altitude. 
%
% Usage:
%  density = get_local_atm_properties(planet, altitude) returns the
%  atmospheric density in kg/m^3. Assumed altitude is specified in meters.
%
%  [density, temperature] = get_local_atm_properties(planet, altitude) also
%  returns the local temperature in C.
%
%  [density, temperature, pressure] = get_local_atm_properties(planet, altitude)
%  also returns the local pressure in KPa.
%
% Note: this function is NOT vectorized. It will not accept a vector of
% altitudes.
%


if altitude > planet.altitude_threshold
   temperature = planet.high_altitude.temperature(altitude); 
   pressure = planet.high_altitude.pressure(altitude);
else
   temperature = planet.low_altitude.temperature(altitude); 
   pressure = planet.low_altitude.pressure(altitude);    
end

density     = planet.density(temperature,pressure); 
 