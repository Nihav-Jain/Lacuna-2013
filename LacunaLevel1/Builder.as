package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import com.greensock.*;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Builder - parent class for any kind of body
	 */
	public class Builder extends EventDispatcher
	{
		protected var _body:b2Body;
		protected var _skin:Sprite;
		protected var _collectable:Boolean;
		
		/**
		 * @constructor
		 * @param	body
		 * @param	skin
		 * @param	collectable
		 */
		public function Builder(body:b2Body, skin:Sprite, collectable:Boolean) 
		{
			_body = body;
			_skin = skin;
			_body.SetUserData(this);
			
			_collectable = collectable;
			updateAttribs();
		}
			
		/**
		 * @method updateAttribs
		 * @desc updates position and rotation of skin according to body
		 */
		private function updateAttribs():void 
		{
			_skin.x = _body.GetPosition().x * PhysicsWorld.RATIO;
			_skin.y = _body.GetPosition().y * PhysicsWorld.RATIO;
			_skin.rotation = _body.GetAngle() * 180 / Math.PI;
		}
		
		/**
		 * @method updateNow
		 * @desc called by GAME LOOP for updating the object
		 */
		public function updateNow():void
		{
			updateAttribs();
			childSpecificUpdating();
		}
		
		/**
		 * @method childSpecificUpdating
		 * @desc to be overriden by child for any logic to be implemented in GAME LOOP
		 */
		protected function childSpecificUpdating():void 
		{
			//child will override this method
		}
		
		/**
		 * @method destroy
		 * @desc remove relevant event listeners and destroys the body
		 */
		public function destroy():void
		{
			//remove the builder from the world
			removeChildEventListeners();
		
			if (_body.GetUserData() is Man || _body.GetUserData() is FallingBlock)
			{
				Lacuna.allDynaBodies.splice(Lacuna.allDynaBodies.indexOf(this), 1);
			}
			if (!(_body.GetUserData() is PushButton) && !(_body.GetUserData() is FallingBlock)) {
				_skin.parent.removeChild(_skin);
			}
			PhysicsWorld.world.DestroyBody(_body);
		}
		
		/**
		 * @method setVel_body
		 * @desc sets linear velocity of body
		 * @param	newVel
		 */
		public function setVel_body(newVel:b2Vec2):void
		{
			_body.SetLinearVelocity(newVel);			
		}
		
		/**
		 * @method removeChildEventListeners
		 * @desc to be overriden by child to remove any event listeners applied on it before destruction
		 */
		protected function removeChildEventListeners():void 
		{
			//remove event listeners put on child
		}
	}

}