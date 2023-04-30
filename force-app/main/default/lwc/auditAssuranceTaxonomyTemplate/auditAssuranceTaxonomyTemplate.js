import { LightningElement, track } from 'lwc';

export default class AuditAssuranceTaxonomyTemplate extends LightningElement {
    @track isShowAuditTaxonomy = true;
    closeAuditTaxonomyTemplate(){
         this.isShowAuditTaxonomy = false;
    }
}