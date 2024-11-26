/**
 * @file Roidz.h
 * @date 12-Nov-2024
 */

#ifndef __Roidz_H__
#define __Roidz_H__

#include "Scroll.h"

/** Game Class
 */
class Roidz : public Scroll<Roidz>
{
public:


private:

                orxSTATUS       Bootstrap() const;

                void            Update(const orxCLOCK_INFO &_rstInfo);

                orxSTATUS       Init();
                orxSTATUS       Run();
                void            Exit();
                void            BindObjects();


private:
                ScrollObject   *scene;
};

#endif // __Roidz_H__
