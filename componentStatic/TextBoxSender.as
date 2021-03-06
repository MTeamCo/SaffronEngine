package componentStatic
{//componentStatic.TextBoxSender
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	
	public class TextBoxSender extends ComponentManager
	{
		private var _textbox:TextBox;
		private var valueTextMc:TextField;
		public function TextBoxSender()
		{
			valueTextMc = Obj.get('valueText',this);
			update();
			ComponentManager.evt.addEventListener(ComponentManagerEvent.UPDATE,getUpdate)
		}
		
		protected function getUpdate(event:Event):void
		{
			
			update()
		}
		public function get text():String
		{
			return valueTextMc.text;
		}
		public function update():void
		{
			var value:String  = ''
			var oldValue:String	
			if(getObj(this.name)!=null && getObj(this.name)!='')
			{
				value = getObj(this.name)
				oldValue = value	
			}		
			_textbox = new TextBox(this,value,SoftKeyboardType.DEFAULT)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			setObj(this.name,value)
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			
			setObj(this.name,event.text)
		}
		public function rest()
		{
			//_textbox.setText('')
			_textbox.setValueTextByeCod_fun('')
		}
	}
}