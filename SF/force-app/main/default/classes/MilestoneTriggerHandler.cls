public class MilestoneTriggerHandler {
    public static void onAfterInsertUpdate(List<sObject> newRecsSobj,String Milestone, String Project){
        Integer total = 0;
        Decimal Complete = 0.0;
        String ParentField;
        Map<Id,Decimal> toDOMap = new Map<Id,Decimal>();
        Map<Id,sObject> MilestoneMap = new Map<Id,sObject>();
        
        if(newRecsSobj != null){
            for(sObject newRec : newRecsSobj){
                if(Milestone == 'Milestone__c'){
                    Milestone__c ms = (Milestone__c)newRec;
                    MilestoneMap.put(ms.Project__c , newRec); 
                    ParentField = 'Project__c';
                }
                if(Milestone == 'To_Do_Items__c'){
                    To_Do_Items__c ms = (To_Do_Items__c)newRec;
                    MilestoneMap.put(ms.Milestone__c , newRec); 
                    ParentField = 'Milestone__c';
                }
            }
            Set<Id> childIds = MilestoneMap.keySet();
            
            string que = ' select id,Status__c,'+ParentField+' from '+Milestone+' where '+ParentField+' IN :childIds ';
            System.debug('Que---'+que);
            List<sObject> allToDoRecs = Database.query(que);
            System.debug('allToDoRecs---'+allToDoRecs);
            
            for(sObject newRec : allToDoRecs){
                if(Milestone == 'Milestone__c'){
                    Milestone__c ms1 = (Milestone__c)newRec;
                    if(ms1.Status__c == 'Completed')  Complete += 1;
                    else if(ms1.Status__c == 'In Progress')  Complete += 0.25;
                    toDOMap.put(ms1.Project__c , Math.round(Complete/allToDoRecs.size()*100));
                }
                if(Milestone == 'To_Do_Items__c'){
                    To_Do_Items__c ms1 = (To_Do_Items__c)newRec;
                    if(ms1.Status__c == 'Completed')  Complete += 1;
                    else if(ms1.Status__c == 'In Progress')  Complete += 0.25;
                    toDOMap.put(ms1.Milestone__c , Math.round(Complete/allToDoRecs.size()*100)); 
                }
            }
        }
        
        Set<Id> parentIds = toDOMap.keySet();
        string queProj = 'select id,Status__c,Percentage_Complete__c from '+Project+' where Id in :parentIds';
        List<sObject> allProjects = Database.query(queProj);
        
        for( sObject projectRec : allProjects){
            if(Milestone == 'Milestone__c'){
                Project__c p = (Project__c)projectRec;
                // if(toDOMap.containsKey(p.Id)){
                p.Percentage_Complete__c = toDOMap.get(p.Id);
                p.Status__c = (toDOMap.get(p.Id) == 100 ) ? 'Completed' : (toDOMap.get(p.Id) == 0) ?  'Not Started':'In Progress'  ;
                //  } 
            }
            
            if(Milestone == 'To_Do_Items__c'){
                Milestone__c p = (Milestone__c)projectRec;
                p.Percentage_Complete__c = toDOMap.get(p.Id);
                p.Status__c = (toDOMap.get(p.Id) == 100 ) ? 'Completed' : (toDOMap.get(p.Id) == 0) ?  'Not Started':'In Progress'  ;
            }
        }
        update allProjects;
    }
}




/*public class MilestoneTriggerHandler {
public static void onAfterInsertUpdate(List<sObject> newRecsSobj, String Miles, String Pro) {
Map<Id, Decimal> projectPercentageMap = new Map<Id, Decimal>();

List<Milestone__c> newMilestones = (List<Milestone__c>) newRecsSobj;
Map<Id, List<Milestone__c>> projectMilestonesMap = new Map<Id, List<Milestone__c>>();

// Group milestones by project
for (Milestone__c milestone : newMilestones) {
if (!projectMilestonesMap.containsKey(milestone.Project__c)) {
projectMilestonesMap.put(milestone.Project__c, new List<Milestone__c>());
}
projectMilestonesMap.get(milestone.Project__c).add(milestone);
}

// Calculate completion percentage for each project
for (Id projectId : projectMilestonesMap.keySet()) {
List<Milestone__c> milestones = projectMilestonesMap.get(projectId);
Integer totalMilestones = milestones.size();
decimal completedCount = 0.0;
for (Milestone__c m : milestones) {
if (m.Status__c == 'Completed') {
completedCount += 1;
} else if (m.Status__c == 'In Progress') {
// You may adjust the weight for 'In Progress' milestones
completedCount += 0.25;
}
}
Decimal completionPercentage = totalMilestones > 0 ? (completedCount / Decimal.valueOf(totalMilestones) )* 100 : 0;
projectPercentageMap.put(projectId, completionPercentage);
}

// Update project records with completion percentage
Set<Id> projectIds = projectPercentageMap.keySet();
String projectIdsString = '\'' + String.join(new List<Id>(projectIds), '\',\'') + '\'';
String query = 'SELECT Id, Percentage_Complete__c FROM Project__c WHERE Id IN (' + projectIdsString + ')';

List<Project__c> projectsToUpdate = Database.query(query);
for (Project__c project : projectsToUpdate) {
project.Percentage_Complete__c = projectPercentageMap.get(project.Id);
project.Status__c = projectPercentageMap.get(project.Id) == 100 ? 'Completed' : (projectPercentageMap.get(project.Id) == 0 ? 'Not Started' : 'In Progress');
}

update projectsToUpdate;
}
}


*/
/*public class MilestoneTriggerHandler {
public static void onAfterInsertUpdate(List<Milestone__c> newRecs,String Milestone, String Project){
Integer total = 0;
Decimal Complete = 0.0;
Decimal percentageValue = 0.0;
Map<Id,Decimal> toDOMap = new Map<Id,Decimal>();
Map<Id,Milestone__c> MilestoneMap = new Map<Id,Milestone__c>();
if(newRecs != null){
for(Milestone__c newRec : newRecs){
MilestoneMap.put(newRec.Project__c , newRec);
}
List<Milestone__c> allToDoRecs = [select id,Status__c,Project__c from Milestone__c where Project__c in :MilestoneMap.keySet()];

for(Milestone__c newRec : allToDoRecs){
if(newRec.Status__c == 'Completed')  Complete = Complete + 1;
percentageValue = Math.round(Complete/allToDoRecs.size()*100);
System.debug('Complete----'+Complete +'---'+allToDoRecs.size()+'---'+percentageValue);
toDOMap.put(newRec.Project__c , percentageValue);
}
}
List<Project__c> allProjects = [select id,Percentage_Complete__c from Project__c where id in :toDOMap.keySet()];
for( Project__c projectRec : allProjects){
if(toDOMap.containsKey(projectRec.Id)){
projectRec.Percentage_Complete__c = toDOMap.get(projectRec.Id);
projectRec.Status__c = (percentageValue == 100 ) ? 'Completed' : (percentageValue >0 && percentageValue <100) ? 'In Progress' : 'Not Started' ;
}
}
update allProjects;
}
}*/