// TODO nf-core: If in doubt look at other nf-core/modules to see how we are doing things! :)
//               https://github.com/nf-core/modules/tree/master/modules/nf-core/
//               You can also ask for help via your pull request or on the #modules channel on the nf-core Slack workspace:
//               https://nf-co.re/join
// TODO nf-core: A module file SHOULD only define input and output files as command-line parameters.
//               All other parameters MUST be provided using the "task.ext" directive, see here:
//               https://www.nextflow.io/docs/latest/process.html#ext
//               where "task.ext" is a string.
//               Any parameters that need to be evaluated in the context of a particular sample
//               e.g. single-end/paired-end data MUST also be defined and evaluated appropriately.
// TODO nf-core: Software that can be piped together SHOULD be added to separate module files
//               unless there is a run-time, storage advantage in implementing in this way
//               e.g. it's ok to have a single module for bwa to output BAM instead of SAM:
//                 bwa mem | samtools view -B -T ref.fasta
// TODO nf-core: Optional inputs are not currently supported by Nextflow. However, using an empty
//               list (`[]`) instead of a file can be used to work around this issue.

process EMIRGE_EMIRGE {
    tag "$meta.id"
    label 'process_single'

    // TODO nf-core: List required Conda package(s).
    //               Software MUST be pinned to channel (i.e. "bioconda"), version (i.e. "1.10").
    //               For Conda, the build (i.e. "h9402c20_2") must be EXCLUDED to support installation on different operating systems.
    // TODO nf-core: See section in main README for further information regarding finding and adding container addresses to the section below.
    conda "bioconda::emirge=0.61.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/emirge:0.61.1--py27h59c9234_6':
        'quay.io/biocontainers/emirge:0.61.1--py27h59c9234_6' }"

    input:
    // TODO nf-core: Where applicable all sample-specific information e.g. "id", "single_end", "read_group"
    //               MUST be provided as an input via a Groovy Map called "meta".
    //               This information may not be required in some instances e.g. indexing reference genome files:
    //               https://github.com/nf-core/modules/blob/master/modules/nf-core/bwa/index/main.nf
    // TODO nf-core: Where applicable please provide/convert compressed files as input/output
    //               e.g. "*.fastq.gz" and NOT "*.fastq", "*.bam" and NOT "*.sam" etc.
    tuple val(meta), val(sample_id),path(R1),path(R2),val(max_read_len),val(ins_size),val(ins_stdev),val(iter_arg),val(ssu_fa),val(ssu_db) 


    output:
    // TODO nf-core: Named file extensions MUST be emitted for ALL output channels
    tuple val(meta), val(sample_id)
    //,path('emirge_out.fa'), emit: fa
    //path('*.alignment_summary.txt'), emit: txt
    path('SUCCESS_*')
    // TODO nf-core: List additional required output channels/values here
    //path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    // TODO nf-core: Where possible, a command MUST be provided to obtain the version number of the software e.g. 1.10
    //               If the software is unable to output a version number on the command-line then it can be manually specified
    //               e.g. https://github.com/nf-core/modules/blob/master/modules/nf-core/homer/annotatepeaks/main.nf
    //               Each software used MUST provide the software name and version number in the YAML version file (versions.yml)
    // TODO nf-core: It MUST be possible to pass additional parameters to the tool as a command-line string via the "task.ext.args" directive
    // TODO nf-core: If the tool supports multi-threading then you MUST provide the appropriate parameter
    //               using the Nextflow "task" variable e.g. "--threads $task.cpus"
    // TODO nf-core: Please replace the example samtools command below with your module's command
    // TODO nf-core: Please indent the command appropriately (4 spaces!!) to help with readability ;)
    
    //#emirge_rename_fasta.py emirge/iter.${iter_arg} > emirge_out.fa 2>>SUCCESS_step4_emirge
    //#zgrep '^# ' emirge/iter.10/bowtie.iter.10.log.gz > alignment_text.csv
    //#echo "${sample_id}\t\$(grep -oP ' alignment: \\K(\\d+)\\s' alignment_text.csv)" >> ${sample_id}.alignment_summary.txt
    //#echo "COMPLETED Step4 (EMIRGE) : ${sample_id}" >> SUCCESS_step4_emirge


    //#cat <<-END_VERSIONS > versions.yml
    //#"${task.process}":
    //#    emirge: \$(echo \$(emirge -v 2>&1) )
    //#END_VERSIONS
    

    """
    emirge_amplicon.py emirge -l ${max_read_len} -i ${ins_size} -s ${ins_stdev} --phred33 -n ${iter_arg} -a ${task.cpus} -f ${ssu_fa} -b ${ssu_db} -1 ${R1} -2 ${R2}  2>> SUCCESS_step4_emirge
    """
}
