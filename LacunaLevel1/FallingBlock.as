package 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import com.greensock.*;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class FallingBlock - represents a block which can crush the Man
	 */
	public class FallingBlock extends Builder 
	{
		var destroyMyself:Boolean;
		/**
		 * @constructor
		 */
		public function FallingBlock()
		{
			var rockSprite:Sprite = createKSprite();
			var rockBody:b2Body = createRBody(rockSprite.width, rockSprite.height, new Point(4, 4));
			Man.lacunaInstance.addChild(rockSprite);
			rockSprite.x = 4 * Lacuna.WIDTH + Lacuna.WIDTH / 2;
			rockSprite.y = 3 * Lacuna.HEIGHT + Lacuna.HEIGHT / 2;
			super(rockBody, rockSprite, false);			
			destroyMyself = false;
		}
		
		/**
		 * @method createKSprite
		 * @desc creates Sprite for this block
		 * @return Sprite
		 */
		private function createKSprite():Sprite
		{
			var killerSprite:Sprite = new Sprite();
			killerSprite.width = 80;
			killerSprite.height = 80;
			killerSprite = new Dropbox();				
				
			return killerSprite;
		}
		
		/**
		 * @method createRBody
		 * @desc creates a Box2D body
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @return
		 */
		private function createRBody(wid:Number, ht:Number, loacation:Point):b2Body
		{
			// create body def
			var killerBodyDef:b2BodyDef = new b2BodyDef();
			killerBodyDef.position.Set((loacation.x*Lacuna.WIDTH + Lacuna.WIDTH/2) / PhysicsWorld.RATIO, (loacation.y*Lacuna.HEIGHT + Lacuna.HEIGHT/2) / PhysicsWorld.RATIO);
			killerBodyDef.type = b2Body.b2_dynamicBody;
			
			// create body
			var killerBody:b2Body = PhysicsWorld.world.CreateBody(killerBodyDef);
			
			// create shape
			var killerShape:b2PolygonShape = new b2PolygonShape();
			killerShape.SetAsBox(wid / 2 / PhysicsWorld.RATIO, ht / 2 / PhysicsWorld.RATIO);
			
			// create fixture def
			var killerFixtureDef:b2FixtureDef = new b2FixtureDef();
			killerFixtureDef.shape = killerShape;
			killerFixtureDef.density = 0;
			killerBody.CreateFixture(killerFixtureDef);
					
			return killerBody;
		}
		
		/**
		 * @method moveRockSkin
		 * @desc animation for falling
		 */
		public function moveRockSkin():void
		{
			TweenLite.to(_skin, 0.5, { y:_skin.y + 80, onComplete:gamePauser} );
		}
		
		/**
		 * @method gamePauser
		 * @desc caller for pausing game
		 */
		private function gamePauser():void
		{
			Man.lacunaInstance.pauseGame();
		}
		
		/**
		 * @method setDestroyFlag
		 * @desc sets the destroy flag for this block
		 */
		public function setDestroyFlag():void
		{
			destroyMyself = true;
		}
		
		/**
		 * @method childSpecificUpdating
		 * @desc specific updatting in GAME LOOP
		 */
		override protected function childSpecificUpdating():void 
		{
			if (destroyMyself == true)
				this.destroy();
			super.childSpecificUpdating();
		}
		
	}
	
}