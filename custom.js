$(document).ready(function() {
	
	
	var canvas = $('#draw')[0];
	var context = canvas.getContext('2d');
	context.canvas.width = $(window).width();
	context.canvas.height = $(window).height();
    context.font = 'italic 40pt Calibri';
    context.fillText('Hello World!', canvas.width/2, canvas.height/2);  


      
}
	
	
	
);
      