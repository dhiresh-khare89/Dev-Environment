import { LightningElement, track } from 'lwc';

export default class TaxonomyTemplates extends LightningElement {
    @track isShowAuditTaxonomy = true;
    closeAuditTaxonomyTemplate(){
         this.isShowAuditTaxonomy = false;
    }
}