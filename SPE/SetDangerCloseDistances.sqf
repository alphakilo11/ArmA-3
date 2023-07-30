// https://discord.com/channels/105462288051380224/1126847422035931156/1135113837981487154
if (isNil ("SPE_IFS_SafetyDistance_MortarArty")) then
{
    SPE_IFS_SafetyDistance_MortarArty = [75,75,75,75];
    publicVariable "SPE_IFS_SafetyDistance_MortarArty";
};//friendly units closer than this value (in meters, reduced by target's value) will invalidate potential mortar artillery target. Per side: [east,west,resistance,other]

if (isNil ("SPE_IFS_SafetyDistance_HeavyArty")) then
{
    SPE_IFS_SafetyDistance_HeavyArty = [100,100,100,100];
    publicVariable "SPE_IFS_SafetyDistance_HeavyArty";
};//friendly units closer than this value (in meters, reduced by target's value) will invalidate potential non-mortar artillery target. Per side: [east,west,resistance,other]

if (isNil "SPE_IFS_SafetyDistance_CAS") then
{
    SPE_IFS_SafetyDistance_CAS = [50,50,50,50];
    publicVariable "SPE_IFS_SafetyDistance_CAS";
};//friendly units closer than this value (in meters, reduced by target's value) will invalidate potential CAS target. Per side: [east,west,resistance,other]

if (isNil "SPE_IFS_TargetBlackList") then {SPE_IFS_TargetBlackList = [];};//units inside this array will be not targeted by IFS, nor units close to them (in base safety radius)
if (isNil "SPE_IFS_AreaBlackList") then {SPE_IFS_AreaBlackList = [];};//No target within included areas will become a target of IFS. Also IFS will try to avoid any shells dropping inside those areas. No 100% warranty. Accepted are all entries handled by inArea command (trigger, marker, location or [center, a, b, angle, isRectangle, c] array. If object is given as a center, area will be each check updated depending on object's position)
