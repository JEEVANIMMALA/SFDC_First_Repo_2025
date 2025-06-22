import { LightningElement,track } from 'lwc';
export default class ParentComponent extends LightningElement {

    @track showModel = false;

    handleReset(){
        this.template.querySelector('c-child-component').resetVal();
    }

    showModehandle(){
        this.showModel = true;
    }

     closeModel(event){
        console.log('parent --showModel',event.detail)
        this.showModel = false;
    }

}