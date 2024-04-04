public with sharing class ProjectInfoHandler {
    
  
    
    @AuraEnabled(cacheable=TRUE)
    public static List<Project__c> retrieveProjectRecords(){
        List<Project__c> prjList = [SELECT Id, Name, Status__c,Status_Flag__c, Percentage_Complete__c, Description__c FROM Project__c WHERE Name != NULL];
        RETURN prjList;
    }
 
 
    @AuraEnabled(cacheable=TRUE)
    public static List<Milestone__c> retrieveMilestoneRecords(string prjId){
      List<Milestone__c> mileObj = new  List<Milestone__c>();
      List<Milestone__c> mileList = [SELECT Id, Name, Status__c, Due_Date__c,Status_Flag__c, Percentage_Complete__c, Project__c,Project__r.Name FROM Milestone__c WHERE Project__c=:prjId];
      FOR(Milestone__c mile:mileList){
        mileObj.add(mile);
      }
      return mileObj;
    }

    @AuraEnabled(cacheable=TRUE)
    public static List<To_Do_Items__c> retrieveTodoRecords(string milstoneId){
      List<To_Do_Items__c> mileObj = new  List<To_Do_Items__c>();
      List<To_Do_Items__c> mileList = [SELECT Id, Name, Status__c, Milestone__c,Milestone__r.Name FROM To_Do_Items__c WHERE Milestone__c=:milstoneId];
      FOR(To_Do_Items__c mile:mileList){
        mileObj.add(mile);
      }
      return mileObj;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getCount(){
      List<Project__c> prjList = [SELECT Id, Name, Status__c,Status_Flag__c, Percentage_Complete__c, Description__c FROM Project__c WHERE Name != NULL];
      List<Milestone__c> mileList = [SELECT Id, Name, Status__c, Due_Date__c,Status_Flag__c, Percentage_Complete__c, Project__c,Project__r.Name FROM Milestone__c WHERE Name != NULL];
      List<To_Do_Items__c> toDoList = [SELECT Id, Name, Status__c, Milestone__c,Milestone__r.Name FROM To_Do_Items__c WHERE Name != NULL];
      List<DataSet> dataSet = new List<DataSet>();
      dataSet.add(new DataSet('Project' ,prjList.size()));
      dataSet.add(new DataSet('Milestone' ,mileList.size()));
      dataSet.add(new DataSet('TodoList' ,toDoList.size()));
     return dataSet;
    }
    
    public class DataSet{
      @AuraEnabled
      public  String label {get;set;}
      
      @AuraEnabled
      public  Integer  count {get;set;}
      
      public DataSet(String label ,Integer count){
                    this.label  = label ;
                    this.count = count ;
          }
    }
    
   
}