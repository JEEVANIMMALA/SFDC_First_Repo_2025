import { LightningElement,track } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ChildModel extends LightningElement {

    @track content ='This is Test modal only';

    handleOkay() {
        console.log('handle event')
        const custevent = new CustomEvent('closechild', {
            detail:this.content
        });
        this.dispatchEvent(custevent);
    }

}