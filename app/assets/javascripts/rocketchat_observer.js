const rocketChatIframe = { rcAvailableInIframe: false, iframeLoad: false, url: '' }

const handler = () => {
  return {
    set: function (target, key, value) {
      target[key] = value;
      if (target.rcAvailableInIframe && target.iframeLoad && window.iframeEl.src.length !== target.url.length) {
        console.log(target)
        window.iframeEl.src = target.url
        document.querySelector('.js-rocketchat-icon').classList.remove('display-none')
      }
      return true;
    }
  }
}
const rocketChatProxy = new Proxy(rocketChatIframe, handler());
