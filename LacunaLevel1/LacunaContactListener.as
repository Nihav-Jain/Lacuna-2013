package  
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	/**
	 * ...
	 * @author Nihav Jain
	 * @class LacunaContactListener - custom contact listener for Box2D
	 */
	public class LacunaContactListener extends b2ContactListener 
	{
		/**
		 * @constructor
		 */
		public function LacunaContactListener() 
		{
			
		}
		
		/**
		 * @method BeginContact
		 * @desc called when contact begins between two bodies
		 * @param	contact
		 */
		override public function BeginContact(contact:b2Contact):void 
		{
			var body1:b2Body;
			var body2:b2Body;
			
			if (contact.GetFixtureA().GetBody().GetUserData() is Man)
			{
				body1 = contact.GetFixtureA().GetBody();
				body2 = contact.GetFixtureB().GetBody();
			}
			else if (contact.GetFixtureB().GetBody().GetUserData() is Man)
			{
				body1 = contact.GetFixtureB().GetBody();
				body2 = contact.GetFixtureA().GetBody();
			}
			else 
			{
				if ((contact.GetFixtureA().GetBody().GetUserData() is FallingBlock && contact.GetFixtureB().GetBody().GetUserData() is WallBuilder))
					FallingBlock(contact.GetFixtureA().GetBody().GetUserData()).setDestroyFlag();
				else if (contact.GetFixtureA().GetBody().GetUserData() is WallBuilder && contact.GetFixtureB().GetBody().GetUserData() is FallingBlock)
					FallingBlock(contact.GetFixtureB().GetBody().GetUserData()).setDestroyFlag();
				return;
			}
			if (body2.GetUserData() is CollectableItem)
			{
				Man(body1.GetUserData()).canCollectBody(body2);
			}
			else if (body2.GetUserData() is PushButton)
			{
				Man(body1.GetUserData()).getPushedButton(body2);
			}
			else if (body2.GetUserData() is Teleporter)
			{
				Man(body1.GetUserData()).inTeleContact(body2);
			}
			else if (body2.GetUserData() is KillerBuilders)
			{
				Man(body1.GetUserData()).killedByBuilder(KillerBuilders(body2.GetUserData()).currentSpriteType);
			}
			else if (body2.GetUserData() is Ladder)
			{
				
			}
			else if (body2.GetUserData() is FallingBlock)
			{
				FallingBlock(body2.GetUserData()).moveRockSkin();
				Man(body1.GetUserData()).destroy();
			}
			else if (body2.GetUserData() is Exit)
			{
				Man(body1.GetUserData()).exit();
			}
			super.BeginContact(contact);
		}
		
		/**
		 * @method EndContact
		 * @desc called when two bodies, originally in contact, leave each other
		 * @param	contact
		 */
		override public function EndContact(contact:b2Contact):void 
		{
			var body1:b2Body;
			var body2:b2Body;
			
			if (contact.GetFixtureA().GetBody().GetUserData() is Man)
			{
				body1 = contact.GetFixtureA().GetBody();
				body2 = contact.GetFixtureB().GetBody();
			}
			else if (contact.GetFixtureB().GetBody().GetUserData() is Man)
			{
				body1 = contact.GetFixtureB().GetBody();
				body2 = contact.GetFixtureA().GetBody();
			}
			else 
			{
				return;
			}
			if (body2.GetUserData() is CollectableItem)
			{
				Man(body1.GetUserData()).cannotCollectBody();
			}
			if (body2.GetUserData() is Teleporter)
			{
				//Man(body1.GetUserData()).endTeleContact();
			}
			super.EndContact(contact);
		}
	}

}