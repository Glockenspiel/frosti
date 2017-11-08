function WrapFunction(name) {
    return function() {
        Game[name]();
    };
}

//var key = Game.GetKeybindForAbility(0)
//$.Msg( "key:" + key );
//Game.CreateCustomKeyBind(key, 'KeyInventoryToggle');
//Game.AddCommand('KeyInventoryToggle', WrapFunction('KeyInventoryToggle'), '', 0);

Game.KeyInventoryToggle = function()
{
	$.Msg( "Hello, world!" );
	if(GameUI.IsMouseDown(0))
	{
		$.Msg( "mouse down" );
	}
};

// This is an example of how to use the GameUI.SetMouseCallback function
GameUI.SetMouseCallback( function( eventName, arg ) {
	var CONSUME_EVENT = true;
	var CONTINUE_PROCESSING_EVENT = false;
	
	if ( GameUI.GetClickBehaviors() === CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_VECTOR_CAST ){
		//$.Msg( "vector targeting started" );
		var pos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
		//$.Msg( pos );
		GameEvents.SendCustomGameEventToServer("start_vector_target", {"point":  pos });
	}

	// if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE ){
		// return CONTINUE_PROCESSING_EVENT;
	// }
	
	// if(GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_CAST){
		// $.Msg( "mouse drag" );
	// }
	
	// if ( eventName == "pressed" )
	// {
		// // Left-click is move to position
		// if ( arg === 0 )
		// {
			// $.Msg( "mouse clicked" );
			// //'var order = {};
			// //order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_POSITION;
			// //order.Position = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
			// //order.Queue = false;
			// //order.ShowEffects = false;
			// //Game.PrepareUnitOrders( order );
			// //return CONSUME_EVENT;
		// }

		// // Disable right-click
		// //if ( arg === 1 )
		// //{
			// //return CONSUME_EVENT;
		// //}
	// }
	return CONTINUE_PROCESSING_EVENT;
} );