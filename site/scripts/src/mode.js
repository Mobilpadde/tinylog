import store from 'store';

function init() {
    const mode = store.get('mode') || 'light';
    document.body.className = mode;
}

function toggle() {
    const mode = store.get('mode') || 'light';
    store.set('mode', mode === 'light' ? 'dark' : 'light');

    init();
}

export default { init, toggle };
