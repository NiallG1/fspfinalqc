process CONTIGLISTCREATION {
    tag "${meta.id}"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/gawk:5.4.1--2c85b98809d03f7f' :
        'community.wave.seqera.io/library/gawk:5.4.1--ad0937af1dba8a35' }"

    input:
    tuple val(meta), path(busco_full_table), path(taxonomy_csv), path(core_csv)

    output:
    tuple val(meta), path("${prefix}_contig_ids.txt"), emit: contig_list
    tuple val("${task.process}"), val('gawk'), eval("awk -Wversion | sed '1!d; s/.*Awk //; s/,.*//'"), topic: versions, emit: versions_gawk

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = task.ext.prefix ?: "${meta.id}"
    """
        {
        awk -F',' 'NR>1 && \$9 != "" {gsub(/"/,"",\$9); print \$9}' ${taxonomy_csv}
        awk -F',' 'NR>1 && \$9 != "" {gsub(/"/,"",\$9); print \$9}' ${core_csv}
        awk -F'\t' '!/^#/ && \$3 != "" {print \$3}' ${busco_full_table}
    }   | LC_ALL=C sort -u > ${prefix}_contig_ids.txt
    """

    stub:
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}_contig_ids.txt
    """
}

