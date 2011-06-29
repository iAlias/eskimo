package com.piaction.components
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.collections.IList;
    import mx.controls.List;
    import mx.events.FlexEvent;
    import mx.events.ItemClickEvent;
    import mx.managers.PopUpManager;
    
    import spark.components.Label;
    import spark.components.supportClasses.SkinnableComponent;
    
    /**
     * Skinclass of popup
     */
    [Style(name = "popupSkinClass", inherit = "no", type = "Class")]
    
    /**
     *  Dispatched when the user clicks on an item in the control.
     *
     *  @eventType mx.events.ItemClickEvent.ITEM_CLICK
     */
    [Event(name="itemClick", type="mx.events.ItemClickEvent")]
    
    /**
     * The ComboBox control lets the user make a single choice within a set of mutually exclusive choices.
     */
    public class ComboBox extends SkinnableComponent
    {
        private static const POPUP_PADDING_PERCENT:Number = 4;
        
        public function ComboBox()
        {
            super();
            this.addEventListener(MouseEvent.CLICK, popUpList);
        }
        
        [SkinPart(required = "true")]
        public var selectedLabel:Label;
        
        private var _dataProvider:IList;
        
        /**
         * @private
         */
        private var _selectedItem:Object;
        
        /**
         * @private
         */
        private var _selectedItemChange:Boolean;
        
        private var _labelField:String = "label";
        
        private var popUp:UniqueChoiceList = new UniqueChoiceList();
        
        /**
         *  The name of the field in the data provider items to display 
         *  as the label. 
         * 
         *  If labelField is set to an empty string (""), no field will 
         *  be considered on the data provider to represent label.
         *
         *  @default "label" 
         */
        public function get labelField():String
        {
            return _labelField;
        }
        
        public function set labelField(value:String):void
        {
            _labelField = value;
        }
        
        public function set dataProvider(value:IList):void
        {
            if (value != _dataProvider)
            {
                _dataProvider = value;
                invalidateProperties();
            }
        }
        
        /**
         *  Set of data to be viewed.
         */
        public function get dataProvider():IList
        {
            return _dataProvider;
        }
        
        private function popUpList(event:MouseEvent):void
        {
            var popupSkinClass:Object = getStyle("popupSkinClass");
            if(popupSkinClass != null)
            {
              popUp.setStyle("skinClass", popupSkinClass);
            }
            popUp.dataProvider = dataProvider;
            popUp.addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
            popUp.labelField = labelField;

            // center popup
            popUp.width = stage.stageWidth * (100 - 2 * POPUP_PADDING_PERCENT) / 100;
            popUp.x = stage.stageWidth * POPUP_PADDING_PERCENT / 100;
            PopUpManager.addPopUp(popUp, this);
            popUp.y = stage.stageHeight / 2 - popUp.height;
        }
        
        protected function onItemClick(event:ItemClickEvent):void
        {
            var selecteditem:Object = popUp.selectedItem;
            if (selecteditem != null && selecteditem.hasOwnProperty(labelField))
            {
                selectedLabel.text = selecteditem[labelField];
            }
            var evt:Event = event.clone();
            dispatchEvent(evt);List
            
            PopUpManager.removePopUp(popUp);
        }

        /**
         *  The item that is currently selected. 
         */
        public function get selectedItem():Object
        {
            return popUp.selectedItem;
        }
        
        /**  
        * Setting this property deselects the currently selected 
        *  item and selects the newly specified item.
        *
        *  <p>Setting <code>selectedItem</code> to an item that is not 
        *  in this component results in no selection, 
        *  and <code>selectedItem</code> being set to <code>undefined</code>.</p>
        */
        public function set selectedItem(value:Object):void
        {
            popUp.selectedItem = value;
            if(value != _selectedItem)
            {
                _selectedItem = value;
                
                _selectedItemChange = true;
                
                invalidateProperties();
            }
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if(_selectedItemChange && _selectedItem && _selectedItem.hasOwnProperty(labelField))
            {
                selectedLabel.text = _selectedItem[labelField];
                _selectedItemChange = false;
            }
        }
    }
}
