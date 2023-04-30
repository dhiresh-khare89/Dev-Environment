import { LightningElement, track } from 'lwc';

export default class FinancialTaxonomyTemplate extends LightningElement {
    @track isShowFinancialTaxonomy = true;
    closeFinancialTaxonomyTemplate(){
        this.isShowFinancialTaxonomy = false;
    }
}