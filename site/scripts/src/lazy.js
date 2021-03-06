import cheerio from 'cheerio';

import mode from './mode';

let idx = -1;
let all = [];
let fin = false;

function load() {
    return new Promise((resolve, reject) =>
        fetch('/all')
            .then((res) => res.json())
            .then(resolve)
            .catch(reject)
    )
}

function next() {
    return new Promise((resolve, reject) => {
        const n = ++idx;

        if (n < all.length) {
            fetch(`/log/${all[n]}`)
            .then((res) => res.text())
            .then(cheerio.load)
            .then(($) => {
                $('#tinylog ul >.date:last-child').remove();

                document
                    .getElementById('list')
                    .innerHTML += $('#tinylog ul').html();
                resolve();
            })
            .catch(reject)
        } else {
            if (!fin) {
                fin = true;

                const end = document.createElement('span');
                end.className = 'date';
                end.innerText = 'fin';

                document.getElementById('list').appendChild(end);
                reject('No more entries');
            }
        }
    })
}

function scroller({ target }) {
    if (target.scrollTopMax - 10 <= target.scrollTop) {
        next();
    }
}

function fetchForHeight() {
    return new Promise(async (resolve) => {
        let tl = document.querySelector('#tinylog #list');
        let scroll = tl.scrollTopMax;

        while (scroll === 0) {
            await next();

            scroll = tl.scrollTopMax;
        }

        resolve();
    });
}

window.addEventListener('load', async () => {
    mode.init();
    window.toggle = mode.toggle;
    
    const _all = await load();
    all = _all;
    
    await next();
    await fetchForHeight();

    document
        .getElementById('list')
        .addEventListener('scroll', scroller);
});
