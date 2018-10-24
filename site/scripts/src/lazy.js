import cheerio from 'cheerio';

function load(n) {
    return new Promise((resolve, reject) =>
        fetch(`/log/${n}`)
            .then((res) => res.text())
            .then(cheerio.load)
            .then(($) => {
                const d = document.createElement('span');
                d.className = 'date';
                d.innerText = n.replace(/(?:(\d{4})(\d{2})(\d{2}))/g, "$2/$3/$1");

                document.getElementById("list").appendChild(d)
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
