package  {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class Main extends MovieClip {
		//var s1:MovieClip = new Symbol1();
		var part:Vector.<Particle>;
		
		public function Main() {
			// constructor code
			part = new Vector.<Particle>(450, true);
			
			var i:uint;
			for(i=0; i<450; ++i)
			{
				part[i] = new Particle(Number(i)/450);
				part[i].x = 0;
				part[i].y = 0;
				this.addChild(part[i]);
			}
			this.addEventListener(Event.ENTER_FRAME, func);
		}
		
		private function func(ev:Event):void
		{
			var i:uint;
			for(i=0; i<450; ++i)
			{
				if(part[i].isInit)
				{
					part[i].upda();
					if(part[i].y>Lacuna.STAGE.stageHeight)
					{
						this.removeChild(part[i]);
						part[i].isInit = false;
					}
				}
			}
		}
		
		
	}
	
}
