package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.*;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class PushButton
	 */
	public class PushButton extends Builder 
	{
		public var eventType:String;
		public var actionrepeat:int;
		private var _parent:Sprite;
		public var btnLocation:Point;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	spriteToUse
		 * @param	location
		 * @param	_eventType
		 * @param	repeat
		 */
		public function PushButton(parent:Sprite, spriteToUse:Sprite, location:Point, _eventType:String, repeat:int) 
		{
			var buttonBody:b2Body = createBody(spriteToUse.width, spriteToUse.height, location);
			parent.addChild(spriteToUse);
			spriteToUse.x = location.x * Lacuna.WIDTH + Lacuna.WIDTH;
			spriteToUse.y = location.y * Lacuna.HEIGHT + Lacuna.HEIGHT;
			
			actionrepeat = repeat;
			btnLocation = location;
			eventType = _eventType;
			
			_parent = parent;
			
			super(buttonBody, spriteToUse, false);
		}
		
		/**
		 * @method createBody
		 * @desc creates Box2D body
		 * @param	width
		 * @param	height
		 * @param	location
		 * @return	b2Body
		 */
		private function createBody(width:Number, height:Number, location:Point):b2Body 
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set((location.x * Lacuna.WIDTH + Lacuna.WIDTH) / PhysicsWorld.RATIO, (location.y*Lacuna.HEIGHT + Lacuna.HEIGHT) / PhysicsWorld.RATIO);
			bodyDef.type = b2Body.b2_staticBody;
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox(width / 2 / PhysicsWorld.RATIO, height / 2 / PhysicsWorld.RATIO);
			
			var fixDef:b2FixtureDef = new b2FixtureDef();
			fixDef.shape = shapeDef;
			
			var buttonBody:b2Body = PhysicsWorld.world.CreateBody(bodyDef);
			buttonBody.CreateFixture(fixDef);
			
			return buttonBody;
		}
		
		/**
		 * @method buttonisPushed
		 * @desc called when this button is pushed, currently implemented in Man
		 * TODO: implemet here
		 */
		public function buttonisPushed():void
		{
			
		}
		
		/**
		 * @method sniperDeathAnime
		 * @desc death animation for sniper
		 */
		private function sniperDeathAnime():void
		{
			var bloodAnime:Main = new Main();
			_parent.addChild(bloodAnime);
			for (var i:int = 0; i < Lacuna.allRayCasts.length; i++)
			{
				if ( KillerRayCasts(Lacuna.allRayCasts[i]).currentType == KillerRayCasts.SNIPER)
				{
					bloodAnime.x = KillerRayCasts(Lacuna.allRayCasts[i]).currentSprite.x;
					bloodAnime.y = KillerRayCasts(Lacuna.allRayCasts[i]).currentSprite.y;
				
					TweenLite.to(KillerRayCasts(Lacuna.allRayCasts[i]).currentSprite, 1.5, { alpha:0, scaleX:0, scaleY:0 } );
				}
			}
				
		}
		
		/**
		 * @method removeChildEventListeners
		 * @desc called before destruction
		 */
		override protected function removeChildEventListeners():void 
		{
			MovieClip(_skin).btn.scaleY = 0.1;
			super.removeChildEventListeners();
		}
	}

}