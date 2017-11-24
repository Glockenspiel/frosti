function OnGameChanged( table_name, key, data )
{
	//$.Msg( "Table ", table_name, " changed: '", key, "' = ", data );
	
	if(key == "dist_good" || key == "dist_bad")
	{	
		var percent = data.value*100;
		//$.Msg("percent:"+ percent + "%");
		if($( "#progress" ) != null)
			$( "#progress" ).style.width = percent+"%";
			
		var percentText = percent.toFixed(0) + "%";
		if(key == "dist_good")
		{
			$("#goodguysScoreText").text = percentText
		}
		else if(key == "dist_bad")
		{
			$("#badguysScoreText").text = percentText;
		}
	}
	else if(key == "round")
	{
		if(data.value == 2)
		{
			$( "#progress" ).style.width = "0%";
		}
	}
	else if(key == "units_pushing")
	{
		if(data.value == 0 )
		{
			$("#unitsPushingText").text = "-";
		}
		else
			$("#unitsPushingText").text = "► " + data.value;
	}
}

function OnGameStateChange( table_name, key, data )
{
	if(key=="time")
	{
		var time = data.value;
		var secs = Math.abs(time%60);
		var mins = time/60;
		
		var timeStr = "";
		
		if(mins<0)
		{
			mins = Math.ceil(mins);
			timeStr+="-";
		}
		else
			mins = Math.floor(mins);
		
		
		
		timeStr += mins + ":";
		
		if(secs<10)
			timeStr += "0"+secs;
		else
			timeStr += secs;
		
		if($("#Timertext") !=null)
			$("#Timertext").text = timeStr;
	}
	else 
	{
		$.Msg("state:" + data.value)
	}
}


(function()
{
	CustomNetTables.SubscribeNetTableListener( "game", OnGameChanged );
	CustomNetTables.SubscribeNetTableListener( "gamestate", OnGameStateChange );
})();

