%get_gear_ratio

function Ng = get_gear_ratio(speed_reducer)
    if nargin ~= 1
        error('There is not 1 input.')
    elseif ~isstruct(speed_reducer)
        error('Speed Reducer is not a struct.')
    else
        if s1 == speed_reducer.type && s2 == ('reverted')'
            Ng = strcmp(s1,s2);
        else error('The type field is not reverted.')
        end
    end
end