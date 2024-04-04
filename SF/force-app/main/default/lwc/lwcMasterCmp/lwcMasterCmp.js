import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import getCount from '@salesforce/apex/ProjectInfoHandler.getCount';

import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retrieveProjectRecords from '@salesforce/apex/ProjectInfoHandler.retrieveProjectRecords';
 
export default class LwcMasterCmp extends NavigationMixin (
    LightningElement
) {
 
  @wire (retrieveProjectRecords) prjData;
  @track selectedProjectId;
  @track selectedMilestoneId;
  result;
  chart;
    chartjsInitialized = false;
    config={
    type : 'doughnut',
    data :{
    datasets :[
    {
    data: [
    ],
    backgroundColor :[
      'rgb(255,99,132)',
      'rgb(255,159,64)',
      'rgb(255,205,86)',
      'rgb(75,192,192)',
    ],
      label:'Dataset 1'
    }
    ],
    labels:[]
    },
    options: {
      responsive : true,
    legend : {
      position :'right'
    },
    animation:{
      animateScale: true,
      animateRotate : true
    }
    }
    };

  handleProjectSelection(event){
    this.selectedProjectId = event.target.value;
  }

  onMilestoneSelection(event){
    this.selectedMilestoneId = event.detail.milestoneId;
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
 
  @wire (getCount) accounts({error,data}){
      if(data)
      {
        this.result = data;
        for(var key in data)
          {
            this.updateChart(data[key].count,data[key].label);
          }
        this.error=undefined;
      }
    else if(error)
    {
        this.error = error;
        this.result = undefined;
    }
    }
    
    renderedCallback()
    {
      if(this.chartjsInitialized)
    {
      return;
    }
    this.chartjsInitialized = true;
    Promise.all([
      loadScript(this,chartjs)
    ]).then(() =>{
      const ctx = this.template.querySelector('canvas.donut')
      .getContext('2d');
      this.chart = new window.Chart(ctx, this.config);
    })
    .catch(error =>{
      this.dispatchEvent(
      new ShowToastEvent({
      title : 'Error loading ChartJS',
      message : error.message,
      variant : 'error',
      }),
    );
    });
    }
    updateChart(count,label)
    {
   // console.log(count+' '+label);
    /*  this.chart.data.labels.push(label);
      this.chart.data.datasets.forEach((dataset) => {
           dataset.data.push(count);
      });
      this.chart.update();*/
    }

   cretaeProject(event){
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Project__c',
            actionName: 'new'
        }
    });
  }

  createMileStone(event){
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Milestone__c',
            actionName: 'new'
        }
    });
  }
  
  createTodo(event){
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'To_Do_Items__c',
            actionName: 'new'
        }
    });
  }
}