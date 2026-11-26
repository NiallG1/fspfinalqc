include { CONTIGLISTCREATION      } from '../../../modules/local/contiglistcreation/main'
include { SEQTK_SUBSEQ            } from '../../../modules/nf-core/seqtk/subseq/main'


workflow DECONTAMINATED_CONTIG_EXTRACTION {

    take:
    samplesheet_busco_btk
    samplesheet_fasta

        main:
    // Create list of contigs to be retained following blobtoolkit decontamination
    CONTIGLISTCREATION(samplesheet_busco_btk)

    // Pair each assembly with its own contig list
    def ch_seqtk_in = samplesheet_fasta
        .join( CONTIGLISTCREATION.out.contig_list, failOnMismatch: true )
        .multiMap { meta, fasta, list ->
            sequences:   [ meta, fasta ]
            filter_list: list
        }

    // Extract retained contigs from the original assembly
    SEQTK_SUBSEQ(ch_seqtk_in.sequences, ch_seqtk_in.filter_list)
    
    emit:
    contig_list = CONTIGLISTCREATION.out.contig_list
    decontaminated_fasta = SEQTK_SUBSEQ.out.sequences
}
