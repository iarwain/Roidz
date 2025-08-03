/**
 * @file Roidz.cpp
 * @date 12-Nov-2024
 */

#define __SCROLL_IMPL__
#include "Roidz.h"
#undef __SCROLL_IMPL__

#include "Object.h"
#include "Ship.h"
#include "orxExtensions.h"

#ifdef __orxMSVC__

/* Requesting high performance dedicated GPU on hybrid laptops */
__declspec(dllexport) unsigned long NvOptimusEnablement        = 1;
__declspec(dllexport) int AmdPowerXpressRequestHighPerformance = 1;

#endif // __orxMSVC__

/** Update function, it has been registered to be called every tick of the core clock
 */
void Roidz::Update(const orxCLOCK_INFO &_rstClockInfo)
{
  // Should quit?
  if(orxInput_HasBeenActivated("Quit"))
  {
    // Send close event
    orxEvent_SendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE);
  }

  // Pause?
  if(orxInput_HasBeenActivated("Pause"))
  {
    PauseGame(!IsGamePaused());
  }
}

/** Init function, it is called when all orx's modules have been initialized
 */
orxSTATUS Roidz::Init()
{
  // Init extensions
  InitExtensions();

  // Create the scene
  CreateObject("Scene");

  // Push [Game] as the default section
  orxConfig_PushSection("Game");

  // Create the viewports
  for(orxS32 i = 0, iCount = orxConfig_GetListCount("ViewportList"); i < iCount; i++)
  {
    orxViewport_CreateFromConfig(orxConfig_GetListString("ViewportList", i));
  }

  // Done!
  return orxSTATUS_SUCCESS;
}

/** Run function, it should not contain any game logic
 */
orxSTATUS Roidz::Run()
{
  // Return orxSTATUS_FAILURE to instruct orx to quit
  return orxSTATUS_SUCCESS;
}

/** Exit function, it is called before exiting from orx
 */
void Roidz::Exit()
{
  // Exit from extensions
  ExitExtensions();

  // Let orx clean all our mess automatically. :)
}

/** BindObjects function, ScrollObject-derived classes are bound to config sections here
 */
void Roidz::BindObjects()
{
  BindObject(Object);
  BindObject(Ship);
}

/** Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
 */
orxSTATUS Roidz::Bootstrap() const
{
  // Bootstrap extensions
  BootstrapExtensions();

  // Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_SUCCESS;
}

/** Main function
 */
int main(int argc, char **argv)
{
  // Execute our game
  Roidz::GetInstance().Execute(argc, argv);

  // Done!
  return EXIT_SUCCESS;
}
