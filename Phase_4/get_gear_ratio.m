function[Ng]=get_gear_ratio(speed_reducer)
% get_gear_ratio.m
% Inputs:  speed_reducer:  struct    Data structure specifying speed
%                                    reducer parameters
% Outputs:            Ng:  scalar    Speed ratio from input pinion shaft
%                                    to output gear shaft. Unitless.

% Check that 1 input has been given.
if nargin ~= 1
    error('Incorrect number of inputs.  There should be one input.');
end

% Check that the input is a struct
if isstruct(speed_reducer) ~=1
    error('Input must be a struct');
end

% Check type field
if ~strcmpi(speed_reducer.type,'reverted')
    error('The speed reducer type is not correct.')
end

% Main code
d1 = speed_reducer.diam_pinion;
d2 = speed_reducer.diam_gear;

Ng = (d2/d1)^2;