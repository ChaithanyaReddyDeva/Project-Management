trigger To_DoTrigger on To_Do_Items__c (after insert, after update,after delete) {
    List<To_Do_Items__c> recordsList = new List<To_Do_Items__c>();
    if(Trigger.isInsert || Trigger.isupdate)recordsList = Trigger.new;
    if(Trigger.isDelete) recordsList = Trigger.old;
   // To_Do_Handler.onAfterInsertUpdate(recordsList);
   MilestoneTriggerHandler.onAfterInsertUpdate(recordsList,'To_Do_Items__c','Milestone__c');
}