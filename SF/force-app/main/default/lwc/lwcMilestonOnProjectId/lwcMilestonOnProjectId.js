import { LightningElement, track, wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import retrieveMilestoneRecords from '@salesforce/apex/ProjectInfoHandler.retrieveMilestoneRecords';
 
export default class LwcMilestonOnProjectId extends NavigationMixin (
    LightningElement
) {


  @api prjId;
  @track records;
  @track errorMsg;
  @track milstoneId;
  showData = false; 

  @wire (retrieveMilestoneRecords, {prjId:'$prjId'})
    wireMileRecord({error,data}){
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
    }



    onMileStoneSelection(event){ 
      this.milstoneId = event.target.value;
      this.dispatchEvent(new CustomEvent('passmilestoneid', {
          detail: {
              milestoneId : this.milstoneId
          }
      }));

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