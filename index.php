<!DOCTYPE html>
<html>
<head>
    <title>Hello Web - Accessing JavaScript from Processing</title>
    <script src="processing.js"></script>
    <link rel="stylesheet" href="custom.css" type="text/css" />
</head>
<body onresize="resizeCanvas();">
    <div id="msg">
    </div>
    <canvas data-processing-sources="japanese.pde"></canvas>
    <script type="application/javascript">
        var SCREEN_WIDTH = window.innerWidth;
        var SCREEN_HEIGHT = window.innerHeight;
		function resizeCanvas()
			{
				SCREEN_WIDTH = window.innerWidth;
				SCREEN_HEIGHT = window.innerHeight;
			}        
   </script>
</body>
</html>