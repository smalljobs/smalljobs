var rocketChatIframe = { rcAvailableInIframe: false, iframeLoad: false, url: '' };
var handler = function () {
	return {
		set: function (target, key, value) {
			target[key] = value;
			if (target.rcAvailableInIframe && target.iframeLoad && window.iframeEl.src.length !== target.url.length) {
				window.iframeEl.src = target.url;
				var rocketChatIcon = document.querySelector('.js-rocketchat-icon');
				if (rocketChatIcon) {
				  setTimeout(function () {
            rocketChatIcon.classList.remove('display-none');
          }, 3000)
				}
			}
			return true;
		}
	};
};
var rocketChatProxy = new Proxy(rocketChatIframe, handler());
