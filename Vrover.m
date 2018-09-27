function velocity = Vrover(rover,omega)
    velocity = rover.wheel_assembly.wheel.radius*(omega/get_gear_ratio(rover.wheel_assembly.speed_reducer));
end