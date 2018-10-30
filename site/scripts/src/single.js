import cheerio from 'cheerio';

import mode from './mode';

function getDir(dir) {
    const nav = document.getElementById(dir);
    const body = cheerio
        .load(document.body.outerHTML)('#tinylog ul >a:first-child')
        .attr('data-date');

    return new Promise((resolve) =>
        fetch(`/${dir}`, {
            method: 'POST',
            body,
        })
            .then((res) => {
                if (res.status !== 200) {
                    nav.style.display = 'none';
                    resolve();
                }

                return res.json();
            })
            .then((res) => {
                nav.href = `/log/${res}`;
                resolve();
            })
    )
}

window.addEventListener('load', async () => {
    mode.init();
    window.toggle = mode.toggle;

    await getDir('next');
    await getDir('prev');
});
