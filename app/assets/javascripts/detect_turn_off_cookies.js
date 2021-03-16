window.rcAvailableInIframe = false;
window.addEventListener('message', function(e) {

	if(e.data.eventName == 'startup' && e.data.data == true ){
		// console.log(e.data.eventName); // event name
		// console.log(e.data.data); // event data
		window.rcAvailableInIframe = true;
	}


});
