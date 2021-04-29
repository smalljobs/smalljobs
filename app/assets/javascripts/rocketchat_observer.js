const rocketChatIframe = { rcAvailableInIframe: false, iframeLoad: false, url: '' }

const handler = () => {
  return {
    set: function (target, key, value) {
      target[key] = value;
      if (target.rcAvailableInIframe && target.iframeLoad && window.iframeEl.src.length !== target.url.length) {
        window.iframeEl.src = target.url
        const rocketChatIcon = document.querySelector('.js-rocketchat-icon')
        if (rocketChatIcon) {
          rocketChatIcon.classList.remove('display-none')
        }
      }
      return true;
    }
  }
}
const rocketChatProxy = new Proxy(rocketChatIframe, handler());
