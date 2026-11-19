include { CONTIGLISTCREATION      } from '../../../modules/local/contiglistcreation/main'

workflow DECONTAMINATED_CONTIG_EXTRACTION {

    take:
    ch_samplesheet_busco_btk



    main:
    // Create list of contigs to be retained following blobtoolkit decontamination
    CONTIGLISTCREATION(ch_samplesheet_busco_btk)
    

    emit:
    contig_list = CONTIGLISTCREATION.out.contig_list
}
