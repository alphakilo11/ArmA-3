// https://discord.com/channels/105462288051380224/1126847422035931156/1134975115998793871
[] spawn
{
    while {true} do 
    {
        {
            private _unit = _x;
            if (!(_unit getVariable ["jboy_speakerAssigned",false]) 
                and toLower (uniform _unit) find "spe_ger" >=0) then
            {
                _unit setVariable ["jboy_speakerAssigned",true];
                _unit setSpeaker selectRandom ["gm_voice_male_deu_01","gm_voice_male_deu_02","gm_voice_male_deu_03","gm_voice_male_deu_04","gm_voice_male_deu_05","gm_voice_male_deu_06","gm_voice_male_deu_07"];
            };
        } foreach allUnits;
        sleep 60;
    };
};
