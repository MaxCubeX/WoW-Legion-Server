#include "ScriptMgr.h"
#include "Player.h"
#include "Chat.h"

class ExampleModulePlayerScript : public PlayerScript
{
public:
    ExampleModulePlayerScript() : PlayerScript("ExampleModulePlayerScript") { }

    void OnLogin(Player* player, bool /*firstLogin*/) override
    {
        ChatHandler(player->GetSession()).SendSysMessage("ExampleModule loaded.");
    }
};

void AddSC_ExampleModule()
{
    new ExampleModulePlayerScript();
}
