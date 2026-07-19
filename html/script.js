const hud = document.getElementById('hud');
const healthFill = document.getElementById('healthFill');
const armorFill = document.getElementById('armorFill');
const healthVal = document.getElementById('healthVal');
const armorVal = document.getElementById('armorVal');
const waypoint = document.getElementById('waypoint');
const distanceEl = document.getElementById('distance');
const etaEl = document.getElementById('eta');

function clampPct(n) {
    const v = Number(n);
    if (Number.isNaN(v)) return 0;
    return Math.max(0, Math.min(100, v));
}

function updateBars(data) {
    const hp = clampPct(data.health);
    const ar = clampPct(data.armor);

    healthFill.style.width = hp + '%';
    armorFill.style.width = ar + '%';
    healthVal.textContent = Math.round(hp) + '%';
    armorVal.textContent = Math.round(ar) + '%';

    if (hp <= 25) {
        healthFill.classList.add('low');
    } else {
        healthFill.classList.remove('low');
    }

    if (data.waypoint) {
        waypoint.classList.remove('hidden');
        distanceEl.textContent = data.distance || '—';
        etaEl.textContent = data.eta || '--:--';
    } else {
        waypoint.classList.add('hidden');
        distanceEl.textContent = '—';
        etaEl.textContent = '--:--';
    }
}

window.addEventListener('message', function (event) {
    const data = event.data || {};
    if (data.action === 'visible') {
        if (data.show) {
            hud.classList.remove('hidden');
        } else {
            hud.classList.add('hidden');
        }
        return;
    }
    if (data.action === 'update') {
        hud.classList.remove('hidden');
        updateBars(data);
    }
});
