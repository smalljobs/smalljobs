function setHelp() {
    $.post("/context_help", {current_url: window.location.href}, function (response) {
        var $helpModalContent = $('#helpModalContent');
        var $helpModalTitle = $('#helpModalTitle');
        var $helpButton = $('#helpButton');
        if(response['description'] !== null) {
            $helpModalContent.html(response['description']);
            $helpModalTitle.html(response['title']);
            $helpButton.removeClass('display-none');
        } else {
            $helpButton.addClass('display-none');
        }
    });
}
$(document).ready(function(){
    setHelp();
});
