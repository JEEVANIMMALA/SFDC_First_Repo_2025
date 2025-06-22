import { LightningElement,track } from 'lwc';


export default class JS_Datatable extends LightningElement {

    @track buttonVarient = 'brand';
    @track btnLabel = 'Open';

    handleBtnClick() {
        this.buttonVarient = this.buttonVarient == 'brand'? 'success' : 'brand';
        this.btnLabel = this.btnLabel == 'Open' ? 'Close' : 'Open';
    }

}