package  
{
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Inventory - represents the Sprite to display stored collectables
	 */
	public class Inventory extends Sprite
	{
		private var items:Array;
		private var itemType:Array;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	location
		 * @param	width
		 * @param	height
		 */
		public function Inventory(parent:Sprite, location:Point, width:Number, height:Number) 
		{
			this.graphics.beginFill(0x000000, 0.25);
			this.graphics.drawRect(0, 0, width * Lacuna.WIDTH, height * Lacuna.HEIGHT);
			this.graphics.endFill();
			
			Lacuna.STAGE.addChild(this);
			
			this.x = location.x*Lacuna.WIDTH;
			this.y = location.y*Lacuna.HEIGHT;
			
			items = new Array();
			itemType = new Array();
		}
		
		/**
		 * @method addToInventory
		 * @desc adds the given collectable to the inventory
		 * @param	spriteTypeToAdd
		 */
		public function addToInventory(spriteTypeToAdd:CollectableItem):void
		{
			items.push(spriteTypeToAdd);
			var curSprite:uint = spriteTypeToAdd.currentSpriteType;
			var Sp1:Sprite = CollectableItem.returnReqSprite(spriteTypeToAdd.currentSpriteType);
			
			Sp1.y = 35;
			Sp1.x = 10 + Sp1.width / 2 + itemType.length * 100;
			this.addChild (Sp1);
			itemType.push(Sp1);
			Sp1.buttonMode = true;
			
			itemType[items.length - 1].addEventListener(MouseEvent.CLICK, selectItem);
		}
		
		/**
		 * @method selectItem
		 * @desc click listener for the item in inventory
		 * @param	e
		 */
		private function selectItem(e:MouseEvent):void 
		{
			var index:int = itemType.indexOf(e.target);
			Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length-1]).spitOutItem(CollectableItem(items[index]));
			this.removeChild(itemType[index]);
			items.splice(index, 1);
			itemType.splice(index, 1);
		}
		
	}

}