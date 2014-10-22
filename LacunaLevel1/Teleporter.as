package 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Teleporter
	 */
	public class Teleporter extends Builder 
	{		
		public var pair:Teleporter;
		private var pairindx:uint;
		private var loc:Point;
		private var point1:Point;
		private var point2:Point;
		private var wid:Number;
		private var ht:Number;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	location
		 * @param	fric
		 * @param	resti
		 * @param	pair_index
		 */
		public function Teleporter(parent:DisplayObjectContainer, location:Point, fric:Number, resti:Number, pair_index:uint)
		{
			pairindx = pair_index;
			ht = 22 / Lacuna.HEIGHT;
			wid = 100 / Lacuna.WIDTH;
		
			var platform:b2Body = createBody(wid, ht, location, fric, resti);
			var platformSprite:Sprite = createSprite(wid, ht, location);
			
			parent.addChild(platformSprite);
			
			point1 = new Point();
			point1.x = platform.GetPosition().x * PhysicsWorld.RATIO;//platformSprite.x/PhysicsWorld.RATIO;//(location.x * Lacuna.WIDTH + 35) / PhysicsWorld.RATIO;
			point1.y = platform.GetPosition().y * PhysicsWorld.RATIO - 50;//(platformSprite.y - platformSprite.height / 2) / PhysicsWorld.RATIO;//(location.y + 0.5) * Lacuna.HEIGHT / PhysicsWorld.RATIO;
			
			point2 = new Point();
			point2.x = platformSprite.x/PhysicsWorld.RATIO;//(location.x * Lacuna.WIDTH + 35) / PhysicsWorld.RATIO;
			point2.y = (platformSprite.y - platformSprite.height / 2) / PhysicsWorld.RATIO;//(location.y + 0.5) * Lacuna.HEIGHT / PhysicsWorld.RATIO;
			
			trace(platformSprite.x);
			trace(platformSprite.y);
			//wallSprite.visible = false;
			
			loc = new Point(point1.x, point1.y - 50);
			super(platform, platformSprite, false);			
						
		}
		
		/**
		 * @method createSprite
		 * @desc creates sprite for teleporter
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @return Sprite
		 */
		private function createSprite(wid:Number, ht:Number, loacation:Point):Sprite
		{
			var platformSprite:Sprite = new TeleporterSprite();
			platformSprite.x = (loacation.x * Lacuna.WIDTH + Lacuna.WIDTH/2);
			platformSprite.y = (loacation.y + 1) * Lacuna.HEIGHT; //+ Lacuna.HEIGHT );
			
			return platformSprite;
		}
		
		/**
		 * @method createBody
		 * @desc creates body
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @param	fric
		 * @param	resti
		 * @return
		 */
		private function createBody(wid:Number, ht:Number, loacation:Point, fric:Number, resti:Number):b2Body 
		{
			// create body def
			var platformBodyDef:b2BodyDef = new b2BodyDef();
			platformBodyDef.position.Set((loacation.x*Lacuna.WIDTH + Lacuna.WIDTH/2) / PhysicsWorld.RATIO, ((loacation.y + 1) * Lacuna.HEIGHT - 22/2 ) / PhysicsWorld.RATIO);
			platformBodyDef.type = b2Body.b2_staticBody;
			
			// create body
			var platformBody:b2Body = PhysicsWorld.world.CreateBody(platformBodyDef);
			
			// create shape
			var platformShape:b2PolygonShape = new b2PolygonShape();
			platformShape.SetAsBox((wid * Lacuna.WIDTH) / 2 / PhysicsWorld.RATIO, (ht * Lacuna.HEIGHT) / 2 / PhysicsWorld.RATIO);
			
			// create fixture def
			var platformFixtureDef:b2FixtureDef = new b2FixtureDef();
			platformFixtureDef.shape = platformShape;
			platformFixtureDef.density = 0;
			platformFixtureDef.friction = fric;
			platformFixtureDef.restitution = resti;
			platformBody.CreateFixture(platformFixtureDef);
				
			return platformBody;
		}
		
		/**
		 * @method setPair
		 * @desc sets the paired(target) teleporter
		 * @param	t
		 */
		public function setPair(t:Teleporter):void
		{
			pair = t;
		}
		
		/**
		 * @method getPair
		 * @desc getter for pair teleporter
		 * @return Teleporter
		 */
		public function getPair():Teleporter
		{
			return pair;
		}
		
		/**
		 * @method retP1
		 * @desc vector for left boundary of teleporter
		 * @return b2Vec2
		 */
		public function retP1():b2Vec2
		{
			var PointVec:b2Vec2 = new b2Vec2();
			PointVec.Set(point1.x/PhysicsWorld.RATIO, point1.y/PhysicsWorld.RATIO);
			return PointVec;
		}
		
		/**
		 * @method retP2
		 * @desc vector for right boundary of teleporter
		 * @return b2Vec2
		 */
		public function retP2():b2Vec2
		{
			var PointVec:b2Vec2 = new b2Vec2();
			PointVec.Set(point2.x/PhysicsWorld.RATIO, point2.y/PhysicsWorld.RATIO);
			return PointVec;
		}
		
		/**
		 * @method animate
		 * @desc teleport animation
		 * @param	sp
		 * @param	s
		 */
		public function animate(sp:Sprite,s:String):void
		{
			var animation:TeleportAnimation = new TeleportAnimation(sp);
			animation.animate(s);
		}
		
		/**
		 * @method retLoc
		 * @desc getter for teleporter location
		 * @return Point
		 */
		public function retLoc():Point
		{
			return loc;
		}
		
		/**
		 * @method retPairIndex
		 * @desc getter for array index of paired Teleporter
		 * @return uint
		 */
		public function retPairIndex():uint
		{
			return pairindx;
		}
		
	}
	
}