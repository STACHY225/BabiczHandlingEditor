var handlingTemplate = `<fMass value="fMass_value"/>
<fInitialDragCoeff value="fInitialDragCoeff_value"/>
<fDownForceModifier value="fDownForceModifier_value"/>
<fPercentSubmerged value="fPercentSubmerged_value"/>
<vecCentreOfMassOffset x="vecCentreOfMassOffset_x_value" y="vecCentreOfMassOffset_y_value" z="vecCentreOfMassOffset_z_value"/>
<vecInertiaMultiplier x="vecInertiaMultiplier_x_value" y="vecInertiaMultiplier_y_value" z="vecInertiaMultiplier_z_value"/>
<fDriveBiasFront value="fDriveBiasFront_value"/>
<nInitialDriveGears value="nInitialDriveGears_value"/>
<fInitialDriveForce value="fInitialDriveForce_value"/>
<fDriveInertia value="fDriveInertia_value"/>
<fClutchChangeRateScaleUpShift value="fClutchChangeRateScaleUpShift_value"/>
<fClutchChangeRateScaleDownShift value="fClutchChangeRateScaleDownShift_value"/>
<fInitialDriveMaxFlatVel value="fInitialDriveMaxFlatVel_value"/>
<fBrakeForce value="fBrakeForce_value"/>
<fBrakeBiasFront value="fBrakeBiasFront_value"/>
<fHandBrakeForce value="fHandBrakeForce_value"/>
<fSteeringLock value="fSteeringLock_value"/>
<fTractionCurveMax value="fTractionCurveMax_value"/>
<fTractionCurveMin value="fTractionCurveMin_value"/>
<fTractionCurveLateral value="fTractionCurveLateral_value"/>
<fTractionSpringDeltaMax value="fTractionSpringDeltaMax_value"/>
<fLowSpeedTractionLossMult value="fLowSpeedTractionLossMult_value"/>
<fCamberStiffnesss value="fCamberStiffnesss_value"/>
<fTractionBiasFront value="fTractionBiasFront_value"/>
<fTractionLossMult value="fTractionLossMult_value"/>
<fSuspensionForce value="fSuspensionForce_value"/>
<fSuspensionCompDamp value="fSuspensionCompDamp_value"/>
<fSuspensionReboundDamp value="fSuspensionReboundDamp_value"/>
<fSuspensionUpperLimit value="fSuspensionUpperLimit_value"/>
<fSuspensionLowerLimit value="fSuspensionLowerLimit_value"/>
<fSuspensionRaise value="fSuspensionRaise_value"/>
<fSuspensionBiasFront value="fSuspensionBiasFront_value"/>
<fAntiRollBarForce value="fAntiRollBarForce_value"/>
<fAntiRollBarBiasFront value="fAntiRollBarBiasFront_value"/>
<fRollCentreHeightFront value="fRollCentreHeightFront_value"/>
<fRollCentreHeightRear value="fRollCentreHeightRear_value"/>
<fCollisionDamageMult value="fCollisionDamageMult_value"/>
<fWeaponDamageMult value="fWeaponDamageMult_value"/>
<fDeformationDamageMult value="fDeformationDamageMult_value"/>
<fEngineDamageMult value="fEngineDamageMult_value"/>
<fPetrolTankVolume value="fPetrolTankVolume_value"/>
<fOilVolume value="fOilVolume_value"/>
<fSeatOffsetDistX value="fSeatOffsetDistX_value"/>
<fSeatOffsetDistY value="fSeatOffsetDistY_value"/>
<fSeatOffsetDistZ value="fSeatOffsetDistZ_value"/>
<nMonetaryValue value="nMonetaryValue_value"/>`;
var resName = "";
if(typeof GetParentResourceName == "function") resName = GetParentResourceName();

var elements = {};
const Container = document.getElementById("container");

async function Post(name, data) {
    try {
        let resp = await fetch(`https://${resName}/${name}`, {
            method: "POST",
            mode: "same-origin",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json; charset=UTF-8"
            },
            body: JSON.stringify(data || {})
        });
        if(!resp.ok){
            return;
        }
        return await resp.json();
    } catch (err) {}
}

window.onload = function(){
    let names = ["fBrakeForce", "fDownForceModifier", "fPercentSubmerged", "fBrakeBiasFront", "fCollisionDamageMult", "fDriveInertia", "vecInertiaMultiplier_x", "vecInertiaMultiplier_y", "vecInertiaMultiplier_z", "fInitialDriveForce", "fDriveBiasFront", "fSeatOffsetDistZ", "fSuspensionCompDamp", "fTractionLossMult", "fTractionSpringDeltaMax", "fSuspensionBiasFront", "vecCentreOfMassOffset_x", "vecCentreOfMassOffset_y", "vecCentreOfMassOffset_z", "fRollCentreHeightRear", "fMass", "fInitialDriveMaxFlatVel", "nInitialDriveGears", "strHandlingFlags", "strModelFlags", "fClutchChangeRateScaleUpShift", "nMonetaryValue", "fTractionBiasFront", "fSteeringLock", "fSuspensionUpperLimit", "fSeatOffsetDistX", "fAntiRollBarBiasFront", "fEngineDamageMult", "fOilVolume", "fTractionCurveLateral", "fSuspensionRaise", "fDeformationDamageMult", "fWeaponDamageMult", "fCamberStiffnesss", "fTractionCurveMin", "fSuspensionForce", "fAntiRollBarForce", "fHandBrakeForce", "fSuspensionReboundDamp", "fLowSpeedTractionLossMult", "fRollCentreHeightFront", "fPetrolTankVolume", "fClutchChangeRateScaleDownShift", "fTractionCurveMax", "fInitialDragCoeff", "fSeatOffsetDistY", "fSuspensionLowerLimit"];
    names.forEach(name => {
        let element = document.getElementById(name);
        elements[name] = element;
        element.addEventListener("input", function(){
            let value = Number(element.value);
            if(value)
                Post("update", {
                    target: name,
                    value: value
                });
        })
    });
}

function Add(name){
    let element = elements[name];
    if(element){
        let val = Number(element.value);
        if(typeof val == "number"){
            Post("change", {
                type: "add",
                target: name
            }).then(result => {
                if(result!=false){
                    element.value = result;
                }
            });
        }
    }
}

function Substract(name){
    let element = elements[name];
    if(element){
        let val = Number(element.value);
        if(typeof val == "number"){
            Post("change", {
                type: "substract",
                target: name
            }).then(result => {
                if(result!=false){
                    element.value = result;
                }
            });
        }
    }
}

function Export(){
    let result = handlingTemplate.toString();
    for (const k in elements) {
        result = result.replaceAll(`${k}_value`, elements[k].value);
    }
    let element = document.createElement("textarea");
    element.value = result;
    document.body.appendChild(element);
    element.select();
    document.execCommand("copy");
    document.body.removeChild(element);
}

window.addEventListener("message", function(event){
    let e = event.data;
    if(e.action == "show"){
        for (const k in (e.handling || {})) {
            if(elements[k])
                elements[k].value = e.handling[k];
        }
        Container.style.display = "block";
    }else if(e.action == "hide") {
        Container.style.display = "none";
    }
})

window.addEventListener("keydown", function(e){
    if(e.key=="Escape"){
        Container.style.display = "none";
        Post("close");
    }
})