% Function get_gear_ratio computes the gear ratio of the speed reducer. 
%    
% CALLING SYNTAX
%   Ng = get_gear_ratio(speed_reducer)
% INPUTS
%   speed_reducer   struct      Data structure specifying speed reducer parameters
% OUTPUTS
%   Ng              scalar      Speed ratio from input pinion shaft to output gear shaft. Unitless
function Ng = get_gear_ratio(speed_reducer)
    % Data Validation
    if nargin ~= 1
        error('There is not 1 input.')
    elseif ~isstruct(speed_reducer)
        error('Speed Reducer is not a struct.')
    elseif ~strcmp(speed_reducer.type,'reverted')
        error('The field "type" inside struct "speed_reducer" is not a string equal to ''reverted''.');
    end
    
    Ng = (speed_reducer.diam_gear/speed_reducer.diam_pinion)^2;   

end