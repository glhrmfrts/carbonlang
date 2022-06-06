import "rt"

type VehicleKind := enum (
    Invalid
    Car
    Motorcycle
    Bicycle
    Monocycle
    Boat
    Airplane
)

fun main := do
    let vk : VehicleKind
    writeln(vk = VehicleKind.Invalid) -- true

    vk := VehicleKind.Bicycle
    writeln(vk = VehicleKind.Bicycle) -- true
end