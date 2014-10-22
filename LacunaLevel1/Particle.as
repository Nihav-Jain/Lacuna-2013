package  {
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.text.TextField;
	
	public class Particle extends Sprite{
		private var xvel:Number;
		private var yvel:Number;
		private var zvel:Number;
		public var isInit:Boolean;
		public var xgrav:Number;
		public static const grav:Number = 0.4;

		public function Particle(tim:Number) {
			// constructor code
			this.graphics.beginFill(0xCC0000);
			this.graphics.lineStyle(0,0x000000,0);
			this.graphics.drawEllipse(25,25,5+10*Math.random(),5+10*Math.random());
			this.graphics.endFill();
			
			this.yvel = 8*Math.random() - 4;
			if(this.yvel < 0)
			{
				this.xvel = -3 + Math.random()*6;
				if(this.xvel<0)
					this.xvel += this.yvel;
				else
					this.xvel -= this.yvel;
			}
			else
				this.xvel = -8 + Math.random()*16;
			this.zvel = -5*Math.random();
			if(this.xvel>5)
				this.xgrav = -0.1*Math.random();
			else if(this.xvel<5)
				this.xgrav = +0.1*Math.random();
			this.visible = false;
			isInit = false;
			TweenLite.delayedCall(tim, init);
		}
		
		private function init():void
		{
			isInit = true;
			this.visible = true;
			
		}
		
		public function upda():void
		{
			this.x += this.xvel;
			this.y += this.yvel;
			this.z += this.zvel;
			
			this.yvel += grav;
			this.xvel += xgrav;
		}

	}
	
}
