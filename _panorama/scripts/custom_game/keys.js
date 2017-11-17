function OnNettableChanged( table_name, key, data )
{
	//$.Msg( "Table ", table_name, " changed: '", key, "' = ", data );
	
	if(key == "dist_good" || key == "dist_bad")
	{	
		var percent = data.value*100;
		$.Msg("percent:"+ percent + "%");
		if($( "#progress" ) != null)
			$( "#progress" ).style.width = percent+"%";
	}
}


(function()
{
	CustomNetTables.SubscribeNetTableListener( "game", OnNettableChanged );
})();

