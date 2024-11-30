using Godot;
using susgame.code.machines;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code.integration
{
    public partial class PlayerClickHandler : Node
    {

        private Conveyor conveyor;

        public override void _Ready()
        {
            Map.CreateMap();
            conveyor = new Conveyor(Map.Current, 0, 0);
        }

        bool wasmouseclicked = false;

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event is InputEventMouseMotion || @event is InputEventMouseButton)
            {
                // Get the camera in the scene (ensure your camera is correctly assigned).
                Camera3D camera = GetViewport().GetCamera3D();
                if (camera != null)
                {
                    // Get the ray origin and direction from the camera.
                    Vector2 mousePosition = ((InputEventMouse)@event).Position;
                    Vector3 rayOrigin = camera.ProjectRayOrigin(mousePosition);
                    Vector3 rayDirection = camera.ProjectRayNormal(mousePosition);

                    // Define the XZ plane (y = 0).
                    Plane plane = new Plane(Vector3.Up, 0);

                    // Calculate the intersection point of the ray with the plane.
                    Vector3? intersection = plane.IntersectsRay(rayOrigin, rayDirection);
                    if (intersection != null)
                    {
                        conveyor.X = (int)intersection.Value.X;
                        conveyor.Y = (int)intersection.Value.Z;
                        if (Input.IsMouseButtonPressed(MouseButton.Left) && !wasmouseclicked)
                        {
                            new Conveyor(Map.Current, (int)intersection.Value.X, (int)intersection.Value.Z);
                        }
                        wasmouseclicked = Input.IsMouseButtonPressed(MouseButton.Left);
                    }
                }
            }
        }

    }
}
