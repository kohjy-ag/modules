#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { EMIRGE_EMIRGE } from '../../../../modules/emirge/emirge/main.nf'

workflow test_emirge_emirge {
    
    input = [
        [ id:'test' ], // meta map
        "sample",
        file("/home/ubuntu/test_step3_preFilter/ERR1712460_1.subsampled.fastq.gz", checkIfExists: true),
        file("/home/ubuntu/test_step3_preFilter/ERR1712460_2.subsampled.fastq.gz", checkIfExists: true),
        151,200,40,10,
        file("/home/ubuntu/SILVA_138_SSURef_NR99_tax_silva_trunc.fasta",checkIfExists: true),
        "/home/ubuntu/SILVA_138_SSURef_NR99_tax_silva_trunc"
    ]

    EMIRGE_EMIRGE ( input )
}
