import mode from './mode';

window.addEventListener('load', async () => {
    mode.init();
    window.toggle = mode.toggle;
});
