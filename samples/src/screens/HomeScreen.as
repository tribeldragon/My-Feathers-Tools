package screens {
	import controls.Accordion;
	import controls.HeadedScreen;
	import controls.TogglePanel;
	import controls.dialogs.Dialog;
	import controls.dialogs.InputDialog;
	import controls.dialogs.LoadingDialog;
	import controls.factory.Align;
	import controls.factory.ControlFactory;
	import controls.factory.LayoutFactory;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	
	/**
	 * The code in here tries to demonstrate the use of most of the FeathersTools.
	 */
	public class HomeScreen extends HeadedScreen {
		
		/** A simple test list to test height problems with TogglePanels displaying lists. */
		private var list:List;
		/** A toggle panel with a list inside it. */
		private var toggleList:TogglePanel;
		
		
		// CONSTRUCTOR :
		/**
		 * Inits the screen's basic properties.
		 */
		public function HomeScreen() {
			
			// Call the HeadedScreen constructor with your screen's basic parameters : 
			super(
				"My sample app", 		// -> screen's header title
				"FakeScreenID", 60,		// -> if you have a previous screen, give it his ID here, a BackButton leading to this screenID will be added automatically 
				20, 20,					// -> VerticalLayout params : gap, padding
				
				// Left and right sample items :
				new <DisplayObject>[ControlFactory.getButton("LeftBtn", Align.LEFT)],
				new <DisplayObject>[ControlFactory.getButton("RightBtn", Align.RIGHT)]
			);
		}
		
		
		/**
		 * Inits the screen's content and then add its behavior.
		 */
		override protected function initialize():void {
			super.initialize();
			
			// Create content :
			var dialogBtn:Button = ControlFactory.getButton("Dialog");
			var inputDialogBtn:Button = ControlFactory.getButton("InputDialog");
			var loadingDialogBtn:Button = ControlFactory.getButton("LoadingDialog");
			
			var togglePanel1:TogglePanel = new TogglePanel("My toggle panel 1", ControlFactory.getLabel("Some content ..."));
			
			var togglePanel2:TogglePanel = new TogglePanel(
				ControlFactory.getButton("My second toggle panel", Align.RIGHT),
				ControlFactory.getLabel("Some other content ..."));
			
			var tp3Container:ScrollContainer = ControlFactory.getScrollContainer(ScrollContainer.SCROLL_POLICY_OFF, ScrollContainer.SCROLL_POLICY_OFF);
			tp3Container.layout = LayoutFactory.getVLayout(10, "10 25");
			tp3Container.addChild(ControlFactory.getLabel("Here is a more elaborate TogglePanel sample content!", true));
			tp3Container.addChild(ControlFactory.getTextInput(false, true));
			tp3Container.addChild(ControlFactory.getButton("OK"));
			
			var togglePanel3:TogglePanel = new TogglePanel("A more elaborate toggle panel", tp3Container);
			
			list = new List();
			toggleList = new TogglePanel("List height test", list);
			
			// Display content :
			addChild(ControlFactory.getLabel("controls.dialogs.* samples :"));
			addChild(toggleList);
			addChild(dialogBtn);
			addChild(inputDialogBtn);
			addChild(loadingDialogBtn);
			addChild(togglePanel1);
			addChild(togglePanel2);
			addChild(togglePanel3);
			
			
			///////////////////
			// ADD BEHAVIOR :
			
			// Dialogs :
			dialogBtn.addEventListener(Event.TRIGGERED, showDialog);
			inputDialogBtn.addEventListener(Event.TRIGGERED, showInputDialog);
			loadingDialogBtn.addEventListener(Event.TRIGGERED, showLoadingDialog);
			toggleList.addEventListener(TogglePanel.EXPAND_BEGIN, randomUpdateList);
			toggleList.addEventListener(TogglePanel.COLLAPSE_COMPLETE, clearList);
			
			// Accordion on toggle panels :
			Accordion.create(new <TogglePanel>[togglePanel1, togglePanel2, togglePanel3]);
			
		}
		
		
		//////////////////////////
		// COMPONENTS BEHAVIORS //
		//////////////////////////
		
		// DIALOG :
		private function showDialog(ev:Event):void {
			PopUpManager.addPopUp(
				new Dialog("This is the message part of the dialog", "My dialog title",
					[Dialog.BTN_CANCEL, Dialog.BTN_OK], dialogCallback)
			);
		}
		private function dialogCallback(button:String):void {
			trace(button == Dialog.BTN_CANCEL ? "Why did you cancel?" : "Ok!");
		}
		
		
		// INPUT DIALOG :
		private function showInputDialog(ev:Event):void {
			PopUpManager.addPopUp(
				new InputDialog("Enter an email :", "My input dialog",
					inputDialogCallback, validateInputDialogContent,
					false, true)
			);
		}
		
		private function validateInputDialogContent(textInput:TextInput):Boolean {
			if(!Boolean(textInput.text.match(/^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i))) {
				Callout.show(ControlFactory.getLabel("Enter a valid email address !"), textInput, Callout.DIRECTION_UP);
				return false;
			}
			return true;
		}
		
		private function inputDialogCallback(button:String, userInput:String):void {
			trace(button == Dialog.BTN_CANCEL ? "Why did you cancel?" : "You entered : " + userInput);
		}
		
		
		// LOADING DIALOG :
		private function showLoadingDialog(ev:Event):void {
			PopUpManager.addPopUp(LoadingDialog.instance);
			
			trace("Loading dialog will hide in 3 seconds ...");
			Starling.juggler.delayCall(
				function():void { PopUpManager.removePopUp(LoadingDialog.instance); },
				3);
		}
		
		
		// TOGGLE LIST PANEL :
		private function randomUpdateList(ev:Event):void {
			var delay:Number = Math.random();
			trace("Creating list content in " + delay + " seconds.");
			Starling.juggler.delayCall(createListContent, delay);
		}
		private function createListContent():void {
			list.dataProvider = new ListCollection(["Item1", "Item2", "Item3"]);
			toggleList.resizeToContent();
			trace("List content created.");
		}
		private function clearList(ev:Event):void {
			list.dataProvider = null;
			trace("List content cleared.");
		}
		
		
		
		/**
		 * Overrides BACK button's default behavior.
		 */
		override protected function backButtonTriggered(ev:Event=null):void {
			trace("There is no real previous screen, but this way, you can add some more behavior, or code your very own.");
		}
	}
}