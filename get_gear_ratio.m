function Ng = get_gear_ratio(speed_reducer)
    %   Function get_gear_ratio takes input speed_reducer(struct)and
    %   outputs Ng which is the gear ratio between the gear and pinion
    
    if nargin ~= 1
        error('There is not 1 input.')
    elseif ~isstruct(speed_reducer)
        error('Speed Reducer is not a struct.')
    else
        s1 = speed_reducer.type;
        s2 = 'reverted';
        if strcmp(s1,s2)
            Ng = (speed_reducer.diam_gear/speed_reducer.diam_pinion)^2;
        else
            error('The field "type" inside struct "speed_reducer" is not a string equal to ''reverted''.');
        end
    end
end