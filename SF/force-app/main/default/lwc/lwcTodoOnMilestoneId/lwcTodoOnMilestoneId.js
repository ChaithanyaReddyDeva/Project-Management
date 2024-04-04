import { LightningElement, track, wire,api} from 'lwc';
import retrieveTodoRecords from '@salesforce/apex/ProjectInfoHandler.retrieveTodoRecords';
import { NavigationMixin } from 'lightning/navigation';
export default class LwcTodoOnMilestoneId extends NavigationMixin(LightningElement) {

    @track records;
    @track errorMsg;
    @api milestoneId;  
    showData = false;
 
    @wire (retrieveTodoRecords, {milstoneId:'$milestoneId'})
      wireTodoRecord({error,data}){
        if(data){
          this.records = data;     
          this.errorMsg = undefined; 
          if(this.records.length > 0){
            this.showData = true;
          }else{
            this.showData = false;
          }   
        }else{         
          this.errorMsg = error;
          this.records = undefined;
          this.showData = false;
        }
        console.log('>>>todo'+this.records);
      }
 
    onNameClick(event){
    var recordId = event.target.id.split('-')[0];
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            actionName: 'edit'
        }
    });
  }
 



}