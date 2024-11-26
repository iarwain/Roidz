/**
 * @file Ship.h
 * @date 12-Nov-2024
 */

#ifndef __SHIP_H__
#define __SHIP_H__

#include "Object.h"

/** Ship Class
 */
class Ship : public Object
{
public:


protected:

                void            OnCreate();
                void            OnDelete();
                void            Update(const orxCLOCK_INFO &_rstInfo);


private:
};

#endif // __SHIP_H__
