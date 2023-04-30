import { LightningElement, track } from 'lwc';

export default class AssuranceTaxonomyTemplate extends LightningElement {
    @track isShowAssuranceTaxonomy = true;
    closeAssuranceTaxonomyTemplate(){
        this.isShowAssuranceTaxonomy = false;
    }
}