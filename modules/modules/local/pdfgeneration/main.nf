process PDFGENERATION {
    tag "$meta.id"
    label 'process_single'

    // TODO nf-core: See section in main README for further information regarding finding and adding container addresses to the section below.
        conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/img2pdf:0.6.3--2be3aecfa2d8ba62' :
        'community.wave.seqera.io/library/img2pdf:0.6.3--25f74a0d55b1c636' }"


    input:
    tuple val(meta), path()

    output:
    
    tuple val(meta), path("*.bam"), emit: bam
    
    tuple val("${task.process}"), val('pdfgeneration'), eval("pdfgeneration --version"), topic: versions, emit: versions_pdfgeneration

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    

    """
    pdfgeneration \\
        $args \\
        -@ $task.cpus \\
        -o ${prefix}.bam \\
        $bam
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    echo $args
    
    touch ${prefix}.bam
    """
}
