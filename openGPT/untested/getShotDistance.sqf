// Definieren Sie den EventHandler für das Fired Ereignis
player addEventHandler ["Fired", {
    params ["_shooter", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

    // Verwenden Sie BIS_fnc_traceBullets, um die Kugelbahnen zu visualisieren und Informationen zu erhalten
    [_shooter, 1] call BIS_fnc_traceBullets;

    // Warten Sie, bis die Kugel ihr Ziel erreicht hat oder ihre maximale Reichweite erreicht hat
    waitUntil {
        sleep 0.1;
        (isNull _projectile) || {((getPos _projectile) select 2) < -1}
    };

    // Berechnen Sie die zurückgelegte Entfernung der Kugel
    private _distance = _shooter distance (getPos _projectile);

    // Überprüfen Sie, ob die Kugel etwas getroffen hat
    private _hit = !(isNull _projectile);

    // Anzeigen der zurückgelegten Entfernung und ob die Kugel etwas getroffen hat
    systemChat format ["Bullet distance: %1 meters. Hit: %2", _distance, _hit];
}];
