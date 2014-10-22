package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class PushButtonEvent extends Event 
	{
		public static const BUTTON_PUSHED:String = "ButtonPushed";
		public function PushButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PushButtonEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PushButtonEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}