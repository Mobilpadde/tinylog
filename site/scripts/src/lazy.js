import cheerio from 'cheerio';

function load(n) {
    return new Promise((resolve, reject) =>
        fetch(`/log/${n}`)
            .then((res) => res.text())
            .then(cheerio.load)
            .then(($) => {
                document.getElementById("list").innerHTML += $('#tinylog ul').html();
                resolve();
            })
            .catch(reject)
    )
}

window.addEventListener('load', () => {
    load('20181022')
        .then(() => document
            .getElementById("list")
            .addEventListener('scroll', ({ target }) => {
                if (target.scrollTopMax - 10 <= target.scrollTop) {
                    load('20181023');
                }
            })
        )
        .catch(console.error);
});
