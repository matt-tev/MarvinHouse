function velocity = Vrover(rover,omega)
    for i = 1:length(omega)
        velocity = rover.wheel_assembly.wheel.radius*(omega(i)/get_gear_ratio(rover.wheel_assembly.speed_reducer));
    end
end
