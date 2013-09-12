window.history.forward(1);

document.observe('dom:loaded', function(){
	if (document.referrer.blank())
	{
		if (window.location.href.search(/session\/new|login/) == -1)
		{
			document.body.innerHTML = "Please use the old window..";
		}
	}
});

