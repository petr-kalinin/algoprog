target = document.getElementById('main');

observer = new MutationObserver (mutations) ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub]);

config =
    attributes: true,
    childList: true,
    characterData: true,
    subtree: true

observer.observe target, config

export default observer
