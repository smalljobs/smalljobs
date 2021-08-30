var rocketChatIframe = { rcAvailableInIframe: false, iframeLoad: false };
var handler = function () {
	return {
		set: function (target, key, value) {
			target[key] = value;
			if (target.rcAvailableInIframe && target.iframeLoad) {
				var rocketChatIcon = document.querySelector('.js-rocketchat-icon');
				if (rocketChatIcon) {
            rocketChatIcon.classList.remove('display-none');
				}
			}
			return true;
		}
	};
};
var rocketChatProxy = new Proxy(rocketChatIframe, handler());
