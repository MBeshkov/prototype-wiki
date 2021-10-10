
function ResultsBar(search, results){
	$( search ).on("keyup", function(){
		var searchValue = $(this).val().toUpperCase();
		$( results ).filter(function(){
			$(this).toggle($(this).text().toUpperCase().indexOf(searchValue) > -1);
		});
	});
};

$( document ).ready(function() {

	//SEARCH BAR
	ResultsBar("#searchBar", "#pageList li");

	//LINKS FOR THE PAGES OF THE WIKI
	$(" #pageList li ").click(function() {
		var bar = $(this).text();
		$(location).attr('href', '/display/'+bar)
	});

	//SMOOTH SCROLLING FOR ANCHOR LINK HOMEPAGE
 	$("#relativelink").on('click', function(event) {
    	$('html, body').animate({
    		scrollTop: $("#redirect").offset().top
    	}, 1100);
  	});
});	