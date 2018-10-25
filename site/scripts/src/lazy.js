import cheerio from 'cheerio';

const d = new Date();
let n = `${d.getFullYear()}${d.getMonth() + 1}${d.getDate()}`;
let status = 200;

function load(n) {
    return new Promise((resolve, reject) =>
        fetch(`/log/${n}`)
            .then((res) => {
                status = res.status;
                if (status !== 200) throw new Error(status);

                return res.text();
            })
            .then(cheerio.load)
            .then(($) => {
                document.getElementById("list").innerHTML += $('#tinylog ul').html();
                resolve();
            })
            .catch(reject)
    )
}

function scroller({ target }) {
    if (status === 200) {
        if (target.scrollTopMax - 10 <= target.scrollTop) {
            load(n--);
        }
    }
}

function fetchForHeight() {
    const tl = document.querySelector('#tinylog #list');
    const mHeight = parseInt(window.getComputedStyle(tl)['max-height']);
    if (tl.clientHeight < mHeight) {
        load(n--);
    }
}

window.addEventListener('load', () => {
    load(n--)
        .then(() => {
            fetchForHeight(); 
            document
                .getElementById("list")
                .addEventListener('scroll', scroller);
        })
        .catch(console.error);
});
