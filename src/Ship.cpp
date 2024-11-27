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
  Object::Update(_rstInfo);

  PushConfigSection();

  SetAngularVelocity(orxMATH_KF_DEG_TO_RAD * orxConfig_GetFloat("TurnSpeed") * (orxInput_GetValue("RotateCW") - orxInput_GetValue("RotateCCW")));

  orxVECTOR speed;
  GetSpeed(speed, orxTRUE);
  speed.fX += _rstInfo.fDT * orxConfig_GetFloat("Thrust") * orxInput_GetValue("Thrust");
  SetSpeed(speed, orxTRUE);

  if(auto weapon = FindChild("Weapon"))
  {
    weapon->Enable(orxInput_IsActive("Shoot"));
  }

  PopConfigSection();
}
