package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class MovingPlatform
	 */
	public class MovingPlatform extends Builder 
	{
		private var startVal:Number;
		private var endVal:Number;
		private var constVal:Number;
		private var horizontal:uint;
		
		public static const HORIZONTAL:uint = 1;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	wid
		 * @param	ht
		 * @param	_constVal
		 * @param	_startVal
		 * @param	_endVal
		 * @param	_horizontal
		 * @param	vel
		 * @param	fric
		 */
		public function MovingPlatform(parent:Sprite, wid:Number, ht:Number, _constVal:Number, _startVal:Number, _endVal:Number, _horizontal:uint, vel:Number, fric:Number ) 
		{
			if(horizontal == HORIZONTAL)
			{
				this.startVal = (_startVal * Lacuna.WIDTH + wid * Lacuna.WIDTH / 2);
				this.endVal = (_endVal * Lacuna.WIDTH - wid * Lacuna.WIDTH / 2) ;
				this.constVal = _constVal * Lacuna.WIDTH + ht*Lacuna.HEIGHT/2;
				this.horizontal = _horizontal;
			}
			else
			{
				this.startVal = (_startVal * Lacuna.HEIGHT + ht * Lacuna.HEIGHT / 2);
				this.endVal = (_endVal * Lacuna.HEIGHT - ht * Lacuna.HEIGHT / 2) ;
				this.constVal = _constVal * Lacuna.WIDTH + wid * Lacuna.WIDTH/2;
				this.horizontal = _horizontal;
			}
			var platformBody:b2Body = createBody(wid, ht, vel, fric);
			var platformSprite:Sprite = new WallSprite(wid, ht);
			
			parent.addChild(platformSprite);
			
			super(platformBody, platformSprite, false);
		}
		
		/**
		 * @method createBody
		 * @desc create Box2D body
		 * @param	wid
		 * @param	ht
		 * @param	vel
		 * @param	fric
		 * @return	b2Body
		 */
		private function createBody(wid:Number, ht:Number, vel:Number, fric:Number):b2Body
		{
			var platformBodyDef:b2BodyDef = new b2BodyDef();
			if (horizontal == HORIZONTAL)
				platformBodyDef.position.Set(startVal / PhysicsWorld.RATIO, constVal / PhysicsWorld.RATIO);
			else	
				platformBodyDef.position.Set(constVal / PhysicsWorld.RATIO, startVal / PhysicsWorld.RATIO);
			platformBodyDef.type = b2Body.b2_kinematicBody;
						
			var platformShape:b2PolygonShape = new b2PolygonShape();
			platformShape.SetAsBox((wid *Lacuna.WIDTH) / 2 / PhysicsWorld.RATIO, (ht * Lacuna.HEIGHT) / 2 / PhysicsWorld.RATIO);
			
			var platformFixtureDef:b2FixtureDef = new b2FixtureDef();
			platformFixtureDef.shape = platformShape;
			platformFixtureDef.friction = fric;
			
			var platformBody:b2Body = PhysicsWorld.world.CreateBody(platformBodyDef);
			platformBody.CreateFixture(platformFixtureDef);
			
			if (horizontal == HORIZONTAL)
				platformBody.SetLinearVelocity(new b2Vec2(vel, 0));
			else
				platformBody.SetLinearVelocity(new b2Vec2(0, vel));
			
			return platformBody;
		}
		
		/**
		 * @method childSpecificUpdating
		 * @desc called in GAME LOOP to update direction of motion
		 */
		override protected function childSpecificUpdating():void 
		{
			var speed:Number;
			var pos:Number;
			if (horizontal)
			{
				pos = _body.GetPosition().x * PhysicsWorld.RATIO;
				speed = _body.GetLinearVelocity().x;
				
				if ((pos < startVal && speed < 0) || (pos > endVal && speed > 0))
					speed *= -1;
				_body.SetLinearVelocity(new b2Vec2(speed, 0));	
			}
			else
			{
				pos = _body.GetPosition().y * PhysicsWorld.RATIO;
				speed = _body.GetLinearVelocity().y;
				
				if ((pos > startVal && speed > 0) || (pos < endVal && speed < 0))
					speed *= -1;
				_body.SetLinearVelocity(new b2Vec2(0, speed));	
			}
			
			super.childSpecificUpdating();
			
		}
		
	}

}