package  
{
	import Box2D.Common.Math.b2Vec2;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class KillerRayCasts - ray casts that can kill the Man on contact
	 */
	public class KillerRayCasts extends RayCastObjects 
	{
		public static const CAMERA:uint = 1;
		public static const SNIPER:uint = 2;
		public static const LASER:uint 	= 3;
		public var flag:Boolean;
		
		public var currentType:uint;
		public var currentSprite:Sprite;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	spriteType
		 * @param	location
		 * @param	_startPoint
		 * @param	_endPoint
		 */
		public function KillerRayCasts(parent:Sprite, spriteType:int, location:Point, _startPoint:Point, _endPoint:Point) 
		{
			var killerSprite:Sprite = createSprite(spriteType, _startPoint, _endPoint);
			parent.addChild(killerSprite);
			killerSprite.x = location.x * Lacuna.WIDTH + killerSprite.width/2;
			killerSprite.y = location.y * Lacuna.HEIGHT + killerSprite.height / 2;
			if (spriteType == SNIPER)
			{
				killerSprite.x -= 175;
				killerSprite.y -= 160;
				killerSprite.width *= 0.35;
				killerSprite.height *= 0.35;
			}
			currentType = spriteType;
			currentSprite = killerSprite;
			flag = true;
			var offset:Number = 0;
			
			if ((spriteType == LASER) && (_startPoint.y == _endPoint.y)) 
			{
				offset = laser_container(killerSprite).giveMeY();
			}
			offset += 0;//Lacuna.HEIGHT / 2;
			super(parent, new Point(_startPoint.x * Lacuna.WIDTH  , _startPoint.y * Lacuna.HEIGHT + offset), new Point(_endPoint.x * Lacuna.WIDTH, _endPoint.y * Lacuna.HEIGHT + offset));
		}
		
		/**
		 * @method createSprite
		 * @desc creates sprite for given ray cast type
		 * @param	spriteType
		 * @param	stPoint
		 * @param	endPoint
		 * @return	Sprite
		 */
		private function createSprite(spriteType:uint, stPoint:Point, endPoint:Point):Sprite
		{
			var killerSprite:Sprite = new Sprite();
			if (spriteType == CAMERA)
			{
				killerSprite = new Camera();
			}
			else if (spriteType == SNIPER)
			{
				killerSprite = new FullSniper();
			}
			else if (spriteType == LASER)
			{
				if(stPoint.x == endPoint.x) {
					killerSprite = new laser_container(stPoint.y - endPoint.y + 1,0,0,true, false );
				}
				else if (stPoint.y == endPoint.y){
					killerSprite = new laser_container(endPoint.x-stPoint.x,0,0,false, true );
				}
			}
			return killerSprite;
		}
		
		/**
		 * @method killAnime
		 * @desc initiates the death animation for this
		 * @param	spriteType
		 * @param	pt
		 */
		override protected function killAnime(spriteType:uint, pt:b2Vec2):void 
		{
			
			if (spriteType == KillerRayCasts.SNIPER)
			{
				Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length - 1]).killedBySniper(this);
			}
			
			else if (spriteType == KillerRayCasts.CAMERA)
			{
				Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length-1]).sirenblare();
			}
			
			else if (spriteType == KillerRayCasts.LASER)
			{
				Man.lacunaInstance.pauseGame();
				Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length-1]).electricShock();
			}
			super.killAnime(spriteType, pt);
		}
		
		
		private function restartGame():void 
		{
			
		}
		
	}

}