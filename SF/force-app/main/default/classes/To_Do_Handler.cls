public class To_Do_Handler {
    public static void onAfterInsertUpdate(List<To_Do_Items__c> newRecs){
        Integer notStarted = 0;
        decimal Complete = 0.0;
        Integer inProgress = 0;
        decimal percentageValue = 0.0;
        Map<Id,Decimal> toDOMap = new Map<Id,Decimal>();
        Map<Id,To_Do_Items__c> To_Do_Map = new Map<Id,To_Do_Items__c>();
        if(newRecs != null){
            for(To_Do_Items__c newRec : newRecs){
                To_Do_Map.put(newRec.Milestone__c , newRec);
            }
            List<To_Do_Items__c> allToDoRecs = [select id,Status__c,Milestone__c from To_Do_Items__c where Milestone__c in :To_Do_Map.keySet()];
            
            for(To_Do_Items__c newRec : allToDoRecs){
                if(newRec.Status__c == 'Completed')Complete += 1;
                percentageValue = Complete/allToDoRecs.size() *100;
                System.debug('per-----'+Math.round(percentageValue));
                toDOMap.put(newRec.Milestone__c , Math.round(percentageValue));
            }
        }
        List<Milestone__c> allProjects = [select id,Percentage_Complete__c,Status__c from Milestone__c where id in :To_Do_Map.keySet()];
        for( Milestone__c projectRec : allProjects){
            if(toDOMap.containsKey(projectRec.Id)){
                projectRec.Percentage_Complete__c = toDOMap.get(projectRec.Id);
                projectRec.Status__c = (percentageValue == 100 ) ? 'Completed' : (percentageValue >0 && percentageValue <100) ? 'In Progress' : 'Not Started' ;
            }}
        System.debug('allProjects>>>>'+allProjects);
        update allProjects;
    }
}