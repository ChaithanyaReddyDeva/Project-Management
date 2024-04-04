trigger MilestoneTrigger on Milestone__c (after insert, after update,after delete) {
    List<Milestone__c> recordsList = new List<Milestone__c>();
    if(Trigger.isInsert || Trigger.isupdate)recordsList = Trigger.new;
    if(Trigger.isDelete) recordsList = Trigger.old;
    MilestoneTriggerHandler.onAfterInsertUpdate(recordsList,'Milestone__c', 'Project__c');
}