import { LightningElement, track } from 'lwc';

export default class OtherServicesTaxonomyTemplate extends LightningElement {
    @track isShowOtherServicesTaxonomy = true;
    closeOtherServicesTaxonomyTemplate(){
        this.isShowOtherServicesTaxonomy = false;
    }
}