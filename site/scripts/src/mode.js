import store from 'store';

function setEmoji() {
    const mode = {
        light: '🌚',
        dark: '🌞',
    }

    document.getElementById('toggler').innerText = mode[store.get('mode')];
}

function toggle() {
    const mode = store.get('mode') || 'light';
    store.set('mode', mode === 'light' ? 'dark' : 'light');

    init();
}

function init() {
    const mode = store.get('mode') || 'light';
    document.body.className = mode;

    document.getElementById('toggler').addEventListener('click', toggle);

    setEmoji();
}

export default { init, toggle, setEmoji };
