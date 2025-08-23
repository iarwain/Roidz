/**
 * @file Ship.cpp
 * @date 12-Nov-2024
 */

#include "Ship.h"

void Ship::OnCreate()
{
}

void Ship::OnDelete()
{
}

void Ship::Update(const orxCLOCK_INFO &_rstInfo)
{
  PushConfigSection();

  // Update base object
  Object::Update(_rstInfo);

  // Rotate
  SetAngularVelocity(orxMATH_KF_DEG_TO_RAD * orxConfig_GetFloat("TurnSpeed") * (orxInput_GetValue("RotateCW") - orxInput_GetValue("RotateCCW")));

  // Thrust
  orxVECTOR speed;
  GetSpeed(speed, orxTRUE);
  speed.fX += _rstInfo.fDT * orxConfig_GetFloat("Acceleration") * orxInput_GetValue("Thrust");
  SetSpeed(speed, orxTRUE);

  // Shoot
  if(auto weapon = FindChild("@Weapon"))
  {
    weapon->Enable(orxInput_IsActive("Shoot"));
  }

  // Thruster
  if(auto thruster = FindChild("@Thruster"))
  {
    thruster->Enable(orxInput_IsActive("Thrust"));
  }

  PopConfigSection();
}
