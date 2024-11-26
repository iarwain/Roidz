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
  auto width = orxConfig_GetFloat("AreaWidth");
  auto height = orxConfig_GetFloat("AreaHeight");
  
  orxVECTOR pos;
  GetPosition(pos);
  if(pos.fX < -0.5 * width)
  {
    pos.fX += width;
  }
  else if(pos.fX > 0.5 * width)
  {
    pos.fX -= width;
  }
  if(pos.fY < -0.5 * height)
  {
    pos.fY += height;
  }
  else if(pos.fY > 0.5 * height)
  {
    pos.fY -= height;
  }
  SetPosition(pos);
}
