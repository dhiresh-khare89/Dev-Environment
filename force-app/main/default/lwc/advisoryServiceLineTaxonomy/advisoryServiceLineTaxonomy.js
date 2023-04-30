import { LightningElement, track } from 'lwc';

export default class AdvisoryServiceLineTaxonomy extends LightningElement {
    @track isShowAdvisoryServiceLineTaxonomy = true;
    closeAdvisoryServiceLineTaxonomyTemplate(){
         this.isShowAdvisoryServiceLineTaxonomy = false;
    }
}