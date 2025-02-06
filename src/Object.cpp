/**
 * @file Object.cpp
 * @date 12-Nov-2024
 */

#include "Object.h"

void Object::OnCreate()
{
}

void Object::OnDelete()
{
}

void Object::Update(const orxCLOCK_INFO &_rstInfo)
{
  orxVECTOR arena;
  orxConfig_GetVector("ArenaSize", &arena);
  
  orxVECTOR pos;
  GetPosition(pos);
  if(pos.fX < -0.5 * arena.fX)
  {
    pos.fX += arena.fX;
  }
  else if(pos.fX > 0.5 * arena.fX)
  {
    pos.fX -= arena.fX;
  }
  if(pos.fY < -0.5 * arena.fY)
  {
    pos.fY += arena.fY;
  }
  else if(pos.fY > 0.5 * arena.fY)
  {
    pos.fY -= arena.fY;
  }
  SetPosition(pos);
}
