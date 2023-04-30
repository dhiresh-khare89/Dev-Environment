import { LightningElement, track } from 'lwc';

export default class TaxServiceLineTaxonomy extends LightningElement {
    @track isShowTaxServiceLineTaxonomy = true;
    closeTaxServiceLineTaxonomyTemplate(){
        this.isShowTaxServiceLineTaxonomy = false;
    }
}