package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2Bound;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Ladder - climbing ladder
	 */
	public class Ladder extends Builder
	{
		var aabb:b2AABB = new b2AABB();
		public var ladder_collide:Boolean;
		public var lower_pt:b2Vec2;
		public var upper_pt:b2Vec2;
		public var cen_vec:b2Vec2;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @param	fric
		 * @param	resti
		 */
		public function Ladder(parent:DisplayObjectContainer, wid:Number, ht:Number, loacation:Point, fric:Number, resti:Number) 
		{
			var ladderBody:b2Body = createBody(wid, ht, loacation, fric, resti);
			cen_vec = ladderBody.GetWorldCenter();
			var ladderSprite:Sprite = createSprite(wid, ht, loacation);
			trace(ladderSprite);
			lower_pt = new b2Vec2();
			upper_pt = new b2Vec2();
			lower_pt.Set(((loacation.x * Lacuna.WIDTH) + (wid * Lacuna.WIDTH / 2)) / PhysicsWorld.RATIO, (loacation.y * Lacuna.HEIGHT) / PhysicsWorld.RATIO);
			upper_pt.Set(((loacation.x * Lacuna.WIDTH) + (wid * Lacuna.WIDTH / 2)) / PhysicsWorld.RATIO, ((loacation.y * Lacuna.HEIGHT) + (ht * Lacuna.HEIGHT)) / PhysicsWorld.RATIO);
			//trace(ladderSprite);
			parent.addChild(ladderSprite);
			trace("Parent is:"+parent);
			super(ladderBody, ladderSprite, false);
		}
		
		/**
		 * @method createSprite
		 * @desc cretes sprite for the ladder
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @return	Sprite
		 */
		private function createSprite(wid:Number, ht:Number, loacation:Point):Sprite
		{
			var ladderSprite:Sprite = new LadderSprite(wid, ht);
			trace(ladderSprite);
			ladderSprite.x = loacation.x * Lacuna.WIDTH + ladderSprite.width/2;
			ladderSprite.y = loacation.y * Lacuna.HEIGHT + ladderSprite.height/2;
			trace("wall created");
			return ladderSprite;
		}
		
		/**
		 * @method createBody
		 * @desc creates Box2D body
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @param	fric
		 * @param	resti
		 * @return	b2Body
		 */
		private function createBody(wid:Number, ht:Number, loacation:Point, fric:Number, resti:Number):b2Body 
		{
			// create ladder body def
			var ladderBodyDef:b2BodyDef = new b2BodyDef();
			ladderBodyDef.position.Set((loacation.x * Lacuna.WIDTH + wid * Lacuna.WIDTH / 2) / PhysicsWorld.RATIO, (loacation.y * Lacuna.HEIGHT + ht * Lacuna.HEIGHT / 2) / PhysicsWorld.RATIO);
			ladderBodyDef.type = b2Body.b2_kinematicBody;
			
			// add body to the world
			var ladderBody:b2Body = PhysicsWorld.world.CreateBody(ladderBodyDef);
			trace("inside constructor");
			
			// create shape for the body
			var ladderShape:b2PolygonShape = new b2PolygonShape();
			ladderShape.SetAsBox((wid * Lacuna.WIDTH) / 2 / PhysicsWorld.RATIO, (ht * Lacuna.HEIGHT) / 2 / PhysicsWorld.RATIO);
						
			// create fixture def
			var ladderFixtureDef:b2FixtureDef = new b2FixtureDef();
			ladderFixtureDef.shape = ladderShape;
			ladderFixtureDef.density = 0;
			ladderFixtureDef.friction = fric;
			ladderFixtureDef.restitution = resti;
			ladderBody.CreateFixture(ladderFixtureDef);
				
			return ladderBody;
		}
		
		/**
		 * @method getBody
		 * @desc getter for b2Body
		 * @return b2Body
		 */
		public function getBody():b2Body {
			return _body;
		}

	}

}