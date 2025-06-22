import { LightningElement,track,api } from 'lwc';
import pubsub from 'c/pubsub';
export default class ChildComponent extends LightningElement {

    @track sliderValue = 20;
    @track inputText;

    handleChange(event) {
        this.sliderValue = event.detail.value;
    }

    @api resetVal() {
        this.sliderValue = 50;
    }

    inputTake(event) {
        this.inputText = event.target.value;
    }

    sendText() {
        pubsub.publish('componentA',this.inputText);
    }

}