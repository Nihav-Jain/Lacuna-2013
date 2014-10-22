package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class LadderSprite extends Sprite
	{
		
		public function LadderSprite(wid:Number, hei:Number) 
		{
			this.graphics.beginFill(0x000000);
			////trace("Making a rect");
			this.graphics.drawRect (( -wid / 2) * Lacuna.WIDTH, ( -hei / 2) * Lacuna.HEIGHT, wid * Lacuna.WIDTH, hei * Lacuna.HEIGHT);
			this.graphics.endFill();
		}
		
	}

}