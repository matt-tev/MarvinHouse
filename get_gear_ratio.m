%get_gear_ratio

function Ng = get_gear_ratio(speed_reducer)
    if nargin ~= 1
        error('There is not 1 input.')
    elseif ~isstruct(speed_reducer)
        error('Speed Reducer is not a struct.')
    else
    end
end