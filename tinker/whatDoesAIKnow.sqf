// wie kann ich feststellen, was die AI weiß
_unit = allUnits select 0;
_target = player;
[_unit knowsAbout _target, _unit targetKnowledge _target];