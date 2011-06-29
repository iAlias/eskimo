package com.piaction.components
{
  import com.piaction.events.ConfirmEvent;
  import com.piaction.tool.PropertyData;
  import com.piaction.tool.TestHelper;
  
  import flash.events.MouseEvent;
  
  import flexunit.framework.Assert;
  
  import mx.events.FlexEvent;
  
  import org.fluint.sequence.SequenceCaller;
  import org.fluint.sequence.SequenceRunner;
  import org.fluint.sequence.SequenceWaiter;
  import org.fluint.uiImpersonation.UIImpersonator;
  
  public class ConfirmButtonTest
  {
    private var _confirmButton:ConfirmButton;
    
    [Before(ui)]
    public function setUp():void
    {
      _confirmButton = new ConfirmButton();
      UIImpersonator.addChild(_confirmButton);
    }
    
    [After(ui)]
    public function tearDown():void
    {
      UIImpersonator.removeChild(_confirmButton);
      _confirmButton = null;
    }
    
    [Test(async)]
    public function stateTest():void
    {
      var sequence:SequenceRunner = new SequenceRunner(this);
      
      // initial state
      var normalState:PropertyData = new PropertyData('currentState', ConfirmButton.NORMAL_STATE);
      
      sequence.addStep(new SequenceWaiter(_confirmButton, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceCaller(_confirmButton, TestHelper.handleVerifyProperty, [normalState, _confirmButton]));
      
      // confirmation state
      var confirmationState:PropertyData = new PropertyData('currentState', ConfirmButton.CONFIRMATION_STATE);
      
      sequence.addStep(new SequenceCaller(_confirmButton, dispatchMouseClickOnButton, [normalState]));
      sequence.addStep(new SequenceWaiter(_confirmButton, ConfirmEvent.ENTER_CONFIRMATION, 2000));
      sequence.addStep(new SequenceCaller(_confirmButton, TestHelper.handleVerifyProperty, [confirmationState
                                                                                            , _confirmButton]));
      
      // return to the initial state
      sequence.addStep(new SequenceCaller(_confirmButton, dispatchMouseClickOnButton, [normalState]));
      
      sequence.run();
    }
    
    protected function dispatchMouseClickOnButton(value:Object):void
    {
      _confirmButton.button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
    }
  
  }
}