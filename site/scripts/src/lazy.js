import cheerio from 'cheerio';

let n = 20181022;
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

window.addEventListener('load', () => {
    load(n++)
        .then(() => document
            .getElementById("list")
            .addEventListener('scroll', ({ target }) => {
                if (status === 200) {
                    if (target.scrollTopMax - 10 <= target.scrollTop) {
                        load(n++);
                    }
                }
            })
        )
        .catch(console.error);
});
