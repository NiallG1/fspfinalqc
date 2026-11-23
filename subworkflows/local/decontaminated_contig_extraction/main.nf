include { CONTIGLISTCREATION      } from '../../../modules/local/contiglistcreation/main'
include { SEQTK_SUBSEQ            } from '../../../modules/nf-core/seqtk/subseq/main'


workflow DECONTAMINATED_CONTIG_EXTRACTION {

    take:
    ch_samplesheet_busco_btk
    ch_samplesheet_reads_fasta


    main:
    // Create list of contigs to be retained following blobtoolkit decontamination
    CONTIGLISTCREATION(ch_samplesheet_busco_btk)

    //extract contigs from the original assembly using seqtk subseq
    SEQTK_SUBSEQ(ch_samplesheet_reads_fasta, CONTIGLISTCREATION.out.contig_list)
    

    emit:
    contig_list = CONTIGLISTCREATION.out.contig_list
    decontaminated_fasta = SEQTK_SUBSEQ.out.sequences
}
