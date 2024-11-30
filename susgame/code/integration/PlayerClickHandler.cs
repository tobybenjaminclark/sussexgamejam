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

        //private Conveyor conveyor;

        public override void _Ready()
        {
            Map.CreateMap();
            //conveyor = new Conveyor(Map.Current, 0, 0);
        }

        public int selected = 1;

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
                        //conveyor.X = (int)intersection.Value.X;
                        //conveyor.Y = (int)intersection.Value.Z;
                        if (Input.IsMouseButtonPressed(MouseButton.Left) && !wasmouseclicked)
                        {
                            if ((int)intersection.Value.X < 0 || (int)intersection.Value.Y < 0 || (int)intersection.Value.X > Map.Current.Width || (int)intersection.Value.Y > Map.Current.Height)
                                return;
                            if (Map.Current.TileList[(int)intersection.Value.X, (int)intersection.Value.Z].IsOccupied())
                                return;
                            switch (selected)
                            {
                                case 1:
                                    new Conveyor(Map.Current, (int)intersection.Value.X, (int)intersection.Value.Z);
                                    break;
                                case 2:
                                    new Creator(Map.Current, (int)intersection.Value.X, (int)intersection.Value.Z);
                                    break;
                            }
                        }
                        wasmouseclicked = Input.IsMouseButtonPressed(MouseButton.Left);
                    }
                }
            }
            if (@event is InputEventKey keyEvent)
            {
                if (keyEvent.Keycode == Key.Key1)
                {
                    selected = 1;
                }
                if (keyEvent.Keycode == Key.Key2)
                {
                    selected = 2;
                }
            }
        }

    }
}
