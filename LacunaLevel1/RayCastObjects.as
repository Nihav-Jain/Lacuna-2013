package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class RayCastObjects - parent class for ojects represented by Ray Cast 
	 */
	public class RayCastObjects
	{
		private var startPoint:Point;
		private var endPoint:Point;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	_startPoint
		 * @param	_endPoint
		 */
		public function RayCastObjects(parent:Sprite, _startPoint:Point, _endPoint:Point) 
		{

			startPoint = _startPoint;
			endPoint = _endPoint;
			
			var parnt:Sprite = new Sprite();
			parnt.graphics.lineStyle(2, 0xFF0000, 1);
			parnt.graphics.moveTo(startPoint.x, startPoint.y);
			parnt.graphics.lineTo(endPoint.x, endPoint.y);
			parnt.graphics.endFill();
			createRayCast();
		}
		
		/**
		 * @method createRayCase
		 * @desc creates the ray cast for interaction
		 */
		public function createRayCast():void 
		{
			PhysicsWorld.world.RayCast(rayCastCallback, new b2Vec2(startPoint.x / PhysicsWorld.RATIO, startPoint.y / PhysicsWorld.RATIO), new b2Vec2(endPoint.x / PhysicsWorld.RATIO, endPoint.y / PhysicsWorld.RATIO));
		}
		
		/**
		 * @method rayCastCallback
		 * @desc callback when raycast intersects a body
		 * @param	fix
		 * @param	point
		 * @param	normal
		 * @param	fraction
		 * @return	Number
		 */
		private function rayCastCallback(fix:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number 
		{
			if (fix.GetBody().GetUserData() is Man)
			{
				trace("man dead");
				if(this is KillerRayCasts)
					killAnime(KillerRayCasts(this).currentType, point);
				else
					killAnime(1, point);
			}
			return 1;
		}
		
		/**
		 * @method killAnime
		 * @desc to be overriden by child to implement special logic when Man hits this Ray Cast
		 * @param	spriteType
		 * @param	pt
		 */
		protected function killAnime(spriteType:uint, pt:b2Vec2):void 
		{
		
		}
		
	}

}